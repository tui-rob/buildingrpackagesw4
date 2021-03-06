% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read_years}
\alias{fars_read_years}
\title{Read in multiple FARS .csv format data files and extract year/month columns}
\usage{
fars_read_years(path, years)
}
\arguments{
\item{path}{Path to data files}

\item{years}{A vector of years (e.g. c(2013, 2014))}
}
\value{
This function returns a tibble containing year/month columns. If an invalid year provided, returns NULL and provides warning.
}
\description{
This function reads in a series of .csv FARS data files and returns a tibble containing month and year columns from those data files.
}
\examples{
fars_read_years(system.file("extdata", package = "buildingrpackagesw4"), c(2013, 2014))

}
