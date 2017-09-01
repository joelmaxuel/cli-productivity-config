function act-core

	set -l origcmd $argv[1]
	set -l findirection $argv[2]

	set -l criteriaunit ""
	set -l criteriavalue 0
	set -l valuemodifier 1
	set -l entryerror 0
	set -l findfilter ""
	set -l actioncmd ""
	set -l actiondest ""
	set -l recursive "-maxdepth 1 "
	set -l actquiet 0
	set -l reinteger '^[0-9]+$'
	set -l i 3

		if test (count $argv) -gt 0
		switch $argv[$i]
			case m
				set criteriaunit "-mmin"
			case h
				set criteriaunit "-mmin"
				set valuemodifier 60
			case d
				set criteriaunit "-mtime"
			case D
				set criteriaunit "-daystart -mtime"
			case w
				set criteriaunit "-mtime"
				set valuemodifier 7
			case W
				set criteriaunit "-daystart -mtime"
				set valuemodifier 7
			case '*'
				set entryerror 1
		end
	else
		set entryerror 1
	end

	if test $entryerror -eq 0
		if test (count $argv) -gt $i
			set i (math $i+1)
			if echo "$argv[$i]" | grep -q -E $reinteger
				set criteriavalue (math $argv[$i] '*' $valuemodifier)
			else
				set entryerror 2
			end
		else
			set entryerror 2
		end
	end

	if test $entryerror -eq 0
		if test (count $argv) -gt $i
			set i (math $i+1)
			switch $argv[$i]
				case cp mv
					set actioncmd $argv[$i]
					if test (count $argv) -gt $i
						set i (math $i+1)
						set actiondest $argv[$i]
						if test ! -d $actiondest
							set entryerror 4
						end
					else
						set entryerror 4
					end
				case rm
					set actioncmd $argv[$i]
				case '*'
					set entryerror 3
			end
		else
			set entryerror 3
		end
	end

	if test $entryerror -eq 0
		if test (count $argv) -gt $i
			set i (math $i+1)
			switch $argv[$i]
			case -r
				set recursive ""
			case -q
				set actquiet 1
			case -rq
				set recursive ""
				set actquiet 1
			case -qr
				set recursive ""
				set actquiet 1
			case '*'
				set findfilter "-iname '$argv[$i]' "
				if test (count $argv) -gt $i
					switch $argv[(math $i+1)]
						case -r
							set recursive ""
						case -q
							set actquiet 1
						case -rq
							set recursive ""
							set actquiet 1
						case -qr
							set recursive ""
							set actquiet 1
					end
				end
			end
		end
	end

	switch $entryerror
		case 0
			set -l findparams "$recursive$findfilter$criteriaunit $findirection$criteriavalue"
			set -l findcommand ""
			if test $actquiet -eq 0
				echo Action: $actioncmd
				echo The following files will be affected:
				set findcommand "find . $findparams -type f -not -path '*/\.*' -prune -exec ls -F --color -d '{}' \;"
				eval $findcommand
				read -l -p "echo -e 'Do you wish to continue? [yes|no]: '" yno
				switch $yno
					case y Y yes Yes YES YEs yES yeS
						set findcommand "find . $findparams -type f -not -path '*/\.*' -prune -exec $actioncmd '{}' $actiondest \;"
						eval $findcommand
					case '*'
						echo "Abort."
				end
			else
				set findcommand "find . $findparams -type f -not -path '*/\.*' -prune -exec $actioncmd '{}' $actiondest \;"
				eval $findcommand
			end
		case 1
			echo "Invalid Unit Specified."
		case 2
			echo "Invalid Integer Value."
		case 3
			echo "No Recognizable Action."
		case 4
			echo "Invalid Destination Directory."
		case '*'
			echo "Unknown Error."
	end

	if test $entryerror -ne 0
		echo
		echo "Usage: $origcmd <unit> <value> <action> [destination] ['namefilter'] [-qr]"
		echo
		echo Units:
		echo -e "\t m \t minutes"
		echo -e "\t h \t hours"
		echo -e "\t d \t days \t\t D \t days since midnight"
		echo -e "\t w \t weeks \t\t W \t weeks since midnight"
		echo
		echo Actions:
		echo -e "\t cp \t copy"
		echo -e "\t mv \t move"
		echo -e "\t rm \t remove"
		echo
		echo Optional Parameters:
		echo -e "\t -q \t quiet mode*"
		echo -e "\t -r \t recursive search"
		echo -e "\t -qr \t combined"
		echo
		echo -e "* Intended for automated/unattended processes - always verify any action"
		echo
		return 1
	end
	return 0

end
