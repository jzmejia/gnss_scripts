#! /bin/bash
# Combine 3 days' sp3 orbit files into one file
gps_yr=18
sta_doy=280
end_doy=365
path_comb=../comb3_sp3

if [ ! -d "$path_comb" ]; then
    mkdir $path_comb
fi

for i in `seq $sta_doy $end_doy`
do
    i_b=$((i-1))
    i_a=$((i+1))
    gps_week=`doy $gps_yr $i| (sed -n "2,1p"| awk '{print($3)}')`
    d_week=`doy $gps_yr $i| (sed -n "2,1p"| awk '{print(substr($7,1,1))}')`
    b_gps_week=`doy $gps_yr $i_b| (sed -n "2,1p"| awk '{print($3)}')`
    b_d_week=`doy $gps_yr $i_b| (sed -n "2,1p"| awk '{print(substr($7,1,1))}')`
    a_gps_week=`doy $gps_yr $i_a| (sed -n "2,1p"| awk '{print($3)}')`
    a_d_week=`doy $gps_yr $i_a| (sed -n "2,1p"| awk '{print(substr($7,1,1))}')`

    fsp3=igs${gps_week}${d_week}.sp3
    b_fsp3=igs${b_gps_week}${b_d_week}.sp3
    a_fsp3=igs${a_gps_week}${a_d_week}.sp3

#***Create new file in $path_comb  ***#
    cat $b_fsp3 > $path_comb/$fsp3
    sed -i.bak '/EOF/d' $path_comb/$fsp3
#***clean extra information for fsp2 and b_fsp3
    cat $fsp3 > $path_comb/temp1
    sed -i.bak '/#/d' $path_comb/temp1
    sed -i.bak '/+/d' $path_comb/temp1
    sed -i.bak '/%/d' $path_comb/temp1
    sed -i.bak '/\//d' $path_comb/temp1
    sed -i.bak '/EOF/d' $path_comb/temp1
#
    cat $a_fsp3 > $path_comb/temp2
    sed -i.bak '/#/d' $path_comb/temp2
    sed -i.bak '/+/d' $path_comb/temp2
    sed -i.bak '/%/d' $path_comb/temp2
    sed -i.bak '/\//d' $path_comb/temp2

    cat $path_comb/temp1 >> $path_comb/$fsp3
    cat $path_comb/temp2 >> $path_comb/$fsp3
    rm -irf $path_comb/temp1
    rm -irf $path_comb/temp2
done
