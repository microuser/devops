#!/bin/bash
function regex { 
	if [ "$1" == "-f" ] ; then
		# test with ...
		# echo '#!#hello#=#world#;#' > $0.mem
		# regex -f $0.mem '.*#!#(.+)#=#(.+)#;#.*' 2
		#
		cat "$2" | gawk 'match($0,/'$3'/, ary) {print ary['${4:-'0'}']}' | head -n 1; 
	else
		# test with...
		#echo '#!#hello#=#world#;#' | regex '.*#!#(.+)#=#(.+)#;#.*' 2
		#
		gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}' | head -n 1; 
	fi
}
