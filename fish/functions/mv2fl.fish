function mv2fl --description 'Move Files in Working Directory to One by First Letter'

	if test (count $argv) -eq 0 -o x"$argv[1]" = x"--help" -o x"$argv[1]" = x"-h"
		echo
		echo -e "Copy Files in Working Directory to One by First Letter"
		echo -e "Part of the CLI Productivity Config, 2018"
		echo
		echo -e "Usage: mv2fl destination [\"source filter\"] [mv-specific params]"
		echo -e "       Destination uses the first-letter format for matching final path"
		echo -e "       Source Filter assumes all non-hidden files when not defined"
		echo
		return 0
	end

	set -l given_dest $argv[1]
	set -l given_args (count $argv)
	set -l given_filter "*"
	set -l given_extras ""
	if test $given_args -gt 1
		set given_filter $argv[2]
	end
	if test $given_args -gt 2
		set given_extras $argv[3..-1]
	end
	
	fl-core mv $given_dest $given_filter $given_extras
	
end

