# ~/.bash_functions file, to store functions
# created for the cli-productivity-config.

# Change Directory Below
function cdb() {
  select dir in $(find -type d -name "$1" -not -path '*/\.*' -prune);
  do
    command cd "${dir}" && break;
  done 
}

#let cd also pushd directories into stack. Use popd to reverse stack
function cd ()
{
  if [ $# -eq 0 ]; then
    pushd $HOME &> /dev/null
    command cd $HOME && return 0;
  fi
  if [ -e $1 ]; then 
    pushd $1 &> /dev/null   #dont display current stack 
  fi
}

# Menu-based Change Directory
function mcd() {
  CWD=$PWD
  select dir in $(dirs -p -l | sort | uniq);
  do
    command cd "${dir}"
	pushd $CWD &> /dev/null
	break
  done 
}

# Command Line Interface Help
function clihelp() {
  echo -e '\r\fKeyboard Shortcuts:';
  echo -e '\tCTRL + C – Cancels current command';
  echo -e '\tCTRL + S – Repeats the last command with sudo';
  echo -e '\tCTRL + L – Provide directory listing in current working directory';
  echo -e '\tCTRL + U – Cuts text up until the cursor';
  echo -e '\tCTRL + K – Cuts text from the cursor until the end of the line';
  echo -e '\tCTRL + W – Cut word behind cursor';
  echo -e '\tCTRL + Y – Pastes text';
  echo -e '\tCTRL + E – Move cursor to end of line';
  echo -e '\tCTRL + A – Move cursor to the beginning of the line';
  echo -e '\tALT + Backspace – Delete previous word';
  echo -e '\tCTRL + Left – Move cursor one word to the left';
  echo -e '\tCTRL + Right – Move cursor one word to the right';
  echo -e '\tHome – Move cursor to beginning of line';
  echo -e '\tEnd – Move cursor to end of the line';
  echo -e '\tTab – Autocomplete current command/argment';
  echo -e '\r\f';
}

# Edit File and then Git Add with Status
function editadd() {
  editor "$1"
  git add "$1"
  git status -s
}

# Make Directory and then Go Into
function mked() {
	mkdir -p "$@" && cd "$@"
}

# Track runtime of a program and return one value on exit
function timer() {
	/usr/bin/time -f "\t Ran for %E min:sec" "$@"
}

# Directory listing with columns and colour
function dirw() {
	ls -F --color $@ | perl -lne 's/((?:\e\[\d+(?:;\d+)?m)*)([^\e]{20})[^\e]*(.*)/$1$2...$3/s; print' | column -x
}

# Directory listing of recent time frame
function dirlast() {
	set -f
	criteriaunit=""
	criteriavalue=0
	valuemodifier=1
	entryerror=0
	findfilter=""
	recursive="-maxdepth 1"
	lsoptions=""
	reinteger='^[0-9]+$'

	case "$1" in
		m) 
			criteriaunit="-mmin";;
		h) 
			criteriaunit="-mmin"
			valuemodifier=60;;
		d) 
			criteriaunit="-mtime";;
		D) 
			criteriaunit="-daystart -mtime";;
		w) 
			criteriaunit="-mtime"
			valuemodifier=7;;
		W) 
			criteriaunit="-daystart -mtime"
			valuemodifier=7;;
		*)
			entryerror=1;;
	esac

	if [ $entryerror -eq 0 ]; then
		shift
		if [[ $1 =~ $reinteger ]]; then criteriavalue=$(($1*$valuemodifier)); else entryerror=2; fi
	fi
	if [ $entryerror -eq 0 ]; then
		shift
		if [ "$1" != "" ]; then
			case "$1" in
			-r)
				recursive="";;
			-l)
				lsoptions=" -l";;
			-rl)
				recursive=""
				lsoptions=" -l";;
			-lr)
				recursive=""
				lsoptions=" -l";;
			*)
				findfilter="-iname $1"
				case "$2" in
					-r)
						recursive="";;
					-l)
						lsoptions=" -l";;
					-rl)
						recursive=""
						lsoptions=" -l";;
					-lr)
						recursive=""
						lsoptions=" -l";;
				esac
			esac
		fi
	fi
	
	case "$entryerror" in
		0) if [ "$recursive" == "" ] || [ "$lsoptions" == " -l" ]; then
				find . $recursive $findfilter $criteriaunit -$criteriavalue -type f -not -path '*/\.*' -prune -exec ls $lsoptions -F --color -d {} \;
			else
				find . $recursive $findfilter $criteriaunit -$criteriavalue -type f -not -path '*/\.*' -prune -exec ls -F --color -d {} \; | perl -lne 's/((?:\e\[\d+(?:;\d+)?m)*)(?:\.\/)?([^\e]{20})[^\e]*(?:\.\/)?(.*)/$1$2...$3/s;s/((?:\e\[\d+(?:;\d+)?m)*)(?:\.\/)?(.*)/$1$2/s;print' | column -x
			fi;;
		1) echo "Invalid Unit Specified.";;
		2) echo "Invalid Integer Value.";;
		*) echo "Unknown Error.";;
	esac
	set +f
	if [ $entryerror -ne 0 ]; then
		echo
		echo "Usage: dirlast <unit> <value> ['namefilter'] [-lr]"
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
	fi
	return 0
}

