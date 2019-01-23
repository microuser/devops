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

function featureFlag {
	flagFile=$0.mem
	debugFeatureFlag="false"
	if [ "$debugFeatureFlag" == "true" ] ; then	cat $flagFile 2>/dev/null ; echo '. . . . ' Arg0:$0 ; echo '. . . . ' Arg1:$1; echo '. . . . ' Arg2:$2 ; echo '. . . . ' Args:$@ ; fi
	
	case "$1" in
	
	"")
		echo needs arguments like...
		echo featureFlag get arg1
		echo featureFlag set arg1 value1
		exit
		;;
	"get")
		if [ -r "$flagFile" ] ; then 
			regex -f "$flagFile" '.*#!#('"$2"')#=#(.+)#;#.*' 2
		else
			#atp flagFile not readable
			echo null
		fi
		;;
	"set")
	#if file is readable
	#then use our regex function (gawk and cat actually) to make capture groups from the regex, compare the variable name found to the one we are trying to set.
		if [ -r "$flagFile" ] ; then	
			capture=`regex -f "$flagFile" '.*#!#('"$2"')#=#(.*)#;#.*' 1`
			if [ "$debugFeatureFlag" == "true" ] ; then echo regex -f "$flagFile" '.*#!#('"$2"')#=#(.*)#;#.*' 1 has capture: $capture ; fi;
			if [ "$capture" == "$2" ] ; then
				#this can be improved by using sourounding regex capture groups and in place with line numbers known? something simpler?
				if [ "$debugFeatureFlag" == "true" ] ; then echo using simple value at end method with grep; fi ;
				if [ "$debugFeatureFlag" == "true" ] ; then echo cat "$flagFile" \| grep -v '#!#'$2'#=#' ; fi ;
				cat "$flagFile" | grep -v '#!#'$2'#=#'  > "$flagFile.new"
				echo '#!#'"$2"'#=#'"$3"'#;#' updated $(date +%Y-%m-%d-%H-%M-%S) >> "$flagFile.new" && mv "$flagFile.new" "$flagFile"
			else
				#atp "$capture"" != "$2"
				if [ "$debugFeatureFlag" == "true" ] ; then echo setting value first time, no previous values found ; fi ;
				echo "#!#""$2""#=#""$3""#;#" created $(date +%Y-%m-%d-%H-%M-%S) >>"$flagFile"
			fi
		else
			#flagFile not readable
			if [ "$debugFeatureFlag" == "true" ] ; then echo appending to $flagFile: "#!#""$2""#=#""$3""#;#" ; fi
			echo "#!#""$2""#=#""$3""#;#" iniciated $(date +%Y-%m-%d-%H-%M-%S) >>"$flagFile"
		fi
		;;
	esac	
}

