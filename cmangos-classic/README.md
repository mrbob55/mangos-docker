After initializing the database you have to run the [InstallFullDB.sh](https://github.com/cmangos/classic-db/blob/master/InstallFullDB.sh) script manually outside of docker, just point it on the database running in docker.

You also have to extract the gamedata (dbc, maps, mmaps, vmaps) and put them in the [workdir/server/gamedata](workdir/server/gamedata) directory. This is easiest done on Windows using the [official binaries](https://github.com/cmangos/mangos-classic/releases) and Git Bash or Cygwin. You can also do it using the docker image (see below).





```shell
sudo apt update
sudo apt install -y mariadb-client docker.io docker-compose

docker-compose build --progress=plain

# To extract the gamedata using the docker image, run: (the extracted files will be created in the gamedata directory)
docker run -it -v ./workdir/server/gamedata:/gamedata -v ~/Downloads/"World of Warcraft 1.12":/wow -w /server/install/bin/tools cmangos-classic ./ExtractResources.sh /wow /gamedata

# Set up the database:
docker-compose up database
git clone https://github.com/cmangos/mangos-classic.git
git clone https://github.com/cmangos/classic-db.git
cat << EOF > classic-db/InstallFullDB.config
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USERNAME="mangos"
MYSQL_PASSWORD="mangos"
MYSQL_PATH="$(which mysql)"
MYSQL_DUMP_PATH="$(which mysqldump)"
CORE_PATH="$(pwd)/mangos-classic"
AHBOT="YES"
PLAYERBOTS_DB="NO"
EOF
cd classic-db
./InstallFullDB.sh

docker-compose up database
docker-compose up realmd
docker-compose up server
```


### Console commands

To attach to the server container to execute mangos commands, run:

```shell
docker attach cmangos_classic_server_1
```

To detach, press Ctrl+P and then Ctrl+Q. **Do not use Ctrl+D since that will shut down the server!!**

Here are some common commands:

```
account create theusername thepassword
account set gmlevel theusername 3
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
cd mangos-docker/cmangos-classic

cat << EOF | sudo tee /etc/systemd/system/cmangos-classic.service
[Unit]
Description=cmangos-classic
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
sudo systemctl enable cmangos-classic.service
sudo systemctl start cmangos-classic.service
sudo systemctl status cmangos-classic.service
```


### Connect with mysql

```shell
mysql --protocol=tcp --user=mangos -pmangos classicrealmd
mysql --protocol=tcp --user=mangos -pmangos classiccharacters
```

```sql
update realmlist set address='192.168.1.71';
```


### Save docker image

```shell
docker image save cmangos-classic | xz -9 > cmangos-classic-$(date +%F).tar.xz
```

Load:

```shell
cat cmangos-classic-2024-11-20.tar.xz | xz -d | docker image load
```
