# Unix Typeracer Bot
A simple typeracer bot for Linux/BSD, written in shell

[![Video](https://i.imgur.com/icj1mHj.png)](https://i.imgur.com/viohEQ2.mp4)
## General Notes
* Works with firefox only but adding support for other browsers should be rather easy
* Tested on linux but might work on mac as well
* You will need [xdotool](https://github.com/jordansissel/xdotool) for this program to work
  * It should be available in you distro's repos under the name `xdotool`
## Basic Usage
* open a terminal emulator
* clone the repo using `git clone https://github.com/xypwn/unix-typeracer-bot.git`
* cange directory into the new folder `cd unix-typeracer-bot`
* open firefox and visit [typeracer.com](https://play.typeracer.com)
* make sure to have the typeracer tab selected, then execute the script with `sh bot.sh`
  * if you want, you can type `sh bot.sh --help` to get some configuration options
* press `Enter` _after you have joined the race_ to retrieve the race text
* press `Enter` again _after the race has started_ to make the bot start to type
* you can use the `-w`, `-c` or `-k` option to modify the words per minute, chars per minute or delay between key presses
## Troubleshooting
* try `sh bot.sh --help` to get all possible command-line options (and possibly tweak them if it doesn't work properly)
