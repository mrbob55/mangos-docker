#!/bin/bash -e

if [[ ! -d /wow ]]; then
  echo "Please mount the game directory on the /wow path."
  exit 1
fi

set -x

cp bin/tools/* /wow/

cd /wow

exec ./ExtractResources.sh "$@"
