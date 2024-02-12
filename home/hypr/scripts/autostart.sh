#!/bin/sh


# polkit
# /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1 &

# widgets
eww daemon &

# wallpaper
swww init &

# ROG
rog-control-center &


# Replays
~/.config/hypr/scripts/replay_setup.sh &
~/.config/hypr/scripts/replay_start.sh &
