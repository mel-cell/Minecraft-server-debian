FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LIBVA_DRIVER_NAME=i965

# Update and install basic dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    software-properties-common \
    ca-certificates \
    libva-drm2 \
    libva-x11-2 \
    mesa-va-drivers \
    intel-media-va-driver \
    i965-va-driver \
    vainfo \
    mesa-utils \
    xvfb \
    x11-xserver-utils \
    openbox \
    pulseaudio \
    dbus-x11 \
    libxcb-xinerama0 \
    libopengl0 \
    qt6-base-dev \
    libqt6widgets6 \
    python3 \
    curl \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Sunshine
RUN wget https://github.com/LizardByte/Sunshine/releases/download/v0.23.1/sunshine-ubuntu-22.04-amd64.deb \
    && apt-get update && apt-get install -y ./sunshine-ubuntu-22.04-amd64.deb \
    && rm sunshine-ubuntu-22.04-amd64.deb

# Install Dependencies for Prism Launcher and AppImage
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    openjdk-21-jre \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libqt6gui6 \
    libqt6core6 \
    libqt6widgets6 \
    && rm -rf /var/lib/apt/lists/*

# Download and Extract Prism Launcher
RUN mkdir -p /opt/prismlauncher && cd /opt/prismlauncher \
    && APPIMAGE_URL=$(curl -s https://api.github.com/repos/PrismLauncher/PrismLauncher/releases/latest | grep "browser_download_url" | grep "x86_64.AppImage" | head -n 1 | cut -d '"' -f 4) \
    && wget -O PrismLauncher.AppImage "$APPIMAGE_URL" \
    && chmod +x PrismLauncher.AppImage \
    && ./PrismLauncher.AppImage --appimage-extract \
    && ln -s /opt/prismlauncher/squashfs-root/AppRun /usr/local/bin/prismlauncher

# Setup user
RUN groupadd -f render && useradd -m -u 1003 -G video,render,audio mel-gaming

# Copy start script
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER mel-gaming
WORKDIR /home/mel-gaming

ENTRYPOINT ["/entrypoint.sh"]
