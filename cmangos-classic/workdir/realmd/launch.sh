#!/bin/bash

if [[ ! -f realmd.conf ]]; then
  cp ../etc/realmd.conf.dist .
  cp ../etc/realmd.conf.dist realmd.conf
fi


sed -i "s/^\(LoginDatabaseInfo *= *\).*$/\1${LOGIN_DATABASE_INFO}/" realmd.conf


set -x

exec ../bin/realmd -c realmd.conf
