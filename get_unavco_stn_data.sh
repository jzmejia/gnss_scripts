#!/bin/bash

# Requirements
# ------------
# earthscope-cli
# before running script loginto earthscope-cli run in terminal:
# es login 

# year (YY) and day of year range to download data for
gps_yr=23
sta_doy=259
end_doy=365
# obs_freq=10 # in days
# 4 char station name
stn=hel2
file_ext="o.Z"
access_url="https://data.unavco.org/archive/gnss/rinex/obs/20"${gps_yr}

# use commented out code below if you want an interval between dates
# for i in `seq ${sta_doy} ${obs_freq} ${end_doy}`
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
  curl -L -O -f --url ${path} --header "authorization: Bearer $(es user get-access-token)"
done
