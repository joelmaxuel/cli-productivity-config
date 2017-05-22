# ~/.bash_functions file, to store functions
# created for the cli-productivity-config.

# Change Directory Below
function cdb() {
  select dir in $(find -type d -name "$1" -not -path '*/\.*' -prune);
  do
    cd "${dir}" && break;
  done 
}
