The database now uses mariadb. After initializing the database you have to run the [InstallDatabases.sh](https://github.com/mangoszero/database/blob/master/InstallDatabases.sh) script manually outside of docker, just point it on the database running in docker.

You also have to extract the gamedata (maps, etc) and put it in the [gamedata](gamedata) directory. This is easiest done on Windows using the [official binaries](https://github.com/mangoszero/server/releases/latest) and Git Bash or Cygwin. You can also do it using the docker image (see below).

This is working well on my Raspberry Pi 3 with 1 GB of RAM, running on a 8 GB SD card (this is a little on the small size but if you use Raspberry Pi OS Lite you should have about 1 GB left over after setting this up).



```shell
sudo apt update
sudo apt install -y mariadb-client docker.io docker-compose

docker-compose build --progress=plain

# To extract the gamedata using the docker image, run: (the extracted files will be created in the game directory)
docker run -it -v ~/Downloads/"World of Warcraft 1.12":/wow -v ./launch_extract_gamedata.sh:/server/install/launch.sh mangoszero

docker-compose up database
git clone https://github.com/mangoszero/database.git --recursive
cd database
./InstallDatabases.sh

docker-compose up -d database
docker-compose up -d realmd
docker-compose up -d server
```


### Console commands

To attach to the server container to execute mangos commands, run:

```shell
docker attach mangoszero_server_1
```

To detach, press Ctrl+P and then Ctrl+Q. **Do not use Ctrl+D since that will shut down the server!!**

Here are some common commands:

```
account create theusername thepassword
```

More commands here: https://github.com/MeulenG/mangos-cheat-sheet


### Docker logs

Check the logs with:

```shell
docker-compose logs --tail=100 -t server
```


### Set up systemd service to start on startup

This starts the docker containers on tty2 on startup.

```shell
cd mangos-docker/mangoszero

cat << EOF | sudo tee /etc/systemd/system/mangoszero.service
[Unit]
Description=mangoszero
Requires=docker.service
After=docker.service

[Service]
Restart=on-failure
User=root
Group=docker
TimeoutStopSec=60
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/tty2
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/start.sh
ExecStop=$(which docker-compose) stop

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable mangoszero.service
sudo systemctl start mangoszero.service
sudo systemctl status mangoszero.service
```


### Connect with mysql

```shell
mysql --protocol=tcp --user=root -pmangos realmd
```

```sql
update realmlist set address='192.168.1.71', localAddress='192.168.1.71';
```


### Save docker image

```shell
docker image save mangoszero | xz -9 > mangoszero-$(date +%F).tar.xz
```

Load:

```shell
cat mangoszero-2024-11-20.tar.xz | xz -d | docker image load
```


### Backup whole directory

```shell
sudo tar cJf mangos-docker.tar.xz mangos-docker

# restore:
tar xJf /media/usb/mangos/mangos-docker.tar.xz
```
