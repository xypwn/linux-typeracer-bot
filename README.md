# Linux Typeracer Bot
A simple typeracer bot for Linux, written in shell

[![Video](https://i.imgur.com/icj1mHj.png)](https://i.imgur.com/viohEQ2.mp4)
## General Notes
* Currently only works on Linux using Firefox
* You will need [xdotool](https://github.com/jordansissel/xdotool) for this program to work
  * It should be available in you distro's repos under the name `xdotool`
* If you are not using Xorg, you will also need [ydotool](https://github.com/ReimuNotMoe/ydotool)
  * You need to **restart** after installing ydotool in order to access /dev/uinput
  * You also need to be using the `US keyboard layout`
## Installation and Basic Usage
* open a terminal emulator
  * if you are not on X.Org, launch your terminal emulator with `env GDK_BACKEND=x11 terminal-name` so that it uses XWayland
* clone the repo using `git clone https://github.com/xypwn/linux-typeracer-bot.git`
* cange directory into the new folder `cd linux-typeracer-bot`
* open firefox and visit [typeracer.com](https://play.typeracer.com)
* make sure to have the typeracer tab selected, then execute the script with `sh bot.sh`
  * if you want, you can type `sh bot.sh --help` to get some configuration options
* press `Enter` **after you have joined the race** to retrieve it's text
* press `Enter` again **after the race has started** to make the bot start to type
* you can use the `-w`, `-c` or `-k` option to modify the words per minute, chars per minute or delay between simulated keystrokes
## Troubleshooting
* try `sh bot.sh --help` to get all possible command-line options (and possibly tweak them if it doesn't work properly)
