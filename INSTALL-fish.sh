#!/bin/sh

echo
echo CLI Productivity Config - Install Script for fish
echo
echo Checking for fish functions directory ...

if [ ! -d ~/.config/fish/functions ];
then
    mkdir -p ~/.config/fish/functions
fi

echo
echo Copying functions ...

cp ./fish/functions/* ~/.config/fish/functions/

echo
echo Done ... Enjoy!
echo
