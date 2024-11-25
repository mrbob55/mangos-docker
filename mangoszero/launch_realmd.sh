#!/bin/bash

mv etc/realmd.conf.dist etc/realmd.conf

sed -i "s/^LoginDatabaseInfo *=.*$/LoginDatabaseInfo = $LOGIN_DATABASE_INFO/" etc/realmd.conf

./bin/realmd -c etc/realmd.conf
