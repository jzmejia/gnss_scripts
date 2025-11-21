#!/bin/bash

# append rinex file with 12 hours of data from days before and after
# to eliminate edge effects during processing
# outputs a file of the same name in a new directory
#
# Requirements
# ------------
#    teqc
#    (doy no longer required)
#
# Update 11/21/2025 J.Z. Mejia
#    current set up requries both teqc and doy commands to be executed
#    from this script. Due to compatability issues and those wanting the
#    abiltiy to run teqc and runpkr00 from a docker environment this yields
#    complications due to the lack of the doy command. 
# IMPORTANT: Updated version of this script replaces the doy command so only 
#    teqc is required. 

gps_yr=24
year=2024
# first and last day of year to loop through
sta_doy=182
end_doy=200

# station name
stn=hel2
# path to dir with rinex data and new directory to write files
path_1drnx=rinex
path_3drnx=rinex3d

for i in  `seq ${sta_doy} ${end_doy}`
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
  #Check if there is data the day before
  doy1=$((i-1))
  if [ $doy1 -lt 100 ]
  then
    gdoy1=0${doy1}
    if [ $doy1 -lt 10 ]
    then
      gdoy1=0${gdoy1}
    fi
  else
    gdoy1=${doy1}
  fi
  #Check if there is data the day after
  doy2=$((i+1))
    if [ $doy2 -lt 100 ]
  then
    gdoy2=0${doy2}
    if [ $doy2 -lt 10 ]
    then
      gdoy2=0${gdoy2}
    fi
  else
    gdoy2=${doy2}
  fi
  #Combine file
  stni=$(echo ${stn} | tr ";" "\n")
  for stnki in ${stni}
  do
    f_stn=${stnki}${gdoy}0.${gps_yr}o
    f_stn1=${stnki}${gdoy1}0.${gps_yr}o
    f_stn2=${stnki}${gdoy2}0.${gps_yr}o
    echo "Form observation file ${f_stn}"
    if [ ! -f "${path_1drnx}/${f_stn}" ]
    then
      echo "No data for ${stnki} on ${gdoy}"
    else
      fstn_3i=`ls ${path_1drnx}/${f_stn1} ${path_1drnx}/${f_stn} ${path_1drnx}/${f_stn2}`
      teqc ${fstn_3i} >${path_3drnx}/tmp
      sed -e "1,/END OF HEADER/w ${path_3drnx}/header
      /END OF HEADER/,\$w ${path_3drnx}/tmpn" ${path_3drnx}/tmp >${path_3drnx}/tmp3d
      rm ${path_3drnx}/tmp3d
      rm -irf ${path_3drnx}/tmp
      tail -n +2 ${path_3drnx}/tmpn >${path_3drnx}/tmpn1
      rm -irf ${path_3drnx}/tmpn
      grep -n "RINEX FILE SPLICE" ${path_3drnx}/tmpn1| grep -Eo '^[^:]+'>ln1
      awk '{print($1-1)}' ln1 >ln0
      rm -irf ln1
      sed -i'.bak' 's/$/d;/' ln0
      rm *.bak
      dl0=`echo $(cat ln0)`
      rm -irf ln0
      sed -i'.bak' -e "${dl0}" ${path_3drnx}/tmpn1
      sed -i'.bak' '/COMMENT/d' ${path_3drnx}/tmpn1      
      sed -i'.bak' '/XYZ/d' ${path_3drnx}/tmpn1
      sed -i'.bak' '/Time/d' ${path_3drnx}/tmpn1  
      sed -i'.bak' '/HEADER/d' ${path_3drnx}/tmpn1 
      sed -i'.bak' '/SECOND/d' ${path_3drnx}/tmpn1  
      sed -i'.bak' '/INTERVAL/d' ${path_3drnx}/tmpn1  
      sed -i'.bak' '/TYPE/d' ${path_3drnx}/tmpn1     
      sed -i'.bak' '/WAVE/d' ${path_3drnx}/tmpn1 
      sed -i'.bak' '/ANT/d' ${path_3drnx}/tmpn1   
      sed -i'.bak' '/OBS/d' ${path_3drnx}/tmpn1    
      sed -i'.bak' '/MARK/d' ${path_3drnx}/tmpn1   
      sed -i'.bak' '/DATE/d' ${path_3drnx}/tmpn1                                     
      cat ${path_3drnx}/header ${path_3drnx}/tmpn1 > ${path_3drnx}/tmpn2
      rm -irf ${path_3drnx}/header
      rm -irf ${path_3drnx}/*.bak
      rm -irf ${path_3drnx}/tmpn1
      
      # use bash to determine month/date format rather than doy
      date_str=$(date -d "${year}-01-01 +$((${doy1} - 1)) days" +"%m %d")
      gps_mt=$(echo "$date_str" | awk '{print $1}')
      gps_dy=$(echo "$date_str" | awk '{print $2}')
      
      # gps_mt=`doy ${gps_yr} ${doy1}| (sed -n "1,1p"| awk '{print(substr($2,6,2))}')`
      # gps_dy=`doy ${gps_yr} ${doy1}| (sed -n "1,1p"| awk '{print(substr($2,9,2))}')`
      
      teqc -st ${gps_yr}:${gps_mt}:${gps_dy}:12:00:00 +dh 48 ${path_3drnx}/tmpn2 >${path_3drnx}/tmpn3
      teqc -O.obs C1C2L1L2P2 ${path_3drnx}/tmpn3 > ${path_3drnx}/${f_stn}
      rm -irf ${path_3drnx}/tmpn2
      rm -irf ${path_3drnx}/tmpn3
    fi
  done  
done

