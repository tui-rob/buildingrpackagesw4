#' Read in .csv format FARS data file to a tibble
#'
#' This function reads a in .csv format FARS data file to a data.frame.
#'
#' @param path Path to data
#' @param filename A character string giving the name of the data file
#'
#' @importFrom dplyr tbl_df
#' @importFrom readr read_csv
#'
#' @return This function returns a tibble containing the FARS data. If invalid filename provided, returns error with message that file does not exist.
#'
#' @examples
#' fars_read(system.file("extdata", package = "buildingrpackagesw4"), "accident_2013.csv.bz2")
#'
#' @export

fars_read <- function(path, filename) {
        path_to_file <- file.path(path, filename)
        if(!file.exists(path_to_file))
                stop("file '", path_to_file, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(path_to_file, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Make a FARS filename
#'
#' This function creates a FARS filename string from a provided year input.
#'
#' @param year The year of the data file in YYYY format (e.g. 2013)
#'
#' @return This function returns a string representing a valid FARS filename format
#'
#' @examples
#' make_filename(2013)
#'
#' @export

make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Read in multiple FARS .csv format data files and extract year/month columns
#'
#' This function reads in a series of .csv FARS data files and returns a tibble containing month and year columns from those data files.
#'
#' @param path Path to data files
#' @param years A vector of years (e.g. c(2013, 2014))
#'
#' @importFrom dplyr mutate select
#' @importFrom magrittr %>%
#'
#' @return This function returns a tibble containing year/month columns. If an invalid year provided, returns NULL and provides warning.
#'
#' @examples
#' fars_read_years(system.file("extdata", package = "buildingrpackagesw4"), c(2013, 2014))
#'
#' @export

fars_read_years <- function(path, years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(path, file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Summarize multiple FARS .csv format data files
#'
#' This function reads in multiple FARS .csv format data files and summarises the data by returning count observations in each year/month category.
#'
#' @param path Path to data files
#' @param years A vector of years (e.g. c(2013, 2014))
#'
#' @importFrom dplyr bind_rows group_by summarize n
#' @importFrom magrittr %>%
#' @importFrom tidyr spread
#'
#' @return This function returns a tibble with the counts of observations in each year/month
#'
#' @examples
#' fars_summarize_years(system.file("extdata", package = "buildingrpackagesw4"), c(2013, 2014))
#'
#' @export

fars_summarize_years <- function(path, years) {
        dat_list <- fars_read_years(path, years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Plot accident data for state
#'
#' This function reads in a FARS .csv format data file for a given year, extracts data for a given state number, and plot accidents for that state on a map.
#'
#' @param path Path to data file
#' @param state.num Integer representing state for which data required
#' @param year Year of data required  (e.g. 2013)
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @return This function returns a map of the given state with accidents plotted for the given year. If invalid state number provided, error occurs and message returned.
#' If no data exists for provided year and state_num parameters, "no accidents to plot" message trigged and NULL returned.
#'
#' @examples
#' fars_map_state(system.file("extdata", package = "buildingrpackagesw4"), 1, 2013)
#'
#' @export

fars_map_state <- function(path, state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(path, filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
