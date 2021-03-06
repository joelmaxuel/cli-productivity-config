function clihelp --description 'Command Line Interface Help'
	echo -e '\r\fKeyboard Shortcuts:'
	echo -e '\tCTRL + C – Cancels current command'
	echo -e '\tCTRL + S – Repeats the last command with sudo';
	echo -e '\tCTRL + L – Provide directory listing in current working directory';
	echo -e '\tCTRL + U – Cuts text up until the cursor'
	echo -e '\tCTRL + K – Cuts text from the cursor until the end of the line'
	echo -e '\tCTRL + W – Cut word behind cursor'
	echo -e '\tCTRL + Y – Pastes text'
	echo -e '\tCTRL + E – Move cursor to end of line'
	echo -e '\tCTRL + A – Move cursor to the beginning of the line'
	echo -e '\tALT + Backspace – Delete previous word'
	echo -e '\tCTRL + Left – Move cursor one word to the left'
	echo -e '\tCTRL + Right – Move cursor one word to the right'
	echo -e '\tHome – Move cursor to beginning of line'
	echo -e '\tEnd – Move cursor to end of the line'
	echo -e '\tTab – Autocomplete current command/argument'
	echo -e '\r\f'
end
