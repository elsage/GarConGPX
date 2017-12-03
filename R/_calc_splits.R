.calc_splits <- function(cum_distance, split_type = "mile") {
  switch(split_type,
         "mile" = floor(cum_distance / 1600) + 1,
         "km"   = floor(cum_distance / 1000) + 1) -> splits
  return(splits)
}