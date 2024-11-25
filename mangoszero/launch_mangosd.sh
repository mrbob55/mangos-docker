#!/bin/bash -e

mv etc/mangosd.conf.dist etc/mangosd.conf

sed -i "s/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo = $LOGIN_DATABASE_INFO/" etc/mangosd.conf
sed -i "s/^WorldDatabaseInfo *=.*$/WorldDatabaseInfo = $WORLD_DATABASE_INFO/" etc/mangosd.conf
sed -i "s/^CharacterDatabaseInfo *=.*$/CharacterDatabaseInfo = $CHARACTER_DATABASE_INFO/" etc/mangosd.conf

if [ -f /mangosconf/ahbot.conf ]; then
  echo "/mangosdconf/ahbot.conf is being used"
  AHCONFIG="-a /mangosconf/ahbot.conf"
fi

./bin/mangosd -c etc/mangosd.conf ${AHCONFIG}
