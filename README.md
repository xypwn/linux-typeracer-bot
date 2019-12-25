# Linux Typeracer Bot
A simple typeracer bot for Linux, written in shell

[![Video](https://i.imgur.com/icj1mHj.png)](https://i.imgur.com/viohEQ2.mp4)
## General Notes
* Works with firefox only but adding support for other browsers should be rather easy
* Works on Linux and BSD (and possibly MacOS) when using [X.Org Display Server](https://www.x.org)
* You will need [xdotool](https://github.com/jordansissel/xdotool) for this program to work
  * It should be available in you distro's repos under the name `xdotool`
* If you are not using Xorg, you will also need [ydotool](https://github.com/ReimuNotMoe/ydotool)
## Installation and Basic Usage
* open a terminal emulator
* clone the repo using `git clone https://github.com/xypwn/linux-typeracer-bot.git`
* cange directory into the new folder `cd unix-typeracer-bot`
* open firefox and visit [typeracer.com](https://play.typeracer.com)
* make sure to have the typeracer tab selected, then execute the script with `sh bot.sh`
  * if you want, you can type `sh bot.sh --help` to get some configuration options
* press `Enter` **after you have joined the race** to retrieve it's text
* press `Enter` again **after the race has started** to make the bot start to type
* you can use the `-w`, `-c` or `-k` option to modify the words per minute, chars per minute or delay between simulated keystrokes
## Troubleshooting
* try `sh bot.sh --help` to get all possible command-line options (and possibly tweak them if it doesn't work properly)
