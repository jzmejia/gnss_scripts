# /bin/bash

# convert T02 to rinex using runpkr00 and teqc
#
# script converts Trimble T02 to rinex for all files in directory 
#
# user inputs: 
# stn - station 4 char name
# name - your name to include in rinex header
# affiliation - your affiliation to include in rinex header
# antenna - antenna model (e.g. ZEPHYR GEODETIC)
# 
# requires: runpkr00, teqc
# expects T02 files to be located within a directory named T02
# generated files will be put into a directory named rinex



stn=""
name=""
affiliation=""
antenna="ZEPHYR GEODETIC"
stn=$(echo ${stn} | tr '[:upper:]' '[:lower:]')
echo ${stn}

for fT02 in ${stn}/T02/*.T02
do
    echo ${fT02}
    runpkr00 -g -d ${fT02}
    ftgd=${fT02%.T02}.tgd
    echo $ftgd
    teqc -O.obs C1C2L1L2P2 -O.int 15 -tr d ${ftgd} > ${stn}/T02/tmpo
    teqc -O.ag ${affiliation} -O.o ${name} -O.mo ${stn} -O.mn 0 -O.at ${antenna} ${stn}/T02/tmpo >${fT02%.T02}.o
    rm -irf ${ftgd}
    rm -irf ${stn}/T02/tmpo
done
teqc -O.int 15 +obs, + -tbin 1d ${stn}/rinex/${stn} ${stn}/T02/*.o
rm -irf ${stn}/T02/*.o

