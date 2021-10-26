#!/bin/bash
echo "---Checking for Altitude Server executable ---"
if [ ! -f ${SERVER_DIR}/bin/server_launcher ]; then
	cd ${SERVER_DIR}
	echo "---Downloading and installing Altitude Server---"
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/altitude.tar.bz2 https://nimblygames-installers.s3.amazonaws.com/altitude.tar.bz2 ; then
       	echo "---Successfully downloaded Altitude Server executable---"
	else
       	echo "---Can't download Altitude Server executable putting server into sleep mode---"
           sleep infinity
	fi
	tar -C ${SERVER_DIR} -xvf ${SERVER_DIR}/altitude.tar.bz2
	rm -rf ${SERVER_DIR}/altitude.tar.bz2
	sleep 2
	if [ ! -f ${SERVER_DIR}/bin/server_launcher ]; then
		echo "-----------------------------------------------------------------------------------"
		echo "---Something went wrong, can't download Altitude. Putting server into sleep mode---"
		echo "-----------------------------------------------------------------------------------"
		sleep infinity
	fi
fi

echo "---Checking for configuration file---"
if [ ! -d ${SERVER_DIR}/servers ]; then
	mkdir ${SERVER_DIR}/servers
fi
if [ -z "$(find ${SERVER_DIR}/servers -name *.xml 2>/dev/null)" ]; then
	echo "---No server configuration found, downloading---"
	cd ${SERVER_DIR}/servers
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/servers/launcher_config.xml https://github.com/ich777/docker-altitude/raw/master/config/launcher_config.xml ; then
    	echo "---Successfully downloaded configuration file---"
	else
    	echo "---Can't download configuration file putting server into sleep mode---"
        sleep infinity
	fi
	if [ ! -f ${SERVER_DIR}/servers/launcher_config.xml ]; then
		echo "-----------------------------------------------------------------------"
		echo "---Can't download configuration file. Putting server into sleep mode---"
		echo "-----------------------------------------------------------------------"
		sleep infinity
	fi
	echo "---Server configuration successfully downloaded---"
fi

echo "---Preparing Server---"
chmod -R ${DATA_PERM} ${SERVER_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/bin/server_launcher -config ${SERVER_DIR}/servers/*.xml ${GAME_PARAMS}