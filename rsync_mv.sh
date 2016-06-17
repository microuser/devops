#!/bin/bash

if [ -z "$RSYNC_MV_OPTS" ]
  RSYNC_MV_OPTS="-a -P --remove-source-files"
fi

if rsync $RSYNC_MV_OPTS $@
then
  ## Iterate so rsync_mv behaves with mutiple sources
  while [ ! -z "$2" ]

  ##Remove Empty Directories, which should be empty after rsync
    find "$1" -type d -empty -delete

  ##Shift the parameters left, so "$3" becomes "$2" and "$2" becomes "$1"
  shift

else
  echo ERROR: Failed Command: rsync -a -P --remove-source-files $@
  echo No proceding to remove old directory
fi
