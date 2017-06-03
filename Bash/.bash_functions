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
  if [ -e $1 ]; then 
    pushd $1 &> /dev/null   #dont display current stack 
  fi
}

# Menu-based Change Directory
function mcd() {
  select dir in $(dirs -p -l | sort | uniq);
  do
    command cd "${dir}" && break;
  done 
}

# Command Line Interface Help
function clihelp() {
  echo -e '\r\fKeyboard Shortcuts:';
  echo -e '\tCTRL + C – Cancels current command';
  echo -e '\tCTRL + S – Repeats the last command with sudo';
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
function mkd() {
	mkdir -p "$@" && cd "$@"
}
