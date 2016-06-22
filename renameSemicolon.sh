#!/bin/bash

echo This finds files ending in ;1
echo I can't explain why I have a bunch of files with this name.
echo but it fixes it.
echo Use: run this in the current directory

 find .  -type f -name '*;1' -print0 | while read -d $'\0' f; do new=$(echo $f | sed 's/;1//g') ; mv -v "$f" "$new" ; done;
 
 
 renameSemicolon
 
