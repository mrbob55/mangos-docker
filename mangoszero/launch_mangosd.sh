#!/bin/bash -e

if [[ ! -f /mangosconf/mangosd.conf ]]; then
  mv etc/mangosd.conf.dist /mangosconf/mangosd.conf
fi

if [[ ! -f /mangosconf/ahbot.conf ]]; then
  mv etc/ahbot.conf.dist /mangosconf/ahbot.conf
fi


sed -i "s/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo = $LOGIN_DATABASE_INFO/" /mangosconf/mangosd.conf
sed -i "s/^WorldDatabaseInfo *=.*$/WorldDatabaseInfo = $WORLD_DATABASE_INFO/" /mangosconf/mangosd.conf
sed -i "s/^CharacterDatabaseInfo *=.*$/CharacterDatabaseInfo = $CHARACTER_DATABASE_INFO/" /mangosconf/mangosd.conf


set -x

exec ./bin/mangosd -c /mangosconf/mangosd.conf -a /mangosconf/ahbot.conf
