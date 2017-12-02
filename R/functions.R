#' Read Dir of .GPX Files to R Dataframe
#' 
#' Args:
#'   dir: The directory where you have saved your .gpx files.
#'  
#' Returns: 
#'   A dataframe the .gpx data. The dataframe contains information
#'   about latitude, longitude, elevation, datetime, activity,
#'   the activity type, miles and kilometer splits for the activity. 
#' @export
gpx_dir_to_df <- function(dir) {
  dir_files  <- list.files(dir, full.names = TRUE)
  gpx_files  <- dir_files[grepl("\\.GPX", toupper(dir_files))]
  track_list <- list()
  for (i in seq_along(gpx_files)) {
    message(sprintf("Parsing %s", gpx_files[i]))
    xml_file      <- xml2::xml_ns_strip(xml2::read_xml(gpx_files[i]))
    xml_tracks    <- xml2::xml_find_all(xml_file, ".//trk")
    track_list[i] <- .parse_tracks(xml_tracks, i)
  }
  df     <- .gpx_list_to_df(track_list)
  aug_df <- augment_by_activity(df)
  colnames(aug_df) <- c("latitude", 
                        "longitude", 
                        "elevation", 
                        "datetime", 
                        "activity", 
                        "activity_type",
                        "activity_id", 
                        "cumulative_distance",
                        "split_mile", 
                        "split_km")
  return(aug_df)
}

.parse_tracks <- function(trks, file_id) {
  lapply(seq_along(trks), function(i) {
    name    <- xml2::xml_find_all(trks[i], ".//name")[[1]]
    type    <- xml2::xml_find_all(trks[i], ".//type")[[1]]
    trk_pts <- xml2::xml_find_all(trks[i], ".//trkpt")

    return(list(trk_name = xml2::as_list(name)[[1]],
                trk_id   = paste0(file_id, '-', i), 
                type     = xml2::as_list(type)[[1]], 
                pts      = .parse_points(trk_pts)))
  })
}

.parse_points <- function(pts) {
  lapply(pts, function(pt) {
    attr <- xml2::xml_attrs(pt)
    vals <- xml2::as_list(pt)
    lat  <- as.double(attr['lat'])
    lon  <- as.double(attr['lon'])
    ele  <- as.double(vals$ele[[1]])
    time <- lubridate::ymd_hms(vals$time[[1]], tz = "UTC")

    return(list(lat = lat, lon = lon, ele = ele, time = time))
  }) -> pts_list
}

.gpx_list_to_df <- function(trk_lst) {
  df_list <- list()
  for (i in seq_along(trk_lst)) {
    
    trk_mat <- matrix(unlist(trk_lst[[i]]$pts), ncol = 4, byrow = TRUE)
    trk_df  <- data.frame(trk_mat)
    colnames(trk_df) <- c("lat", "lon", "ele", "time")

    trk_df$time          <- lubridate::as_datetime(trk_df$time, origin = "1970-01-01 UTC")
    trk_df$activity      <- trk_lst[[i]]$trk_name
    trk_df$activity_type <- trk_lst[[i]]$type
    trk_df$activity_id   <- trk_lst[[i]]$trk_id
    
    df_list[[i]] <- trk_df
  }
  df <- do.call("rbind", df_list)
  return(df)
}

calc_cum_distance <- function(lon, lat) {
  vapply(seq_along(lat), function(i) {
    if (i == 1) return(0)
    prev_coord <- c(lon[i-1], lat[i-1])
    curr_coord <- c(lon[i], lat[i]) 
    return(geosphere::distm(prev_coord, curr_coord, fun = distHaversine))
  }, double(1)) -> dist_btwn_pts
  return(cumsum(dist_btwn_pts))
}

calc_splits <- function(cum_distance, split_type = "mile") {
  switch(split_type,
         "mile" = floor(cum_distance / 1600) + 1,
         "km"   = floor(cum_distance / 1000) + 1) -> splits
  return(splits)
}

augment_by_activity <- function(df) {
   activity_list   <- list()
   unique_activity <- unique(df$activity_id)
   for (i in seq_along(unique_activity)) {
     sb_df <- df[df$activity_id == unique_activity[i], ]
     sb_df$cum_distance   <- calc_cum_distance(sb_df$lon, sb_df$lat)
     sb_df$split_mile     <- calc_splits(sb_df$cum_distance, "mile")
     sb_df$split_km       <- calc_splits(sb_df$cum_distance, "km")
     activity_list[[i]]   <- sb_df
   }
   df <- do.call("rbind", activity_list)
   return(df)
}