#!/bin/bash

# Define display
export DISPLAY=:1
export PULSE_SERVER=unix:/tmp/pulseaudio.socket

# 1. Start Xvfb (Virtual Monitor)
Xvfb :1 -screen 0 1920x1080x24 +extension GLX +extension RENDER -noreset &
sleep 2

# 2. Start PulseAudio
pulseaudio --start --exit-idle-time=-1
pactl load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket
# Create null sink for audio streaming
pactl load-module module-null-sink sink_name=Sunshine-Audio sink_properties=device.description=Sunshine-Audio

# 3. Start Window Manager (Openbox)
openbox-session &

# 4. Start Sunshine
# Configuration will be created in ~/.config/sunshine/ by default
sunshine &

# 5. Open Prism Launcher in background (optional, or wait for user to open via stream)
# prismlauncher &
# Log stdout to see what's happening
tail -f /dev/null
