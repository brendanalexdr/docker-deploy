#!/bin/bash

date=$1
dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $date)
mo_day=$(bash /etc/pg-backup/get-month-day.sh $dtm_minus_day)
if [[ $mo_day = "02-31" ]]
then
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
fi

if [[ $mo_day = "04-31" ]]
then
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
fi

if [[ $mo_day = "06-31" ]]
then
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
fi

if [[ $mo_day = "09-31" ]]
then
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
fi

if [[ $mo_day = "11-31" ]]
then
  dtm_minus_day=$(bash /etc/pg-backup/minus-one-day-base.sh $dtm_minus_day)
fi

echo $dtm_minus_day

exit 0
