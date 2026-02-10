#!/bin/bash

#docker exec eventec_pg_db /usr/bin/pg_dumpall -U brando | gzip -9  >/eventecpgdrive/postgres/backups/postgres-backup-2021-11-11.gz


# mkdir /eventecpgdrive/postgres/backups/2021-11-11
# docker exec eventec_pg_db /usr/bin/pg_dumpall -U brando | gzip -9  >/eventecpgdrive/postgres/backups/2021-11-11/postgres-backup-2021-11-11_2.gz

date=$(date +%F)
date_time=$(date +%F_%H-%M-%S)
backup_root='/var/pg-backups/'
backup_dir=$backup_root$date
latest=$backup_root'latest.gz'

rm $latest

echo 'executing pg_dumpall...'
pg_dumpall -U brando | gzip -9  >$latest

if [ ! -d $backup_dir ]
then
  echo 'MKDIR '$backup_dir
  mkdir $backup_dir
fi

final=$backup_dir'/'$date_time'.gz'
echo 'archiving...'
cp $latest $final
echo 'backup done'
bash /etc/pg-backup/pg-delete-old-backups.sh

