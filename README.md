# GarConGPX
 
## Purpose
GarConGPX was written out of my desire to facilitate the extraction and anlysis of data downloaded from the Garmin Connect platform, specifically the .gpx files that Garmin makes available for download.

[Instructions for downloading said .gpx files are available here](https://support.strava.com/hc/en-us/articles/216917807-Exporting-files-from-Garmin-Connect).

Instructions for bulk export may be found elsewhere, but cannot attest to the security of the code, and therefore do not feel confident enough to post the
link to it here.

To Install: 
1. ```devtools::install_github("elsage/GarConGPX")```

To use: 
1. Save your .gpx files to a common directory; e.g. */desktop/gpx_files*
2. Pass the path for the directory where your Garmin .GPX files are stored to ```GarConGPX::gpx_dir_to_df()```.

The result will be a dataframe with the following shape: 
````r
dir <- "~/where_your_gpx_files_live"

gps_data <- gpx_dir_to_df(dir)

str(gps_data)
# 'data.frame':   xxx obs. of  9 variables:
#  $ latitude           : num  
#  $ longitude          : num  
#  $ elevation          : num  
#  $ datetime           : POSIXct
#  $ activity           : chr  
#  $ activity_type      : chr  
#  $ cumulative_distance: num 
#  $ split_mile         : num  
#  $ split_km           : num  
````
### Enjoy playing with your data!

----
