# ~/.bash_functions file, to store functions
# created for the cli-productivity-config.

# Change Directory Below
function cdb() {
  select dir in $(find -type d -name "$1" -not -path '*/\.*' -prune);
  do
    cd "${dir}" && break;
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
  select dir in $(dirs -p | sort | uniq);
  do
    cd "${dir}" && break;
  done 
}
