#!/bin/bash
echo "---Checking for Altitude Server executable ---"
if [ ! -f ${SERVER_DIR}/server_launcher ]; then
	cd ${SERVER_DIR}
	if [ ! -f ${SERVER_DIR}/altitude.sh ]; then
		echo "---Downloading and installing Altitude Server---"
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O altitude.sh ${DL_URL} ; then
        	echo "---Successfully downloaded Altitude Server executable---"
		else
        	echo "---Can't download Altitude Server executable putting server into sleep mode---"
            sleep infinity
		fi
		sleep 2
		if [ ! -f $SERVER_DIR/altitude.sh ]; then
			echo "-------------------------------------------------------------"
			echo "---Can't download Altitude. Putting server into sleep mode---"
			echo "-------------------------------------------------------------"
			sleep infinity
		fi
	fi
	chmod +x ${SERVER_DIR}/altitude.sh
	expect <<EOF
spawn ${SERVER_DIR}/altitude.sh -c
set timeout 180
expect "Where should Altitude be installed?"
send "${SERVER_DIR}\n"
expect "already exists. Would you like to install to that directory anyway?"
send "1\n"
expect "Create symlinks?"
send "n\n"
expect "Create a desktop icon?"
send "n\n"
expect "Run Altitude?"
send "n\n"
expect "Finishing installation..."
exit 0
EOF
	if [ ! -f ${SERVER_DIR}/server_launcher ]; then
		echo "-------------------------------------------------------------------"
		echo "---Can't install Altitude Server. Putting server into sleep mode---"
		echo "-------------------------------------------------------------------"
		sleep infinity
	fi
    rm ${SERVER_DIR}/altitude.sh
else
	echo "---Altitude Server executable found---"
fi

echo "---Checking for configuration file---"
if [ ! -d ${SERVER_DIR}/servers ]; then
	mkdir ${SERVER_DIR}/servers
fi
if [ -z "$(find ${SERVER_DIR}/servers -name *.xml)" ]; then
	echo "---No server configuration found, downloading---"
	cd ${SERVER_DIR}/servers
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O launcher_config.xml https://github.com/ich777/docker-altitude/raw/master/config/launcher_config.xml ; then
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
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/server_launcher ${GAME_PARAMS}