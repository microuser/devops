#!/bin/bash

if [ -z "$RSYNC_MV_OPTS" ]
then
  RSYNC_MV_OPTS="-a -P"
  
  ##For some version for RSYNC
  RSYNC_MV_MV_CMD="--remove-source-files"
  ##For other versions of rsync
  #RSYNC_MV_MV_CMD="--remove-sent-files" #some documentation says --delete-sent-files
  ##TODO: Add rsync feature detection or version detection
  
fi



if rsync $RSYNC_MV_OPTS $@
then
  echo "Rsync frist pass complete, Running again while removing source files"
  if rsync $RSYNC_MV_OPTS $RSYNC_MV_MV_CMD $@
  then
    echo "Rsync second pass complete."
    ## Iterate so rsync_mv behaves with mutiple sources
    while [ ! -z "$2" ]
    do
    ##Remove Empty Directories, which should be empty after rsync, only if they are a directory
      if [ -d $1 ]
      then
         echo Removing Empty Directory: $1
        find "$1" -type d -empty -delete -print
      fi
    ##Shift the parameters left, so "$3" becomes "$2" and "$2" becomes "$1"
    shift
    done
    exit 0;
  else
    echo ERROR: Failed Command: rsync -a -P --remove-source-files $@
    echo No proceding to remove old directory
    exit 1;
  fi
else
  echo "ERROR Failed Command: rsync firstpass: $@"
fi

