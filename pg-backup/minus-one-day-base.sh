#!/bin/bash

date=$1

arrIN=(${date//-/ })
yr=${arrIN[0]}
mo=${arrIN[1]}
day=${arrIN[2]}

yr_=${arrIN[0]}
mo_=${arrIN[1]}
day_=$(expr $day - 1)

if [[ $day_ -lt 1 ]]
then
  day_=31
  mo_=$(expr $mo - 1)
  if [[ $mo_ -lt 1 ]]
  then
    mo_=12
    yr_=$(expr $yr - 1)
  fi
fi
d=$(expr $day_ + 0)
m=$(expr $mo_ + 0)
d_=$d
m_=$m
if [[ $d -lt 10 ]]
then
  d_="0${d}"
fi
if [[ $m -lt 10 ]]
then
  m_="0${m}"
fi


echo "${yr_}-${m_}-${d_}"

exit 0
