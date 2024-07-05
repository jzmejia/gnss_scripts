# gnss_scripts
useful scripts for processing GNSS data, including data access, pre-processing, post-processing, and accessing other required data (e.g., orbits).  


## file descriptions

`unavco_download.sh ` for bulk downloading GNSS station data from UNAVCO's GAGE Facility, requires [earthscope-cli](https://gitlab.com/earthscope/public/earthscope-cli#Getting_Started)

`get_sopac_orbits.sh` bulk download SOPAC GPS orbits from Scripps Orbit and Permanent Array Center [SOPAC](http://garner.ucsd.edu)

`comb3sp3.sh` combine three days of orbit files into a single file
