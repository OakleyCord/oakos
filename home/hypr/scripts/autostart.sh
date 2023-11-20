#!/bin/sh


# polkit
# /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1 &


# waybar
# started by nix config
# waybar &

# widgets
eww daemon &

# wallpaper
swww init &

# notifications
dunst &

# Networking
nm-applet --indicator &

# ROG
rog-control-center &


# Replays
~/.config/hypr/scripts/replay_start.sh &
