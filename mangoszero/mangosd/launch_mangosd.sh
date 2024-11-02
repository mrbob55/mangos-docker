#!/bin/bash -e

CONFIG=./etc/mangosd.conf

if [ -f /mangosconf/mangosd.conf ]; then
  echo "/mangosconf/mangosd.conf is being used"
  CONFIG=/mangosconf/mangosd.conf
fi

if [ -f /mangosconf/ahbot.conf ]; then
  echo "/mangosdconf/ahbot.conf is being used"
  AHCONFIG="-a /mangosconf/ahbot.conf"
fi

sed -i "s/LOGIN_DATABASE_INFO/$LOGIN_DATABASE_INFO/g" "$CONFIG"
sed -i "s/WORLD_DATABASE_INFO/$WORLD_DATABASE_INFO/g" "$CONFIG"
sed -i "s/CHARACTER_DATABASE_INFO/$CHARACTER_DATABASE_INFO/g" "$CONFIG"

./bin/mangosd -c "$CONFIG" ${AHCONFIG}
