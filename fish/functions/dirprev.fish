function dirprev

	set -l criteriaunit ""
	set -l criteriavalue 0
	set -l valuemodifier 1
	set -l entryerror 0
	set -l findfilter ""
	set -l recursive "-maxdepth 1 "
	set -l lsoptions ""
	set -l reinteger '^[0-9]+$'
	set -l i 1

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
			case -r
				set recursive ""
			case -l
				set lsoptions "-l "
			case -rl
				set recursive ""
				set lsoptions "-l "
			case -lr
				set recursive ""
				set lsoptions "-l "
			case '*'
				set findfilter "-iname '$argv[$i]' "
				if test (count $argv) -gt $i
					switch $argv[(math $i+1)]
						case -r
							set recursive ""
						case -l
							set lsoptions "-l "
						case -rl
							set recursive ""
							set lsoptions "-l "
						case -lr
							set recursive ""
							set lsoptions "-l "
					end
				end
			end
		end
	end
	
	switch $entryerror
		case 0
			set -l findparams $recursive$findfilter$criteriaunit +$criteriavalue
			set -l findcommand ""
			if test "$recursive" = "" -o "$lsoptions" = "-l "
				set findcommand "find . $findparams -type f -not -path '*/\.*' -prune -exec ls $lsoptions-F --color -d '{}' \;"
				eval $findcommand
			else
				set findcommand "find . $findparams -type f -not -path '*/\.*' -prune -exec ls -F --color -d '{}' \;"
				eval $findcommand | perl -lne 's/((?:\e\[\d+(?:;\d+)?m)*)(?:\.\/)?([^\e]{20})[^\e]*(?:\.\/)?(.*)/$1$2...$3/s;s/((?:\e\[\d+(?:;\d+)?m)*)(?:\.\/)?(.*)/$1$2/s;print' | column -x
			end
		case 1
			echo "Invalid Unit Specified."
		case 2 
			echo "Invalid Integer Value."
		case * 
			echo "Unknown Error."
	end

	if test $entryerror -ne 0
		echo
		echo "Usage: dirprev <unit> <value> ['namefilter'] [-lr]"
		echo
		echo Units:
		echo -e "\t m \t minutes"
		echo -e "\t h \t hours"
		echo -e "\t d \t days \t\t D \t days since midnight"
		echo -e "\t w \t weeks \t\t W \t weeks since midnight"
		echo
		echo Optional Parameters:
		echo -e "\t -l \t list view"
		echo -e "\t -r \t recursive search"
		echo -e "\t -lr \t combined"
		echo
		return 1
	end
	return 0

end
