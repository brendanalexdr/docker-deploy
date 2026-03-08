#!/bin/bash
date=$1
arrIN=(${date//-/ })
yr=${arrIN[0]}
mo=${arrIN[1]}
day=${arrIN[2]}
mo_day="${mo}-${day}"
echo $mo_day
exit 0
