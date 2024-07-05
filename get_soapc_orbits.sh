#!/bin/bash

# download gps orbits from SOPAC
# http://sopac-csrc.ucsd.edu/index.php/fps-orbits/
# sp3 - precise ephemeries orbits in sp3 format (sioWWWWD.sp3.Z)
# note: week refers to gps week (WWWW)
# D - day of week
# DDD - day of year
# YYYY - year
# script will work for files serialized in the WWWWD format

# GPS week to loop through
sta_week=2300
end_week=2310

# SOPAC login
# You can include anonymous authentication in the URL:
# Format http://username:password@garner.ucsd.edu/
# To login as an anonymous user, please use your email address as the password.
# To enter your email address as the password, replace the '@' symbol with '%40'.
email=jason%40ucsd.edu
url_pre="http://anonymous:"${email}"@garner.ucsd.edu/pub/products/"

# nested loop is for daily files  
sta_daily=0
end_daily=6

file_pre="igs"

# sp3 - precise ephemeries orbits in sp3 format (sioWWWWD.sp3.Z)
# erp - earth orientation
# snx - sinex
# sum - analysis summary files
file_type=sp3
file_ext=.${file_type}.Z

for week in `seq ${sta_week} ${end_week}`
do
    for i in `seq ${sta_daily} ${end_daily}`
    do
    file=${file_pre}${week}${i}${file_ext} 
    echo ${url_pre}${week}/${file} >> temp.txt
    done
done

wget -i temp.txt
rm temp.txt
