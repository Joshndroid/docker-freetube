#!/bin/bash

# Start a virtual X11 display
Xvfb :0 -screen 0 1920x1080x24 &

# Start KasmVNC server
kasmvncserver --bind 0.0.0.0 --port 6901 --display :0 &

# Optional: minimal WM for window focus handling
openbox &

# Launch FreeTube in kiosk mode
export DISPLAY=:0
freetube --kiosk --no-sandbox
