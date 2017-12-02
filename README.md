# GarCon_to_DF
 
## Purpose
GarConDF was put together in order to facilitate the extraction and anlysis of data downloaded from the Garmin Connect platform, specifically the GPX files that Garmin makes available for download.

In order to use, simply pass the path for the directory where your Garmin .GPX files are stored to **GarConDF::gpx_dir_to_df()**. 

The result will be a dataframe with the following shape: 
````r
dir <- "~/where_your_gpx_files_live"
dataframe <- gpx_dir_to_df(dir)

str(running_df)

'data.frame':   xxx obs. of  9 variables:
 $ latitude           : num  
 $ longitude          : num  
 $ elevation          : num  
 $ datetime           : POSIXct
 $ activity           : chr  
 $ activity_type      : chr  
 $ cumulative_distance: num 
 $ split_mile         : num  
 $ split_km           : num  
````