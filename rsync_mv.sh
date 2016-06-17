#!/bin/bash

if [ -z "$RSYNC_MV_OPTS" ]
  RSYNC_MV_OPTS="-a -P"
  
  ##For some version for RSYNC
  RSYNC_MV_MV_CMD="--remove-source-files"
  ##For other versions of rsync
  #RSYNC_MV_MV_CMD="--remove-sent-files" #some documentation says --delete-sent-files
  ##TODO: Add rsync feature detection or version detection
  
fi

rsync $RSYNC_MV_OPTS $@
echo "Rsync frist pass complete, Running again while removing source files"
if rsync $RSYNC_MV_OPTS $RSYNC_MV_MV_CMD $@
then
  echo "Rsync second pass complete. Removing Empty Directories"
  ## Iterate so rsync_mv behaves with mutiple sources
  while [ ! -z "$2" ]
  do
  ##Remove Empty Directories, which should be empty after rsync
    find "$1" -type d -empty -delete

  ##Shift the parameters left, so "$3" becomes "$2" and "$2" becomes "$1"
  shift
  done
  exit 0;
else
  echo ERROR: Failed Command: rsync -a -P --remove-source-files $@
  echo No proceding to remove old directory
  exit 1;
fi


