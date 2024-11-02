The database now uses mariadb. After initializing the database you have to run the [InstallDatabases.sh](https://github.com/mangoszero/database/blob/master/InstallDatabases.sh) script manually outside of docker, just point it on the database running in docker.

You also have to extract the gamedata (maps, etc) and put it in the [gamedata](gamedata) directory. This is easiest done on Windows using the [official binaries](https://github.com/mangoszero/server/releases/latest) and Git Bash or Cygwin.




```shell
sudo apt update
sudo apt install -y mariadb-client docker.io docker-compose

docker-compose build --progress=plain realmd
docker-compose build --progress=plain server

docker-compose up database
git clone https://github.com/mangoszero/database.git --recursive
cd database
./InstallDatabases.sh

docker-compose up -d database
docker-compose up -d realmd
docker-compose up -d server
```

To attach to the server container to execute mangos commands, run:

```shell
docker attach mangoszero_server_1
```

To detach, press Ctrl+p and then Ctrl+q.
