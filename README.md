# gnss_scripts
useful scripts for processing GNSS data, including data access, pre-processing, post-processing, and accessing other required data (e.g., orbits).  


## file descriptions

|file name| description|
|---------|------------|
`unavco_download.sh ` | for bulk downloading GNSS station data from UNAVCO's GAGE Facility, requires [earthscope-cli](https://gitlab.com/earthscope/public/earthscope-cli#Getting_Started) | 
`get_sopac_orbits.sh` |bulk download [SOPAC](http://garner.ucsd.edu)  GPS orbits from Scripps Orbit and Permanent Array Center|  
`get_longsp3.sh`| bulk download SOPAC orbits with new long naming convention  |
`comb3sp3.sh`| append daily orbit file with 12 hours from the previous and next day as a single file | 
`combine_3d_rinex.sh`| append rinex file with 12 hours of obs from the previous and next day as a single file | 