# Directory listing of previous time frame
function dirprev() {
	set -f
	criteriaunit=""
	criteriavalue=0
	valuemodifier=1
	entryerror=0
	findfilter=""
	recursive="-maxdepth 1"
	lsoptions=""
	reinteger='^[0-9]+$'

	case "$1" in
		m) 
			criteriaunit="-mmin";;
		h) 
			criteriaunit="-mmin"
			valuemodifier=60;;
		d) 
			criteriaunit="-mtime";;
		D) 
			criteriaunit="-daystart -mtime";;
		w) 
			criteriaunit="-mtime"
			valuemodifier=7;;
		W) 
			criteriaunit="-daystart -mtime"
			valuemodifier=7;;
		*)
			entryerror=1;;
	esac

	if [ $entryerror -eq 0 ]; then
		shift
		if [[ $1 =~ $reinteger ]]; then criteriavalue=$(($1*$valuemodifier)); else entryerror=2; fi
	fi
	if [ $entryerror -eq 0 ]; then
		shift
		if [ "$1" != "" ]; then
			case "$1" in
			-r)
				recursive="";;
			-l)
				lsoptions=" -l";;
			-rl)
				recursive=""
				lsoptions=" -l";;
			-lr)
				recursive=""
				lsoptions=" -l";;
			*)
				findfilter="-iname $1"
				case "$2" in
					-r)
						recursive="";;
					-l)
						lsoptions=" -l";;
					-rl)
						recursive=""
						lsoptions=" -l";;
					-lr)
						recursive=""
						lsoptions=" -l";;
				esac
			esac
		fi
	fi
	
	case "$entryerror" in
		0) if [ "$recursive" == "" ] || [ "$lsoptions" == " -l" ]; then
				find . $recursive $findfilter $criteriaunit +$criteriavalue -type f -not -path '*/\.*' -prune -exec ls $lsoptions -F --color -d {} \;
			else
				find . $recursive $findfilter $criteriaunit +$criteriavalue -type f -not -path '*/\.*' -prune -exec ls -F --color -d {} \; | perl -lne 's/((?:\e\[\d+(?:;\d+)?m)*)(?:\.\/)?([^\e]{20})[^\e]*(?:\.\/)?(.*)/$1$2...$3/s;s/((?:\e\[\d+(?:;\d+)?m)*)(?:\.\/)?(.*)/$1$2/s;print' | column -x
			fi;;
		1) echo "Invalid Unit Specified.";;
		2) echo "Invalid Integer Value.";;
		*) echo "Unknown Error.";;
	esac
	set +f
	if [ $entryerror -ne 0 ]; then
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
	fi
	return 0
}

# Set action for files of recent time frame
function actlast() {
	set -f
	criteriaunit=""
	criteriavalue=0
	valuemodifier=1
	entryerror=0
	findfilter=""
	actioncmd=""
	actiondest=""
	recursive="-maxdepth 1"
	actquiet=0
	reinteger='^[0-9]+$'

	case "$1" in
		m) 
			criteriaunit="-mmin";;
		h) 
			criteriaunit="-mmin"
			valuemodifier=60;;
		d) 
			criteriaunit="-mtime";;
		D) 
			criteriaunit="-daystart -mtime";;
		w) 
			criteriaunit="-mtime"
			valuemodifier=7;;
		W) 
			criteriaunit="-daystart -mtime"
			valuemodifier=7;;
		*)
			entryerror=1;;
	esac

	if [ $entryerror -eq 0 ]; then
		shift
		if [[ $1 =~ $reinteger ]]; then criteriavalue=$(($1*$valuemodifier)); else entryerror=2; fi
	fi
	
	if [ $entryerror -eq 0 ]; then
		shift
		case "$1" in
			cp|mv) 
				actioncmd=$1
				actiondest=$2
				if ! [ -d $actiondest ]; then entryerror=4; fi
				shift;;
			rm) 
				actioncmd=$1;;
			*)
				entryerror=3;;
		esac
	fi

	if [ $entryerror -eq 0 ]; then
		shift
		if [ "$1" != "" ]; then
			case "$1" in
			-r)
				recursive="";;
			-q)
				actquiet=1;;
			-rq)
				recursive=""
				actquiet=1;;
			-qr)
				recursive=""
				actquiet=1;;
			*)
				findfilter="-iname $1"
				case "$2" in
				-r)
					recursive="";;
				-q)
					actquiet=1;;
				-rq)
					recursive=""
					actquiet=1;;
				-qr)
					recursive=""
					actquiet=1;;
				esac
			esac
		fi
	fi
	
	case "$entryerror" in
		0) if [ $actquiet -eq 0 ]; then
				echo Action: $actioncmd
				echo The following files will be affected:
				find . $recursive $findfilter $criteriaunit -$criteriavalue -type f -not -path '*/\.*' -prune -exec ls -F --color -d {} \;
				echo -en "Do you wish to continue? [yes|no]: "
				read yno
				case $yno in
					[yY] | [yY][Ee][Ss] )
						find . $recursive $findfilter $criteriaunit -$criteriavalue -type f -not -path '*/\.*' -prune -exec $actioncmd {} $actiondest \;;;
					*) echo "Abort.";;
				esac
			else
				find . $recursive $findfilter $criteriaunit -$criteriavalue -type f -not -path '*/\.*' -prune -exec $actioncmd {} $actiondest \;
			fi;;
		1) echo "Invalid Unit Specified.";;
		2) echo "Invalid Integer Value.";;
		3) echo "No Recognizable Action.";;
		4) echo "Invalid Destination Directory.";;
		*) echo "Unknown Error.";;
	esac
	set +f
	if [ $entryerror -ne 0 ]; then
		echo
		echo "Usage: actlast <unit> <value> <action> [destination] ['namefilter'] [-qr]"
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
		echo -e "\t -q \t quiet mode"
		echo -e "\t -r \t recursive search"
		echo -e "\t -qr \t combined"
		echo
		return 1
	fi
	return 0
}

