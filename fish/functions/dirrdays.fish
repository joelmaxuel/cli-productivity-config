function dirrdays
	find * -mtime -$argv[1] -type f -not -path '*/\.*' -prune -exec ls -F --color '{}' \;
end
