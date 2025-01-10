#!/bin/bash

if [[ ! -f /mangosconf/realmd.conf ]]; then
  mv etc/realmd.conf.dist /mangosconf/realmd.conf
fi

sed -i "s/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo = $LOGIN_DATABASE_INFO/" /mangosconf/realmd.conf


set -x

exec ./bin/realmd -c /mangosconf/realmd.conf
