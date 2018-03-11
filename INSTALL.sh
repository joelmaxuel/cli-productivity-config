#!/bin/bash

echo
echo CLI Productivity Config
echo Complete Install Script
echo =======================
echo
echo
echo Any inputs provided in this script, unless otherwise stated, require only a single character response.
echo
echo -n Proceeding to display the RELEASE document.  Press a key to continue, and then press q once finished reading the RELEASE.
read -n 1 -p " "
less RELEASE

echo
echo
echo Do you wish to install CLIPC for Bash [b], fish [f], both [a], or neither [n]\?
read -n 1 -p "Choose [a/b/f/n], default: [a] > " choice_instmode

if [[ "$choice_instmode" = "" ]]; then
	choice_instmode="a"
else
	echo
fi

case "$choice_instmode" in
	a) 
		choice_instbash="y"
		choice_instfish="y";;
	b) 
		choice_instbash="y"
		choice_instfish="n";;
	f) 
		choice_instbash="n"
		choice_instfish="y";;
	n) 
		choice_instbash="n"
		choice_instfish="n";;
    *)
		choice_instbash="n"
		choice_instfish="n";;
esac
echo

if [[ "$choice_instbash" = "y" ]]; then
	echo Backing up bashrc ...

	cp ~/.bashrc ~/.bashrc-bak

	echo
	echo Copying new bashrc and functions ...

	cp ./Bash/.bashrc ~/
	cp ./Bash/.bash_functions ~/

	echo Done.
	echo
fi

if [[ "$choice_instfish" = "y" ]]; then
	echo Checking for fish functions directory ...

	if [ ! -d ~/.config/fish/functions ];
	then
		mkdir -p ~/.config/fish/functions
	fi

	echo
	echo Copying functions ...

	cp ./fish/functions/* ~/.config/fish/functions/

	echo Done.
	echo
fi

echo Do you want to install the script tools as noted in the RELEASE document\?
read -n 1 -p "Choose [y/n], default: [y] > " choice_instscript
echo
if [[ "$choice_instscript" == "" || "$choice_instscript" == "y" || "$choice_instscript" == "Y" ]];
then
    echo Please type in destination for these scripts \(or press enter to accept the default\).
    echo If entering your own, do not leave a trailing slash.
	read -p "Default: [~/bin] > " string_instdest
	echo
	if [[ "$string_instdest" == "" ]]; then
		string_instdest="~/bin"
	fi
	#if [[ $string_instdest == \~* ]]; then
	string_instreal=$(eval echo $string_instdest)
	#fi
	choice_global="n"
	choice_instsudo="n"
	if [[ $string_instdest != /home/* && $string_instdest != \~/* ]]; then
		choice_global="y"
		if [ $USER != "root" -a $0 != "bash" ]; then
			choice_instsudo="y"
		fi
	fi
	if [[ "$choice_instsudo" == "y" ]]; then
		echo A quick analysis of the destination provided \(and current environment\) suggests superuser privileges may be needed.  If already running as root or via sudo, choose [n] below.  If unsure, accept the default [y], but this step may still fail, particularly if you are not a sudoer.
	else
		echo A quick analysis of the destination provided \(if any\) as well as to see if you are already using sudo, suggests superuser privileges are not needed.  If you believe you indeed need sudo for this step, choose [y] below.  If unsure, accept the default [n].
	fi
	read -n 1 -p "Choose [y/n], default: [$choice_instsudo] > " choice_usesudo
	echo
	if [[ ("$choice_instsudo" == "y" && "$choice_usesudo" == "") || "$choice_usesudo" == "y" || "$choice_usesudo" == "Y" ]];
	then
		if [ ! -d "$string_instreal" ];
		then
			sudo mkdir -p $string_instreal
			exit_status=$?
			sudo cp ./scripts/* $string_instreal/
			exit_status=`expr $exit_status + $?`
		else
			sudo cp ./scripts/* $string_instreal/
			exit_status=$?
		fi
	else
		if [ ! -d "$string_instreal" ];
		then
			mkdir -p $string_instreal
			exit_status=$?
			cp ./scripts/* $string_instreal/
			exit_status=`expr $exit_status + $?`
		else
			cp ./scripts/* $string_instreal/
			exit_status=$?
		fi
	fi
	echo
	if [ $exit_status -gt 0 ];
	then
		echo Issues identified while copying.  Please investigate and then re-run script.
		exit 1
	else
		echo Scripts copied.  Checking if necessary to define PATH...
		echo
		if echo $PATH | grep $string_instdest --quiet; then
			choice_inpath="y"
		else
			choice_inpath="n"
		fi
		if [[ "$choice_inpath" == "n" || "$choice_global" == "n" ]];
		then
			if [[ "$choice_instbash" == "y" ]]; then
				if ! grep --quiet $string_instdest ~/.bash_extras; then
					echo The Bash config appears to lack the path definition for $string_instdest.  Do you wish to add it\?
					read -n 1 -p "Choose [y/n], default: [y] > " choice_addpath
					echo
					if [[ "$choice_addpath" == "" || "$choice_addpath" == "y" || "$choice_addpath" == "Y" ]];
					then
						echo Adding $string_instdest to ~/.bash_extras...
						echo -e "PATH=\$PATH:$string_instdest" >> ~/.bash_extras
						echo Done.
						echo
					fi
				fi
			fi
			if [[ "$choice_instfish" == "y" ]]; then
				if ! grep --quiet $string_instdest ~/.config/fish/config.fish; then
					echo The fish config appears to lack the path definition for $string_instdest.  Do you wish to add it\?
					read -n 1 -p "Choose [y/n], default: [y] > " choice_addpath
					echo
					if [[ "$choice_addpath" == "" || "$choice_addpath" == "y" || "$choice_addpath" == "Y" ]];
					then
						echo Adding $string_instdest to ~/.config/fish/config.fish...
						echo -e "set -x PATH \$PATH $string_instdest" >> ~/.config/fish/config.fish
						echo Done.
						echo
					fi
				fi
			fi
		fi
	fi
fi

echo Install script complete.
echo Restart your shell \(type \'exec fish\' or \'bash\'\) or reload your terminal to enjoy!
echo
