.augment_by_activity <- function(df) {
   activity_list   <- list()
   unique_activity <- unique(df$activity_id)
   for (i in seq_along(unique_activity)) {
     sb_df <- df[df$activity_id == unique_activity[i], ]
     sb_df$cum_distance   <- .calc_cum_distance(sb_df$lon, sb_df$lat)
     sb_df$split_mile     <- .calc_splits(sb_df$cum_distance, "mile")
     sb_df$split_km       <- .calc_splits(sb_df$cum_distance, "km")
     activity_list[[i]]   <- sb_df
   }
   df <- do.call("rbind", activity_list)
   return(df)
}