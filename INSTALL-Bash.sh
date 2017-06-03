#!/bin/sh

echo
echo CLI Productivity Config - Install Script for Bash
echo
echo Backing up bashrc ...

cp ~/.bashrc ~/.bashrc-bak

echo
echo Copying new bashrc and functions ...

cp ./Bash/.bashrc ~/
cp ./Bash/.bash_functions ~/

echo
echo Done ... Enjoy!
echo
