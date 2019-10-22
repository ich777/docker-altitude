# Altitude Server in Docker optimized for Unraid
This Docker will download and install Altitude and run it.
Default Servername: Docker Altitude Server | Default Password: Docker | Default Admin Password: adminDocker

ATTENTION: First Startup can take very long since it downloads the gameserver files! Update Notice: Simply restart the container if a newer version of the game is available.

Also check out the homepage of Altidude: http://altitudegame.com/

>**Default credentials:** Docker Altitude Server | Default Password: Docker | Default Admin Password: adminDocker

## Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /altitude |
| DL_URL | Download URL for the 'altitude.sh' file  | http://installer.altitudegame.com/0.0.1/al... |
| GAME_PARAMS | Extra startup parameters if needed (otherwise leave blank) | *blank* |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name Altitude -d \
    -p 27276:27276/udp \
    --env 'DL_URL=http://installer.altitudegame.com/0.0.1/altitude.sh' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/appdata/altitude:/altitude \
    ich777/altitude
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/