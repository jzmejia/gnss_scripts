#!/bin/bash

#download orbits from SOPAC with new long format file names
# http://garner.ucsd.edu/pub/products/wwww%5b/reproX
# for more info see: https://igs.org/products/#orbits_clocks

# wwww stands for the GPS week
# X for the reprocessing campaign number (1–3)


#download orbits from SOPAC
# New file naming convention WWWW/AAA0PPPTYP_YYYDDDHHMM_LEN_SMP_CNT.FMT.gz
# where WWWW = GPS week
#       AAA = 3-letter analysis center code (e.g., IGS, CODE, GFZ)
#       0 = version number (always 0 for now)
#       PPP = 3-letter project code (e.g., OPS for final orbits)
#       TYP = solution type (e.g., FIN for final, RAP for rapid)
#       YYYDDDHHMM = year, day of year, hour, minute
#       LEN = intended product period
#       SMP = sampling interval 
#       CNT = content indicator (e.g., ORB for orbits, SUM for analysis summary)
#       FMT = file format (e.g., SP3 for Satellite orbit solution)
#       gz = gzip compression


# use to get orbit files with the long naming convention
# File type	   Old short name	New long name
# Final orbits igswwwwd.sp3.Z	IGS0OPSFIN_yyyyddd0000_01D_15M_ORB.SP3.gz
# Rapid orbits igrwwwwd.sp3.Z	IGS0OPSRAP_yyyyddd0000_01D_15M_ORB.SP3.gz


# start and end date in GPS week format
# I use doy to convert to this format
sta_week=2312
end_week=2347 
sta_yr=2024
sta_doy=119

url_pre="http://anonymous:jason%40ucsd.edu@garner.ucsd.edu/pub/products/"

# orbit specifications for file download
AAA="IGS"
PPP="OPS"
TYP="FIN"
LEN="01D"
SMP="15M"
CNT="ORB"
FMT="SP3"   

# Create a temporary file to hold URLs for all files in requested weeks
for i in `seq ${sta_week} ${end_week}`
do
    for j in `seq 0 6`
    do
    doy_num=$((sta_doy + (i - sta_week) * 7 + j))
    doy=$(printf "%03d" "$doy_num")
    # file=igs${i}${j}.sp3.Z  # old convention, can still use for files older than 2022
    file=${AAA}0${PPP}${TYP}_${sta_yr}${doy}0000_${LEN}_${SMP}_${CNT}.${FMT}.gz
    echo ${url_pre}${i}/${file} >> temp.txt
    if [ "$doy_num" -gt 365 ]; then
        sta_yr=$((sta_yr + 1))
        sta_doy=1
    fi
    done
done

# Download all files listed in temp.txt
wget -i temp.txt

# Clean up temporary file
rm temp.txt

# Unzip all downloaded files

for f in *.gz
do
    gunzip ${f}
done


#rename files to igsWWWD.sp3 format
for i in `seq ${sta_week} ${end_week}`
do
    for j in `seq 0 6`
    do
    doy_num=$((sta_doy + (i - sta_week) * 7 + j))
    doy=$(printf "%03d" "$doy_num")
    file=${AAA}0${PPP}${TYP}_${sta_yr}${doy}0000_${LEN}_${SMP}_${CNT}.${FMT}
    new_file=igs${i}${j}.sp3
    mv $file $new_file
    if [ "$doy_num" -gt 365 ]; then
        sta_yr=$((sta_yr + 1))
        sta_doy=1
    fi
    done
done    
