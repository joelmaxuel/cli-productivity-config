function cpdays
	find * -maxdepth 0 -mtime -$argv[1] -type f -exec cp '{}' $argv[2] \;
end
