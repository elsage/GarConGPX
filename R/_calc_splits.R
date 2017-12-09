#' Calculate splits by type
#' @name .calc_splits
#' @param cum_distance ordered vector of cumulative distances
#' @param split_type denotes distance at which split occurs
#' @return cumulative distances between successive coordinates. 
.calc_splits <- function(cum_distance, split_type = "mile") {
  switch(split_type,
         "mile" = floor(cum_distance / 1600) + 1,
         "km"   = floor(cum_distance / 1000) + 1) -> splits
  return(splits)
}