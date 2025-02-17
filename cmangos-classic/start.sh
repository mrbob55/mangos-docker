#!/bin/bash -ex

# Switch to tty2:
chvt 2

docker-compose up -d

docker attach cmangos-classic_server_1 || sleep 60
