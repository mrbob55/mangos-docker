#!/bin/bash

CONFIG=./etc/realmd.conf

if [ -f /realmdconf/realmd.conf ]; then
  echo "/realmdconf/realmd.conf is being used"
  CONFIG=/realmdconf/realmd.conf
fi

sed -i "s/LOGIN_DATABASE_INFO/$LOGIN_DATABASE_INFO/g" "$CONFIG"

./bin/realmd -c "$CONFIG"
