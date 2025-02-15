#!/bin/bash -e

if [[ ! -f mangosd.conf ]]; then
  cp ../etc/mangosd.conf.dist .
  cp ../etc/mangosd.conf.dist mangosd.conf
  # Lower the default LogLevel from "Full/Debug" to "Basic&Error"
  sed -i 's/^\(LogLevel *= *\)3$/\11/' mangosd.conf
  # Set the gamedata directory
  sed -i 's/^\(DataDir *= *\).*$/\1gamedata/' mangosd.conf
  # Set the logs directory
  mkdir -p logs
  sed -i 's/^\(LogsDir *= *\).*$/\1logs/' mangosd.conf
fi

if [[ ! -f ahbot.conf ]]; then
  cp ../etc/ahbot.conf.dist .
  cp ../etc/ahbot.conf.dist ahbot.conf
fi


sed -i "s/^\(LoginDatabaseInfo *= *\).*$/\1${LOGIN_DATABASE_INFO}/" mangosd.conf
sed -i "s/^\(WorldDatabaseInfo *= *\).*$/\1${WORLD_DATABASE_INFO}/" mangosd.conf
sed -i "s/^\(CharacterDatabaseInfo *= *\).*$/\1${CHARACTER_DATABASE_INFO}/" mangosd.conf
sed -i "s/^\(LogsDatabaseInfo *= *\).*$/\1${LOGS_DATABASE_INFO}/" mangosd.conf


set -x

exec ../bin/mangosd -c mangosd.conf -a ahbot.conf
