#!/bin/bash -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo."
  exit 1
fi

set -x

./backup.sh
./countdown.exp
systemctl restart cmangos-classic.service
