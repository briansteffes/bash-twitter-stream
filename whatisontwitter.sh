#!/bin/bash

#|----------------------------------------------------------------------|
# @author:  Brian P. Steffes                                            |
# @date:    June 1, 2016                                                |
# @script:  twitter.sh                                                  |
#                                                                       |
# @description:                                                         |
#                                                                       |
# Script that reads a stream from twitter and produces a formated       |
# output.                                                               |
#|----------------------------------------------------------------------|

# ///////---------------------------------------------------------------->|
# Date Codes
# date "+%B %d, %Y"-> June 3, 2016 (for message file)
# date "+%m%d%Y.txt" -> 06302015.txt (for message file name)
# date "+%Y-%m-%d %H:%M:%S" -> 2016-06-03 13:29:57 (logfile)
# |<----------------------------------------------------------------//////


# Global Variables
# ///////---------------------------------------------------------------->|
MY_STREAMS="streams.txt"
MY_LOG="logfile.txt"
CURRENT_MESSAGES="messages.txt"
STREAM_URL=""
STREAM_SUBJECT=""
# TODO: Needs to update during a session in the event that user adds new streams.
RECORDS=$( awk 'BEGIN{count=0};{count++};END{print count}' $MY_STREAMS)
HTML="twitter.html"
EXCLUDED="exluded_words.txt"
# |<----------------------------------------------------------------///////





# Script Variables
to_exit=1

# Provide menu for the program
clear
printf "\n\nWelcome to the twitter web scraping bash script!\n"
printf "Please select an option to continue:\n"

until (( $to_exit == 0 ));do
cat <<EOF
	1. Read a Stream
	2. View a Summary Statistics
	3. Other
	4. Exit
EOF
read choice


#TODO: Take arguments for options 1 and 2 and perform error checking before passing them into 
#		the approiate scripts
case $choice in
	1 ) echo "You have chosen to read a twitter stream."
		sh ./read_stream.sh "$RECORDS" 
		
		;;

	2 ) echo "You have chosen to view summary statistics"
		sh ./display_stats.sh
		
		;;

	3 ) echo "You have chosen 'Other'"
		
		cat <<-EOF
			a. View Logfile
			b. View Excluded Words
			c. Add Words to Excluded Words
			d. Remove Words From Excluded Words
		EOF
		read choice2

		case $choice2 in
			a ) echo "View Logfile"
				cat "$MY_LOG"
				;;
			b ) echo "View Excluded Words"
				cat "$EXCLUDED"
				;;
			c ) echo "Update Excluded Words"
				;;
			d ) echo "Update Excluded Words"
				;;
			* ) exit
		esac
		;;



	4 ) echo "It appears that you are done using the streaming program."
		echo "Good Bye!"
		exit
		;;
	* )	echo "Invalid Option please try again"
esac
done


