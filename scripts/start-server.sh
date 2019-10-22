#!/bin/bash
echo "---Checking for Altitude Server executable ---"
if [ ! -f ${SERVER_DIR}/server_lauchner ]; then
	cd ${SERVER_DIR}
	echo "---Downloading and installing Altitude Server---"
    wget -qi --show-progress altitude.sh ${DL_URL}
    sleep 2
    if [ ! -f $SERVER_DIR/altitude.sh ]; then
    	echo "-------------------------------------------------------------"
    	echo "---Can't download Altitude. Putting server into sleep mode---"
        echo "-------------------------------------------------------------"
        sleep infinity
    fi
	chmod +x ${SERVER_DIR}/altitude.sh
	expect <<EOF
	spawn ${SERVER_DIR}/altitude.sh -c
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
	if [ ! -f $SERVER_DIR/server_lauchner ]; then
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
	wget -qi --show-progress launcher_config.xml https://github.com/ich777/docker-altitude/raw/master/config/launcher_config.xml
	if [ ! -f ${SERVER_DIR}/servers/launcher_config.xml ]; then
		echo "-----------------------------------------------------------------------"
		echo "---Can't download configuration file. Putting server into sleep mode---"
		echo "-----------------------------------------------------------------------"
		sleep infinity
	fi
	echo "---Server configuration successfully downloaded---"
fi

echo "---Preparing Server---"
chmod -R 770 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/server_launcher