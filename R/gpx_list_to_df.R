#' Converts list of tracks into a dataframe
#' @name gpx_list_to_df
#' @param trk_lst list of tracks extracted from .gpx file(s)
#' @return dataframe containing track data
#' @export
gpx_list_to_df <- function(trk_lst) {
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