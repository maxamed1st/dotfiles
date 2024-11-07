#!/bin/bash

# Change left_control+left-option+g to ~
xdotool keyup --clearmodifiers g ctrl+alt
xdotool keydown --clearmodifiers apostrophe

# Change left-control+left_option+2 to ´
xdotool keyup --clearmodifiers 2 ctrl+alt
xdotool keydown --clearmodifiers equal

# Change left-control+2 to '
xdotool keyup --clearmodifiers 2 ctrl
xdotool keydown --clearmodifiers backslash

# Change left-option+h to *
xdotool keyup --clearmodifiers h alt
xdotool keydown --clearmodifiers KP_Multiply

# Change left-option+k to angle brackets
xdotool keyup --clearmodifiers k alt
xdotool keydown --clearmodifiers bar

# Change left-option+o to ö
xdotool keyup --clearmodifiers o alt
xdotool keydown --clearmodifiers semicolon

# Change left-option+a to å
xdotool keyup --clearmodifiers a alt
xdotool keydown --clearmodifiers bracketleft

# Change left-option+shift+a to ä
xdotool keyup --clearmodifiers a shift+alt
xdotool keydown --clearmodifiers quote

# Change left-option+t to tab
xdotool keyup --clearmodifiers t alt
xdotool keydown --clearmodifiers Tab

# Change left-option+j to comma
xdotool keyup --clearmodifiers j alt
xdotool keydown --clearmodifiers comma

# Change left-option+s to plus sign
xdotool keyup --clearmodifiers s alt
xdotool keydown --clearmodifiers minus

# Change left-option+c to underscore
xdotool keyup --clearmodifiers c alt
xdotool keydown --clearmodifiers shift+slash

# Change left-option+f to dash
xdotool keyup --clearmodifiers f alt
xdotool keydown --clearmodifiers slash

# Change left-option+d to questionmark
xdotool keyup --clearmodifiers d alt
xdotool keydown --clearmodifiers shift+minus

# Change plus sign (+) to delete_or_backspace
xdotool keyup --clearmodifiers minus
xdotool keydown --clearmodifiers BackSpace

# Change ö to return
xdotool keyup --clearmodifiers semicolon
xdotool keydown --clearmodifiers Return

# Change comme to spacebar
xdotool keyup --clearmodifiers comma
xdotool keydown --clearmodifiers space

# Change left_control+hjkl to arrow keys
xdotool keyup --clearmodifiers h ctrl
xdotool keydown --clearmodifiers Left
xdotool keyup --clearmodifiers j ctrl
xdotool keydown --clearmodifiers Down
xdotool keyup --clearmodifiers k ctrl
xdotool keydown --clearmodifiers Up
xdotool keyup --clearmodifiers l ctrl
xdotool keydown --clearmodifiers Right
