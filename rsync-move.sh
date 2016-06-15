#!/bin/sh

rsync -a -P --remove-source-files \
$1 \
user@centric:/media/$2/$2/$3 && date && echo "Done Moving Files. Removing empty directories" && find $1 -depth -type d -empty -delete




