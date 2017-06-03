function editadd --description 'Edit File and then Git Add with Status'
	editor "$argv"
	git add "$argv"
	git status -s
end
