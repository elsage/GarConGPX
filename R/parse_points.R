parse_points <- function(pts) {
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