#!/bin/bash

echo "deleting old backups..."

date=$(date +%F)
retention_days=15
count=$(( $retention_days + 1 ))
while [ $count -gt 0 ]
do
  retn_value=$(bash /etc/pg-backup/minus-one-day.sh $date)
  date=$retn_value
  count=$(( $count - 1 ))
done

backup_root='/tmp/pgbackups/pgbackups'
backup_dir=''

#now delete dirs
count=0
while [ $count -lt 100 ]
do
  retn_value=$(bash /etc/pg-backup/minus-one-day.sh $date)
  date=$retn_value
  backup_dir=$backup_root$date
  if [ -d $backup_dir ]
  then
    rm -rf $backup_dir
  fi
  count=$(( $count + 1))
done