# Set action for files of previous time frame
function actprev() {
	set -f
	criteriaunit=""
	criteriavalue=0
	valuemodifier=1
	entryerror=0
	findfilter=""
	actioncmd=""
	actiondest=""
	recursive="-maxdepth 1"
	actquiet=0
	reinteger='^[0-9]+$'

	case "$1" in
		m) 
			criteriaunit="-mmin";;
		h) 
			criteriaunit="-mmin"
			valuemodifier=60;;
		d) 
			criteriaunit="-mtime";;
		D) 
			criteriaunit="-daystart -mtime";;
		w) 
			criteriaunit="-mtime"
			valuemodifier=7;;
		W) 
			criteriaunit="-daystart -mtime"
			valuemodifier=7;;
		*)
			entryerror=1;;
	esac

	if [ $entryerror -eq 0 ]; then
		shift
		if [[ $1 =~ $reinteger ]]; then criteriavalue=$(($1*$valuemodifier)); else entryerror=2; fi
	fi
	
	if [ $entryerror -eq 0 ]; then
		shift
		case "$1" in
			cp|mv) 
				actioncmd=$1
				actiondest=$2
				if ! [ -d $actiondest ]; then entryerror=4; fi
				shift;;
			rm) 
				actioncmd=$1;;
			*)
				entryerror=3;;
		esac
	fi

	if [ $entryerror -eq 0 ]; then
		shift
		if [ "$1" != "" ]; then
			case "$1" in
			-r)
				recursive="";;
			-q)
				actquiet=1;;
			-rq)
				recursive=""
				actquiet=1;;
			-qr)
				recursive=""
				actquiet=1;;
			*)
				findfilter="-iname $1"
				case "$2" in
				-r)
					recursive="";;
				-q)
					actquiet=1;;
				-rq)
					recursive=""
					actquiet=1;;
				-qr)
					recursive=""
					actquiet=1;;
				esac
			esac
		fi
	fi
	
	case "$entryerror" in
		0) if [ $actquiet -eq 0 ]; then
				echo Action: $actioncmd
				echo The following files will be affected:
				find . $recursive $findfilter $criteriaunit +$criteriavalue -type f -not -path '*/\.*' -prune -exec ls -F --color -d {} \;
				echo -en "Do you wish to continue? [yes|no]: "
				read yno
				case $yno in
					[yY] | [yY][Ee][Ss] )
						find . $recursive $findfilter $criteriaunit +$criteriavalue -type f -not -path '*/\.*' -prune -exec $actioncmd {} $actiondest \;;;
					*) echo "Abort.";;
				esac
			else
				find . $recursive $findfilter $criteriaunit +$criteriavalue -type f -not -path '*/\.*' -prune -exec $actioncmd {} $actiondest \;
			fi;;
		1) echo "Invalid Unit Specified.";;
		2) echo "Invalid Integer Value.";;
		3) echo "No Recognizable Action.";;
		4) echo "Invalid Destination Directory.";;
		*) echo "Unknown Error.";;
	esac
	set +f
	if [ $entryerror -ne 0 ]; then
		echo
		echo "Usage: actprev <unit> <value> <action> [destination] ['namefilter'] [-qr]"
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
		echo -e "\t -q \t quiet mode"
		echo -e "\t -r \t recursive search"
		echo -e "\t -qr \t combined"
		echo
		return 1
	fi
	return 0
}
