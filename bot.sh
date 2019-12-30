#! /usr/bin/sh

# Check display server
DISPLAY_SERVER=""
if [ "$(ps -e | grep -w Xorg)" ]
then
	DISPLAY_SERVER=xorg
else
	DISPLAY_SERVER=other
fi

# Check if nescessary tools are installed on the system
[ ! -e /bin/xdotool ] && [ ! -e /usr/bin/xdotool ] && printf "\e[31;1mPlease install xdotool (https://github.com/jordansissel/xdotool)\e[m\n" && exit 1

# Only check for ydotool if not using XOrg
[ "$DISPLAY_SERVER" == "other" ] && [ ! -e /bin/ydotool ] && [ ! -e /usr/bin/ydotool ] && printf "\e[31;1mPlease install ydotool if you are not using XOrg (https://github.com/ReimuNotMoe/ydotool)\e[m\n" && exit 1

if [ "$DISPLAY_SERVER" == "other" ]
then
	# Find out if yhe ydotoold daemon is already running
	if [ ! "$(ps -e | grep -w ydotoold)" ]
	then
		# Start daemon silently
		ydotoold 2> /dev/null &
		printf "\e[33;1mStarted ydotool daemon manually\e[m\n"
	else
		printf "\e[33;1mFound running ydotool daemon\e[m\n"
	fi
fi

# *** Definitions ***
# Delay between keystrokes in milliseconds (-k)
keystroke_delay=10
# Time to wait before typing after focusing on window (-f)
focus_delay=0.2
# Time to wait for website to download (-d)
download_delay=1

# Terminal window ID
term_win_id=""
# Typeracer window ID
tr_win_id=""
# Race text
to_type=""

# Function to divide two numbers (okay, you could have probably guessed that)
divide()
{
	echo $1 $2 | awk '{ printf "%f", $1 / $2 }'
}

# *** Read Arguments ***
print_help()
{
	echo "Format:"
	printf "\t$0 \e[3margument value\e[m\n"
	echo ""
	echo "All values given in seconds support floating point values (for example 0.1)"
	echo ""
	echo "Options:"
	printf "\t-k, --keystroke_delay \e[3mmilliseconds\e[m\tdelay between keystrokes (default 10)\n"
	printf "\t-w, --words_per_minute \e[3mwords\e[m\t\ttries to estimate the keystroke delay to achieve the given WPM value\n"
	printf "\t-c, --characters_per_minute \e[3mcharacters\e[m\ttries to estimate the keystroke delay to achieve the given CPM value\n"
	printf "\n"
	printf "\t-f, --focus_delay \e[3mseconds\e[m\t\tdelay to begin with keystrokes after window refocus (default 0.2)\n"
	printf "\t-d, --download_delay \e[3mseconds\e[m\t\ttime to wait for website download (default 1)\n"
}

# n is the argument parameter's index, not that of the argument itself
n=2
for a in $*
do
	if [ $a == "--help" ] || [ $a == "-h" ]
	then
		print_help
		exit 0
	elif [ $a == "--words_per_minute" ] || [ $a == "-w" ]
	then
		if [ ! ${!n} ]
		then
			printf "\t-w, --words_per_minute \e[3mwords\e[m\t\ntries to estimate the keystroke delay to achieve the given WPM value\n"
			exit 0
		fi
		# delay ~ 11700 / WPM
		keystroke_delay=$(divide 11700 ${!n})
	elif [ $a == "--characters_per_minute" ] || [ $a == "-c" ]
	then
		if [ ! ${!n} ]
		then
			printf "Option:\n\t-c, --characters_per_minute \e[3mcharacters\e[m\ntries to estimate the keystroke delay to achieve the given CPM value\n"
			exit 0
		fi
		# delay ~ 58500 / CPM
		keystroke_delay=$(divide 58500 ${!n})
	elif [ $a == "--keystroke_delay" ] || [ $a == "-k" ]
	then
		if [ ! ${!n} ]
		then
			printf "Option:\n\t-k, --keystroke_delay \e[3mmilliseconds\e[m\ndelay between keystrokes (default 10)\n"
			exit 0
		fi
		keystroke_delay=${!n}
	elif [ $a == "--focus_delay" ] || [ $a == "-f" ]
	then
		if [ ! ${!n} ]
		then
			printf "Option:\n\t-f, --focus_delay \e[3mseconds\e[m\ndelay to begin with keystrokes after window refocus (default 0.1)\n"
			exit 0
		fi
		focus_delay=${!n}
	elif [ $a == "--download_delay" ] || [ $a == "-d" ]
	then
		if [ ! ${!n} ]
		then
			printf "Option:\n\t-d, --download_delay \e[3mseconds\e[m\ntime to wait for website download (default 1)\n"
			exit 0
		fi
		download_delay=${!n}
	fi
	n=$(expr $n + 1)
