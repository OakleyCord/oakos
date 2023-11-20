#!/bin/sh
notify-send Replay "Recorded last 30s"
wl-screenrec -o DP-4 --audio --audio-device alsa_output.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo.monitor --history 30 -f ~/Videos/replays/REPLAY_$(date +%m-%d-%y_%T).mp4 &
