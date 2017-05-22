function cdb --description 'Change Directory Below command'
	set -l all_dirs (find -type d -name "$argv[1]" -not -path '*/\.*' -prune)
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

	# Automatically go to directory if only one result
    if test $dirc -eq 1
		cd $all_dirs[1]
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

    # Ask the user which directory from their results they want to cd to.
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
            cd $all_dirs[$choice]
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
