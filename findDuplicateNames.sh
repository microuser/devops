#!/bin/bash

#Use Apt-get to install fdupes if they are available
which apt-get || which fdupes || sudo apt-get install fdupes

fdupes -r -l $@

#fdupes -r $@ | { 
#  while IFS= read -r file; do [[ "$file" ]] && du "$file" ; done  
#  } | sort


exit 0