done


# *** Clean up ***
rm -rf /tmp/tr-bot

# *** Get the id of the terminal window and the firefox window with typeracer opened in it ***
term_win_id=$(xdotool getactivewindow)
tr_win_id=$(xdotool search --name "TypeRacer - Test your typing speed and learn to type faster. Free typing game and competition. Way more fun than a typing tutor! - Mozilla Firefox")

if [ $tr_win_id ]
then
	printf "\e[32;1mFound Firefox window with typeracer\e[m\n"
else
	printf "\e[31;1mCould not find Firefox window with typeracer\e[m\n"
	exit 1
fi

# *** Fetch HTML ***
printf "\e[33;1mPress enter to start downloading HTML\e[m"
read

xdotool windowactivate $tr_win_id

if [ "$DISPLAY_SERVER" == "other" ]
then
	ydotool key Ctrl+s 2> /dev/null
else
	xdotool key Ctrl+s
fi

sleep $focus_delay

# Create /tmp/tr-bot to save some temporary files
[ -e /tmp/tr-bot ] || mkdir /tmp/tr-bot

# Type in the path to save the HTML file to
if [ "$DISPLAY_SERVER" == "other" ]
then
	ydotool type "/tmp/tr-bot/tr" 2> /dev/null
	ydotool key Enter 2> /dev/null
else
	xdotool type "/tmp/tr-bot/tr"
	xdotool key Return 2> /dev/null
fi

sleep $download_delay

# *** Extract text to type out of HTML
# Create a copy of typeracer.html without newlines and save it to typerace.html.no_nl
cat /tmp/tr-bot/tr.html | tr -d "\n" > /tmp/tr-bot/tr.html.no_nl

# * Match regexes to find text *
# First letter
to_type+=$(grep /tmp/tr-bot/tr.html.no_nl -o -e "<span unselectable=\"on\" class=\"\w\{8\} \w\{8\}\">\([^<]\|$\)\+" | cut -b 51)
# Other letters of first word
to_type+=$(grep /tmp/tr-bot/tr.html.no_nl -o -e "<span unselectable=\"on\" class=\"\w\{8\}\">\([^<]\|$\)\+" | cut -b 42-)
# Rest of text
to_type+=$(grep /tmp/tr-bot/tr.html.no_nl -o -e "<span unselectable=\"on\">\([^<]\|$\)\+" | cut -b 25-)

printf "\e[32;1mGoing to type:\e[m\n\e[3m${to_type}\e[m\n"

# *** Type text ***
# Set focus to terminal window
xdotool windowactivate $term_win_id
printf "\e[33;1mPress enter to start typing\e[m"
read

#Set focus to typeracer window
xdotool windowactivate $tr_win_id
sleep $focus_delay

# Truncate the floating point number for the keystroke delay
keystroke_delay=$(printf "$keystroke_delay" | cut -d "." -f 1)

#Type the race text
if [ "$DISPLAY_SERVER" == "other" ]
then
	ydotool type --key-delay $keystroke_delay "$to_type" 2> /dev/null
else
	# For some odd reason xdotool types with half the delay it actually should
	xdotool type --delay $(expr "$keystroke_delay" \* 2) "$to_type"
fi
