function fl-core
	set -l given_args (count $argv)
	set -l given_action $argv[1]
	set -l initial_path $argv[2]
	set -l given_pre ""
	set -l given_post ""
	if test $given_args -gt 2
		set given_pre $argv[3]
	end
	if test $given_args -gt 3
		set given_post $argv[4..-1]
	end
	set -l initial_char ""
	set -l next_level ""
	set -l low_level 0
	set -l operate_find 0
	set -l final_path ""
	set -l working_path ""
	set -l findcommand ""
	
	if test $HOME = (string sub -s 1 -l (string length $HOME) $initial_path)
		set initial_path ~(string trim -l -c $HOME $initial_path)
	end
	
	for i in (seq 1 (string length $initial_path))
		set initial_char (string sub -s $i -l 1 $initial_path)
		set low_level 0
		set operate_find 0
		switch $initial_char
			case '.'
				set next_level ".."
			case '/'
				set next_level "/"
				set low_level 1
			case '~'
				set next_level "~"
				set low_level 1
			case '*'
				set next_level $initial_char
				set operate_find 1
		end
		if test \( $low_level -eq 1 \) -a \( $i -eq 1 \)
			set final_path[1] $next_level
			if test $final_path = "~"
				set final_path "$HOME/"
			end
		else
			if test $operate_find -eq 1
				set working_path
				for j in (seq 1 (count $final_path))
					set findcommand "find -L $final_path[$j] -maxdepth 1 -type d -name '$next_level*'"
					if test -z $working_path[1]
						set working_path (eval $findcommand 2>&1 | grep -v "Permission denied")
					else
						set working_path $working_path (eval $findcommand 2>&1 | grep -v "Permission denied")
					end
					set klimit (count $working_path)
					set k 1
					while test $klimit -ge $k
						if test $final_path[$j] = $working_path[$k]
							set -e working_path[$k]
							set klimit (math $klimit-1)
						else
							set k (math $k+1)
						end
					end
				end
			else
				for j in (seq 1 (count $final_path))
					if test $final_path[$j] = ""
						set working_path[$j] $next_level
					else
						set working_path[$j] $final_path[$j]/$next_level
					end
				end
			end
			set final_path $working_path
		end
	end

	set -l all_dirs $final_path
    if not set -q all_dirs[1]
        echo (_ 'No matches found.')
        return 0
    end

    set -l letters a b c d e f g h i j k l m n o p q r s t u v w x y z
    set -l dirc (count $all_dirs)
    if test $dirc -gt (count $letters)
        set -l msg (_ 'Too many results.  Truncating.')
        printf "$msg\n"
        set -l msg (_ 'There are %s unique dirs in your results but I can only handle %s')
        printf "$msg\n" $dirc (count $letters)
        set dirc (count $letters)
    end

	# Automatically if only one result
    if test $dirc -eq 1
		eval $given_action $given_post $given_pre $all_dirs[1]
        return 0
    end
	
    # Print the matching directories.
    for i in (seq 1 $dirc)
        set -l dir $all_dirs[$i]
        set -l label_color normal
        set -q fish_color_cwd; and set label_color $fish_color_cwd
        set -l dir_color_reset (set_color normal)
        set -l dir_color

        printf '%s %s %2d) %s %s%s%s\n' (set_color $label_color) $letters[$i] $i (set_color normal) $dir_color $dir $dir_color_reset
    end

    # Ask the user which directory from their results they want
    set -l msg (_ 'Select directory by letter or number: ')
    read -l -p "echo '$msg'" choice
    if test "$choice" = ""
        return 0
    else if string match -q -r '^[a-z]$' $choice
        # Convert the letter to an index number.
        set choice (contains -i $choice $letters)
    end

    set -l msg (_ 'Error: expected a number between 1 and %d or letter in that range, got "%s"')
    if string match -q -r '^\d+$' $choice
        if test $choice -ge 1 -a $choice -le $dirc
            eval $given_action $given_post $given_pre $all_dirs[$choice]
            return
        else
            printf "$msg\n" $dirc $choice
            return 1
        end
    else
        printf "$msg\n" $dirc $choice
        return 1
    end
end
