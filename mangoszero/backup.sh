#!/bin/bash -ex
mysqldump --all-databases --protocol=tcp --host=localhost --port=3306 --user=root -pmangos | xz -9 > backups/mangoszero-$(date +%F-%H-%M-%S).sql.xz