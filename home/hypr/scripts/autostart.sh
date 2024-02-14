#!/bin/sh

# waybar
waybar &

# widgets
eww daemon &

# wallpaper
swww init &

# ROG
rog-control-center &


# Replays
~/.config/hypr/scripts/replay_setup.sh &
~/.config/hypr/scripts/replay_start.sh &
