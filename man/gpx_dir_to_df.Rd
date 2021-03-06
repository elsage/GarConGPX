% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gpx_dir_to_df.R
\name{gpx_dir_to_df}
\alias{gpx_dir_to_df}
\title{Read Dir of .GPX Files to R Dataframe}
\usage{
gpx_dir_to_df(dir)
}
\arguments{
\item{dir}{The directory where you have saved your .gpx files.}
}
\value{
A dataframe the .gpx data. The dataframe contains information
  about latitude, longitude, elevation, datetime, activity,
  the activity type, miles and kilometer splits for the activity.
}
\description{
Read Dir of .GPX Files to R Dataframe
}
