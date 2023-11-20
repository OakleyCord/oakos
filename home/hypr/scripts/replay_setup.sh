#!/bin/sh

# TODO: fix VERY rough way of getting mic and desktop audio 
pw-link alsa_input.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo:capture_FL alsa_output.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo:playback_FL
pw-link alsa_input.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo:capture_FR alsa_output.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo:playback_FR
pw-link alsa_output.pci-0000_07_00.6.analog-stereo:monitor_FL alsa_output.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo:playback_FL
pw-link alsa_output.pci-0000_07_00.6.analog-stereo:monitor_FR alsa_output.usb-Samson_Technologies_Samson_Go_Mic-00.analog-stereo:playback_FR
