FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------
# Install minimal X11 + XWayland + KasmVNC dependencies
# -------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xserver-xorg-video-dummy \
        x11-xserver-utils \
        xwayland \
        xvfb \
        openbox \
        curl \
        wget \
        ca-certificates \
        libasound2 \
        libnss3 \
        libxss1 \
        libatk-bridge2.0-0 \
        libgtk-3-0 \
        libgbm1 \
        libxshmfence1 && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# Install KasmVNC
# -------------------------------------------------------
RUN wget https://github.com/kasmtech/KasmVNC/releases/latest/download/kasmvncserver_ubuntu.deb -O /tmp/kasmvnc.deb && \
    dpkg -i /tmp/kasmvnc.deb || apt-get -f install -y && \
    rm /tmp/kasmvnc.deb

# -------------------------------------------------------
# Install FreeTube (latest .deb)
# -------------------------------------------------------
RUN wget https://github.com/FreeTubeApp/FreeTube/releases/latest/download/freetube_amd64.deb -O /tmp/freetube.deb && \
    dpkg -i /tmp/freetube.deb || apt-get -f install -y && \
    rm /tmp/freetube.deb

# -------------------------------------------------------
# Create kiosk startup script
# -------------------------------------------------------
RUN mkdir -p /opt/kiosk
COPY start.sh /opt/kiosk/start.sh
RUN chmod +x /opt/kiosk/start.sh

# -------------------------------------------------------
# Expose VNC/WebSocket port
# -------------------------------------------------------
EXPOSE 6901

# -------------------------------------------------------
# Start KasmVNC + FreeTube kiosk
# -------------------------------------------------------
ENTRYPOINT ["/opt/kiosk/start.sh"]
