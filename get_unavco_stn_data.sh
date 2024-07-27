#!/bin/bash
# year (YY) and day of year range to download data for
gps_yr=23
sta_doy=259
end_doy=365
# 4 char station name
stn=hel2
file_ext="o.Z"
access_url="https://data.unavco.org/archive/gnss/rinex/obs/20"${gps_yr}


for i in `seq ${sta_doy} ${end_doy}`
do 
  if [ $i -lt 100 ]
  then
    gdoy=0${i}
    if [ $i -lt 10 ]
    then
      gdoy=0${gdoy}
    fi
  else
    gdoy=${i}
  fi

  file_name=${stn}${gdoy}0.${gps_yr}${file_ext}
  path=${access_url}/${gdoy}/${file_name}
  curl -L -O -f --url ${path} --header "authorization: Bearer $(es sso access --token)"
done
