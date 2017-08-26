function cptoday
	find * -maxdepth 0 -mmin -(math (math (date +%s)-(date -d "(date +%F) 0" +%s))/60) -type f -exec cp '{}' $argv[1] \;
end
