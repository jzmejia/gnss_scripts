# gnss_scripts
useful scripts for processing GNSS data, including data access, pre-processing, post-processing, and accessing other required data (e.g., orbits).  


Scripts used for full pre-processing and post-processing of GNSS data files for high-precision position determination using MIT's GAMIT GLOBK software. This includes converting files from propertary formats using teqc and runpkr00, file naming conventions, manipulation, splicing etc within shell scripts. Downloading GNSS data from EARTHSCOPE/UNAVCO online data archives, and downloading orbit files for analysis. I splice data by appending each day of data with 0.5 days from the preceeding and following days that are cut off after position determination, this helps to reduce noise at the edges (midnight) of each days data collection. 


## file descriptions

|file name| description|
|---------|------------|
`get_unavco_stn_data.sh` | for bulk downloading GNSS station data from UNAVCO's GAGE Facility, requires [earthscope-cli](https://gitlab.com/earthscope/public/earthscope-cli#Getting_Started) | 
`get_orbits.sh` |bulk download [SOPAC](http://garner.ucsd.edu) IGS orbits (or other files) from Scripps Orbit and Permanent Array Center|  
`get_orbits_longfmt.sh`| bulk download SOPAC orbits with new long naming convention  |
`combine_3d_orbits.sh`| append daily orbit file with 12 hours from the previous and next day as a single file | 
`combine_3d_rinex.sh`| append rinex file with 12 hours of obs from the previous and next day as a single file | 
`convertT02.sh` | convert trimble `.T02` files to rinex files with `teqc` and `runpkr00` |
||
`merge_geod_sol.py` | merge daily GEOD (lat/lon) solutions into a single `.csv` file with all solutions for a given year|
`merge_daily_sol.py` | merge daily NEU (northing/easting) solutions into a single `.csv` file with all solutions for a given year |

## python analysis
For data analysis tools see the Python module [gpstools](https://github.com/jzmejia/datatools).
