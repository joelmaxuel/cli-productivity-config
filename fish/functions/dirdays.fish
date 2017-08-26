function dirdays
	find * -maxdepth 0 -mtime -$argv[1] -exec ls -F --color -d '{}' \; | perl -lne 's/((?:\e\[\d+(?:;\d+)?m)*)([^\e]{20})[^\e]*(.*)/$1$2...$3/s; print' | column -x
end
