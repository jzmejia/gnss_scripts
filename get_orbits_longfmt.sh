#!/bin/bash

#download orbits from SOPAC with new long format file names
# http://garner.ucsd.edu/pub/products/wwww%5b/reproX
# for more info see: https://igs.org/products/#orbits_clocks

# wwww stands for the GPS week
# X for the reprocessing campaign number (1–3)


# start and end date in GPS week format
# I use doy to convert to this format
sta_week=2312
end_week=2324
# start day of year 3 digit
doy=119
yyyy=2024

url_pre="http://anonymous:jason%40ucsd.edu@garner.ucsd.edu/pub/products/"


# use to get orbit files with the long naming convention
# File type	   Old short name	New long name
# Final orbits igswwwwd.sp3.Z	IGS0OPSFIN_yyyyddd0000_01D_15M_ORB.SP3.gz
# Rapid orbits igrwwwwd.sp3.Z	IGS0OPSRAP_yyyyddd0000_01D_15M_ORB.SP3.gz

for i in `seq ${sta_week} ${end_week}`
do
    for j in `seq 0 6`
    do
    file=IGS0OPSRAP_${yyyy}${doy}0000_01D_15M_ORB.SP3.gz
    echo ${url_pre}${i}/${file} >> temp.txt
    doy=$((doy+1))
    done
done

wget -i temp.txt

rm temp.txt


for f in *.gz
do
    gunzip ${f}
done
