#!/bin/bash
set -e

# Start PulseAudio for audio support
pulseaudio --start --exit-idle-time=-1

# Start virtual display
Xvfb :1 -screen 0 1920x1080x24 &
sleep 1

export DISPLAY=:1

# Start minimal window manager
openbox &

# Start TigerVNC on port 5901
tigervncserver :1 \
    -geometry 1920x1080 \
    -depth 24 \
    -localhost no \
    -SecurityTypes None \
    -rfbport 5901 \
    --I-KNOW-THIS-IS-INSECURE &
sleep 1

# Start noVNC on port 6901 (browser access)
websockify --web /usr/share/novnc \
    --wrap-mode=ignore \
    6901 localhost:5901 &

# Launch FreeTube in kiosk mode
exec freetube --kiosk --no-sandbox --disable-dev-shm-usage
