# docker image for Google Talk with Iceweasel

FROM debian:sid

MAINTAINER Tom Marble <tmarble@info9.net>

ADD https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /opt/google-talkplugin_current_amd64.deb

RUN 	apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
	ca-certificates \
	fonts-liberation \
	fonts-symbola \
	gconf-service \
        gir1.2-gstreamer-1.0 \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-good \
	hicolor-icon-theme \
        iceweasel \
        libcanberra-gtk-module \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
        libnss3 \
        libpango1.0-0 \
        libxcomposite1 \
        libxfixes3 \
        libxrandr2 \
	libxss1 \
	libxtst6 \
        libv4l-0 \
        lsb-release \
        procps \
        pulseaudio \
        pulseaudio-utils \
        pulseaudio-esound-compat \
        sudo \
	wget \
	xdg-utils \
        xfonts-terminus \
        xauth \
        xterm \
	--no-install-recommends && \
	dpkg -i '/opt/google-talkplugin_current_amd64.deb' \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -f /opt/*.deb


COPY local.conf /etc/fonts/local.conf
COPY default.pa /etc/pulse/default.pa
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod 755 /usr/bin/entrypoint.sh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
