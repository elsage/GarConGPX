#' Read Dir of .GPX Files to R Dataframe
#' @name gpx_dir_to_df
#' @param dir The directory where you have saved your .gpx files.
#' @return A dataframe the .gpx data. The dataframe contains information
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
  aug_df <- .augment_by_activity(df)
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