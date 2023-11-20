#!/bin/sh
notify-send Replay "Recorded last 30s"
wl-screenrec -o DP-4 --audio --history 30 -f ~/Videos/replays/REPLAY_$(date +%m-%d-%y_%T).mp4 &
