FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV TZ=Europe/Rome
RUN apt-get -y install wget expect lib32gcc1

ENV SERVER_DIR="/altitude"
ENV DL_URL="http://installer.altitudegame.com/0.0.1/altitude.sh"
ENV GAME_PARAMS=""
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $SERVER_DIR
RUN useradd -d $SERVER_DIR -s /bin/bash --uid $UID --gid $GID altitude
RUN chown -R altitude $SERVER_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R altitude /opt/scripts

USER altitude

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
