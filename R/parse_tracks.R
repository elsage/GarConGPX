#' Find xml nodes and extract attributes
#' @name parse_tracks
#' @param trks nodelist of <trk> nodes.
#' @param file_id index of file being parsed in directory.
#' @return a list containing the track name, track id, activity type
#'   and (most importantly) the track points.
#' @export
parse_tracks <- function(trks, file_id) {
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