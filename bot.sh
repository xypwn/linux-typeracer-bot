#! /usr/bin/sh

# *** Definitions ***
# Delay between keystrokes in milliseconds (-k)
keystroke_delay=10
# Time to wait before typing after focusing on window (-f)
focus_delay=0.1
# Time to wait for website to download (-d)
download_delay=1

term_win_id=""
tr_win_id=""
to_type=""

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
	printf "\t-f, --focus_delay \e[3mseconds\e[m\t\tdelay to begin with keystrokes after window refocus (default 0.1)\n"
	printf "\t-d, --download_delay \e[3mseconds\e[m\t\ttime to wait for website download (default 1)\n"
}

# n is the argument parameter's index, not the argument itself
n=2
for a in $*
do
	if [ $a == "--help" ] || [ $a == "-h" ]
	then
		print_help
		exit 0
	elif [ $a == "--words_per_minute" ] || [ $a == "-w" ]
	then
		# delay ~ 23400 / WPM
		keystroke_delay=$(expr 23400 / ${!n})
		if [ ! $keystroke_delay ]
		then
			print_help
			exit 0
		fi
	elif [ $a == "--characters_per_minute" ] || [ $a == "-c" ]
	then
		# delay ~ 117000 / CPM
		keystroke_delay=$(expr 117000 / ${!n})
		if [ ! $keystroke_delay ]
		then
			print_help
			exit 0
		fi
	elif [ $a == "--keystroke_delay" ] || [ $a == "-k" ]
	then
		keystroke_delay=${!n}
		if [ ! $keystroke_delay ]
		then
			print_help
			exit 0
		fi
	elif [ $a == "--focus_delay" ] || [ $a == "-f" ]
	then
		focus_delay=${!n}
		if [ ! $keystroke_delay ]
		then
			print_help
			exit 0
		fi
	elif [ $a == "--download_delay" ] || [ $a == "-d" ]
	then
		download_delay=${!n}
		if [ ! $keystroke_delay ]
		then
			print_help
			exit 0
		fi
	fi
	n=$(expr $n + 1)
done


# *** Clean up ***
rm -rf cache

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
xdotool key Ctrl+s

sleep $focus_delay

[ -e cache ] || mkdir cache

# Effectively the same as "xdotool type $(pwd)" but replaces /home/<username> with ~ for faster typing
xdotool type "$(echo $(pwd) | sed "s#${HOME}#~#g")/cache/typeracer"
xdotool key Return

sleep $download_delay

# *** Extract text to type out of HTML
# Create a copy of typeracer.html without newlines and save it to typerace.html.no_nl
cat cache/typeracer.html | tr -d "\n" > cache/typeracer.html.no_nl

# * Match regexes to find text *
# First letter
to_type+=$(grep cache/typeracer.html.no_nl -o -e "<span unselectable=\"on\" class=\"\w\{8\} \w\{8\}\">\([^<]\|$\)\+" | cut -b 51)
# Other letters of first word
to_type+=$(grep cache/typeracer.html.no_nl -o -e "<span unselectable=\"on\" class=\"\w\{8\}\">\([^<]\|$\)\+" | cut -b 42-)
# Rest of text
to_type+=$(grep cache/typeracer.html.no_nl -o -e "<span unselectable=\"on\">\([^<]\|$\)\+" | cut -b 25-)

printf "\e[32;1mGoing to type:\e[m\n\e[3m${to_type}\e[m\n"

# *** Type text ***
xdotool windowactivate $term_win_id
printf "\e[33;1mPress enter to start typing\e[m"
read

xdotool windowactivate $tr_win_id
sleep $focus_delay

xdotool type --delay $keystroke_delay "$to_type"
