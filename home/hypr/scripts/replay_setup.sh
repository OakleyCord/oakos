#!/bin/sh

# TODO: trigger again automatically on changed defaults + remove previous links

# remove previously created virtual sinks
pactl unload-module module-null-sink

# create a virtual sink
pactl load-module module-null-sink media.class=Audio/Sink sink_name=replay-sink channel_map=stereo


# map default sink and default source into virtual sink
DEFAULT_SINK=$(pactl info | grep 'Default Sink' | cut -d':' -f 2)
DEFAULT_SOURCE=$(pactl info | grep 'Default Source' | cut -d':' -f 2)




pw-link ${DEFAULT_SOURCE}:capture_FL replay-sink:playback_FL
pw-link ${DEFAULT_SOURCE}:capture_FR replay-sink:playback_FR

pw-link ${DEFAULT_SINK}:monitor_FL replay-sink:playback_FL
pw-link ${DEFAULT_SINK}:monitor_FR replay-sink:playback_FR
