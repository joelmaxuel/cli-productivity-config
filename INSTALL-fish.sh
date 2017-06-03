#!/bin/sh

echo
echo CLI Productivity Config - Install Script for fish
echo
echo Checking for fish config directory ...

if [ ! -d ~/.config/fish ];
then
    mkdir ~/.config/fish
fi

echo
echo Copying functions ...

if [ ! -d ~/.config/fish/functions ];
then
    mkdir ~/.config/fish/functions
fi

cp ./fish/functions/* ~/.config/fish/functions/

echo
echo Done ... Enjoy!
echo
