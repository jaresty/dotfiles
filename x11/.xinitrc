#!/bin/bash

# use Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# start ssh-agent
eval $(ssh-agent)

# autorandr -c

# exec /usr/bin/i3

xrandr --output DP-2 --primary --auto --rotate normal --output DP-0 --right-of DP-2 --rotate right
~/bin/set-bg

xsetwacom set "Wacom Intuos S Pen erasor" Mode Relative                                                                                                                                                                                                                                                                            ✔  16:50:20 
xsetwacom set "Wacom Intuos S Pen cursor" Mode Relative                                                                                                                                                                                                                                                                            ✔  16:50:27 
xsetwacom set "Wacom Intuos S Pen stylus" Mode Relative

exec /usr/bin/xmonad
# exec /usr/bin/awesome

# #!/bin/sh
#
# userresources=$HOME/.Xresources
# usermodmap=$HOME/.Xmodmap
# sysresources=/etc/X11/xinit/.Xresources
# sysmodmap=/etc/X11/xinit/.Xmodmap
#
# # merge in defaults and keymaps
#
# if [ -f $sysresources ]; then
#
#
#
#
#
#
#
#     xrdb -merge $sysresources
#
# fi
#
# if [ -f $sysmodmap ]; then
#     xmodmap $sysmodmap
# fi
#
# if [ -f "$userresources" ]; then
#
#
#
#
#
#
#
#     xrdb -merge "$userresources"
#
# fi
#
# if [ -f "$usermodmap" ]; then
#     xmodmap "$usermodmap"
# fi
#
# # start some nice programs
#
# if [ -d /etc/X11/xinit/xinitrc.d ] ; then
#  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
#   [ -x "$f" ] && . "$f"
#  done
#  unset f
# fi
#
# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
# exec i3
