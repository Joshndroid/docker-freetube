FROM ubuntu:26.04
ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------
# Install X11 + TigerVNC + noVNC + audio + app deps
# -------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xvfb \
        x11-xserver-utils \
        openbox \
        tigervnc-standalone-server \
        tigervnc-common \
        novnc \
        websockify \
        pulseaudio \
        curl \
        wget \
        ca-certificates \
        libasound2t64 \
        libnss3 \
        libxss1 \
        libatk-bridge2.0-0t64 \
        libgtk-3-0t64 \
        libgbm1 \
        libxshmfence1 && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# Install FreeTube (pinned to latest known good release)
# -------------------------------------------------------
RUN wget https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.13-beta/freetube_0.23.13_beta_amd64.deb \
        -O /tmp/freetube.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends /tmp/freetube.deb && \
    rm /tmp/freetube.deb && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# Create kiosk startup script
# -------------------------------------------------------
RUN mkdir -p /opt/kiosk
COPY start.sh /opt/kiosk/start.sh
RUN chmod +x /opt/kiosk/start.sh

# -------------------------------------------------------
# Expose noVNC port (browser) and VNC port (native client)
# -------------------------------------------------------
EXPOSE 6901
EXPOSE 5901

ENTRYPOINT ["/opt/kiosk/start.sh"]
