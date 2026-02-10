#!/bin/bash -x
db=$(docker container ls -q --filter name=dbredis_db* --format "{{.Names}}")
docker exec -i $db /etc/pg-backup/pg-backup.sh
echo "done pg backup"