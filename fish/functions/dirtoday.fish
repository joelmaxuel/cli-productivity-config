function dirtoday
	find * -maxdepth 0 -mmin -(math (math (date +%s)-(date -d "(date +%F) 0" +%s))/60) -exec ls -F --color -d '{}' \; | perl -lne 's/((?:\e\[\d+(?:;\d+)?m)*)([^\e]{20})[^\e]*(.*)/$1$2...$3/s; print' | column -x
end
