#!/bin/bash -ex
set -o pipefail
mkdir -p backups

FN="backups/mangos-all-databases-$(date +%F-%H-%M-%S).sql.zst"

mysqldump --protocol=tcp --host=127.0.0.1 --port=3306 --user=root -pmangos --all-databases --lock-tables=false | zstd > "$FN"
ls -lh "$FN"
