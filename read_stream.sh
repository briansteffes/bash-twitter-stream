#!/bin/bash
# Stream Reading Script that is called fro mthe the main script

write_log() {
	log_date=$( date "+%Y-%m-%d %H:%M:%S" )
	byte_count=$( wc -c "twitter.html" | awk '{print $1}' )
	printf "%s\t%s\t%s\t%s\n" "$log_date" "$stream_url" "twitter.html" "$byte_count" >> "logfile.txt"
}



clear
to_exit=1
printf "\nReading a new Twitter Stream:\nPlease Choose One of the Following:\n"

until (( $to_exit == 0 ));do
cat <<EOF
	1. Enter a New Stream
	2. Examine Previously used Stream
	3. Return to Main Menu
EOF
read choice


case $choice in
	1 ) printf "Looks like we will be examining a new stream\n"
		
		#TODO: implement loop to confirm that these are the correct values
		#		especially in regards to the url.
		printf "Enter Stream Subject:\n*(No Commas)\n"
		read stream_subject
		#TODO: Check for the presence of commas and return error if there are any
		printf "please enter the stream url:\n"
		read stream_url

		#append information to streams.txt
		printf "%s,%s\n" "$stream_subject" "$stream_url" >> "streams.txt"
		to_exit=0
		
		
		;;


	2 ) printf "Available Streams:\n"
		printf "There are %i streams to choose from:\n" $1 #Record Number
		awk 'BEGIN {
				 FS = ","
				 count = 1
			}
			{ 
				printf "\t%i. %s\n", count, $1 
				count++
			}
			END {
				printf "Choose an option by entering the line number:\n"
			}' "streams.txt"
		read stream_id						#Using numbers to minimize user error.

		#Must be numeric and in the correct range.
		if echo $stream_id | grep -q '^[1-9]*$' && (("$stream_id" <= "$1"))
		then 
			stream_url=$( sed -n "${stream_id}p" "streams.txt" | awk -F, '{print $2}' )
			stream_subject=$( sed -n "${stream_id}p" "streams.txt" | awk -F, '{print $1}' )
			to_exit=0
		else 
			#TODO: use looping to allow user to try again.
			echo "Invalid Choice. Goodbye!"
			exit
		fi

		;;

	3 ) echo -e "Appears you are done for now.\n\n Good bye!\n"
		exit
		;;
esac
done

#Define file name
file_subject=$( echo "$stream_subject" | sed 's/ /_/g' )
file_date=$( date "+%m%d%Y.txt" )
MESSAGE_FILE=$( printf "%s_%s\n" $file_subject $file_date )

#TODO: Check if it already exists.
#		This will be the case if the twitter stream is called on more than once a day.

#url has been properly loaded now pass into web scraping program.q
TEMP="temp.txt"
message_date=$( date "+%B %d, %Y" )
printf "%s\t%s Twitter Stream\n\n" " $message_date $stream_subject" > "$MESSAGE_FILE"
lynx -source "$stream_url" | grep 'TweetTextSize' | sed 's/<[^>]*>//g' >> "$MESSAGE_FILE"
sed -nf twitter.sed "$MESSAGE_FILE" > "$TEMP"
rm "$MESSAGE_FILE"
mv "$TEMP" "$MESSAGE_FILE"

write_log


#----------------------------------------------------------------------------------------------

# Display a summary of the word counts to standard out
cat "$MESSAGE_FILE" | sed -n '3,$p' | tr -d '[:punct:]' | awk 'BEGIN { RS = " " };{ print $1 }' | sort | uniq -c | sort -nr | head -20 > "$TEMP"
#TODO: Currently does not negate the words from excluded list.
awk 'BEGIN {
		printf "%-20s%-20s%-20s\n", "Top words", "Frequencey", "Percentage"
		hash = "----------"
		printf "%-20s%-20s%-20s\n", hash,hash,hash
		count = 1
	}
	{
		printf "%2s. %-17s%-20i%-20s\n", count, $2, $1, "0.00%"
		count++
	}' "$TEMP"

