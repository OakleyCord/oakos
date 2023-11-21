#!/bin/sh
notify-send Replay "Recorded last 30s"
# TODO: add env variable for main monitor description so each host can define
wl-screenrec -o $(hyprctl monitors -j | jq -r '.[] | select(.description | startswith("ASUSTek COMPUTER INC VG279QR M4LMQS260906")) | .name') --audio --audio-device replay-sink.monitor --history 30 -f ~/Videos/replays/REPLAY_$(date +%m-%d-%y_%T).mp4 &

