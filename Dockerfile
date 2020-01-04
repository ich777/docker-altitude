FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	export TZ=Europe/Rome && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
	apt-get -y install --no-install-recommends expect libc6:i386 && \
	rm -rf /var/lib/apt/lists/*

ENV SERVER_DIR="/altitude"
ENV DL_URL="http://installer.altitudegame.com/0.0.1/altitude.sh"
ENV GAME_PARAMS=""
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $SERVER_DIR && \
	useradd -d $SERVER_DIR -s /bin/bash --uid $UID --gid $GID altitude && \
	chown -R altitude $SERVER_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R altitude /opt/scripts

USER altitude

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]