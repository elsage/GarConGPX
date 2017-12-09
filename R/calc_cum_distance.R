#' Calculate the cumulative distance between points.
#' @name calc_cum_distance
#' @param lon ordered vector of longitude marks.
#' @param lat ordered vector of latitude marks.
#' @return cumulative distances between successive coordinates.
#' @export
calc_cum_distance <- function(lon, lat) {
  vapply(seq_along(lat), function(i) {
    if (i == 1) return(0)
    prev_coord <- c(lon[i-1], lat[i-1])
    curr_coord <- c(lon[i], lat[i]) 
    return(geosphere::distm(prev_coord, curr_coord, fun = distHaversine))
  }, double(1)) -> dist_btwn_pts
  return(cumsum(dist_btwn_pts))
}