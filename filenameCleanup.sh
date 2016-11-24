#!/bin/sh

#Remove Underscores from filenames. Run this until no output.
cd "$1"
find `pwd` -iname '*_*' -print0 | xargs -0 -I {} -n 1 rename -v 's/_/ /g' "{}" 2>/dev/null
while test `find \`pwd\` -iname \'*_*\' -print0 | xargs -0 -I {} -n 1 rename -v \'s/_/ /g\' \"{}\" 2>/dev/null | wc -l ` != 0 ; do echo "Processing again"; done;
