#!/bin/bash

if [ ! -f etc/realmd.conf ]; then
  mv etc/realmd.conf.dist etc/realmd.conf
fi

sed -i "s/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo = $LOGIN_DATABASE_INFO/" etc/realmd.conf

set -x

./bin/realmd -c etc/realmd.conf
