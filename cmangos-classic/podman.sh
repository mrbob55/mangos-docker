https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html

mkdir -p database_data

podman pull docker.io/library/mariadb:11

podman build -t localhost/cmangos-classic .

podman run -it -v ./workdir/server/gamedata:/gamedata -v ~/Downloads/"World of Warcraft 1.12":/wow -w /server/install/bin/tools cmangos-classic ./ExtractResources.sh /wow /gamedata


# Create pod manually:
podman pod create --name cmangos-classic -p 3306:3306 -p 3724:3724 -p 8085:8085 -p 3443:3443


mkdir -p ~/.config/containers/systemd/

# TRY THIS .POD WITH PODMAN 5:
# cat << EOF > ~/.config/containers/systemd/cmangos-classic.pod
# [Unit]
# Description=cmangos-classic pod
# After=local-fs.target

# [Pod]
# PodName=cmangos-classic
# PublishPort=3306:3306
# PublishPort=3724:3724
# PublishPort=8085:8085
# PublishPort=3443:3443

# [Install]
# WantedBy=multi-user.target
# EOF

cat << EOF > ~/.config/containers/systemd/cmangos-classic-database.container
[Unit]
Description=cmangos-classic database
After=local-fs.target

[Container]
#Pod=cmangos-classic
PodmanArgs=--pod=cmangos-classic
ContainerName=cmangos-classic-database
Image=docker.io/library/mariadb:11
Volume=$PWD/database_data:/var/lib/mysql
Environment=MARIADB_ROOT_PASSWORD=mangos

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > ~/.config/containers/systemd/cmangos-classic-realmd.container
[Unit]
Description=cmangos-classic realmd
After=cmangos-classic-database.container
Requires=cmangos-classic-database.container

[Container]
#Pod=cmangos-classic
PodmanArgs=--pod=cmangos-classic
ContainerName=cmangos-classic-realmd
Image=localhost/cmangos-classic
Volume=$PWD/workdir/realmd:/server/install/workdir
Environment=LOGIN_DATABASE_INFO=127.0.0.1;3306;mangos;mangos;classicrealmd

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > ~/.config/containers/systemd/cmangos-classic-server.container
[Unit]
Description=cmangos-classic server
After=cmangos-classic-database.container
Requires=cmangos-classic-database.container

[Container]
#Pod=cmangos-classic
PodmanArgs=--tty --pod=cmangos-classic
ContainerName=cmangos-classic-server
Image=localhost/cmangos-classic
Volume=$PWD/workdir/server:/server/install/workdir
Environment=LOGIN_DATABASE_INFO=127.0.0.1;3306;mangos;mangos;classicrealmd
Environment=WORLD_DATABASE_INFO=127.0.0.1;3306;mangos;mangos;classicmangos
Environment=CHARACTER_DATABASE_INFO=127.0.0.1;3306;mangos;mangos;classiccharacters
Environment=LOGS_DATABASE_INFO=127.0.0.1;3306;mangos;mangos;classiclogs

[Install]
WantedBy=multi-user.target
EOF

/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
systemctl --user daemon-reload

systemctl --user start cmangos-classic-database.service cmangos-classic-realmd.service cmangos-classic-server.service
systemctl --user stop cmangos-classic-database.service cmangos-classic-realmd.service cmangos-classic-server.service

systemctl --user start cmangos-classic-database.service
systemctl --user start cmangos-classic-realmd.service
systemctl --user start cmangos-classic-server.service

systemctl --user status cmangos-classic-database.service
systemctl --user status cmangos-classic-realmd.service
systemctl --user status cmangos-classic-server.service

journalctl --user -xeu cmangos-classic-server.service

systemctl --user stop cmangos-classic-database.service
systemctl --user stop cmangos-classic-realmd.service
systemctl --user stop cmangos-classic-server.service


# To automatically start services on login, run: (doesn't seem to work properly!!)
sed -i '/WantedBy=multi-user.target/!b; /default.target/!s/$/ default.target/' ~/.config/containers/systemd/cmangos-classic-*.container
systemctl --user daemon-reload

# To disable autostart, run:
sed -i '/WantedBy=multi-user.target/!b; s/ default.target$//' ~/.config/containers/systemd/cmangos-classic-*.container
systemctl --user daemon-reload

# If you need a mysqldump binary:
podman cp cmangos-classic-database:/usr/bin/mariadb-dump ~/bin/mysqldump
