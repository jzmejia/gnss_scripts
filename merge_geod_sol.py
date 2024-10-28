# merge TRACK GEOD files 

import numpy as np
# import matplotlib.pyplot as plt
# from scipy import stats
# from matplotlib.patches import Rectangle
from pathlib import Path

stn='hlm1'   #Station name
yr=2023
stad=170 # day of year (doy) start
endd=305 # doy end
fout='hlm123GEOD.txt' # output file name


def loadfgeod(filename):
    ft = np.genfromtxt(filename, dtype=[
        ('YYYY','uint32'),('DOY','uint32'),('sec','float64'),
        ('Latitude','float64'),('Longitude','float64'),
        ('Height','float64'),('sigN','float64'),
        ('sigE','float64'),('sigH','float64'),
        ('RMS','float32'),('NDD','uint32'),
        ('Atm','float32'),('sigAtm','float32'),
        ('fract_DOY','float64'),('Epoch','uint64'),
        ('NBF','uint32'),('NotF','uint32'),
        ('flag','S1')], delimiter="", comments="*")
    tgeod = np.zeros((len(ft),11))
    for i in range(len(ft)):
        tgeod[i,0]=ft[i][0] #yy
        tgeod[i,1]=ft[i][1] #doy
        tgeod[i,2]=ft[i][2] #sec
        tgeod[i,3]=ft[i][13] #fract doy
        tgeod[i,4]=ft[i][3] #lat
        tgeod[i,5]=ft[i][4] #lon
        tgeod[i,6]=ft[i][5] #height
        tgeod[i,7]=ft[i][6] #lat err
        tgeod[i,8]=ft[i][7] #lon err
        tgeod[i,9]=ft[i][8] #dheight err
        tgeod[i,10]=ft[i][16] #NotF
    return tgeod

ffid=open(fout,'w')
for k in range(int(endd+1-stad)):
        fn='./TRAK' + "{0:0>3}".format(stad+k) + '0.GEOD.' + stn + '.LC'
        print(fn)
        if Path(fn).is_file():
            geodf=loadfgeod(fn)
            # only append data for the proper doy (remove extra points at beginning and end of file)
            # also, only append good data with NotF < 1 (i.e., NotF=0)
            sel_id=np.where( (geodf[:,3]>=k+stad) & (geodf[:,3]<k+1+stad) & (geodf[:,10]<1)  )[0]
            sel_geod=geodf[sel_id,:]
            np.savetxt(ffid,sel_geod,fmt='%.0f, %.0f, %5.6f, %10.6f, %.9f, %.9f, %.4f,  %.1f,  %.1f,  %.1f,  %.0f')
ffid.close()
