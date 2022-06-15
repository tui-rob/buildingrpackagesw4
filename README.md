
# buildingrpackagesw4

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/tui-rob/buildingrpackagesw4.svg?branch=master)](https://travis-ci.com/tui-rob/buildingrpackagesw4)
<!-- badges: end -->


The functions provided in this package load and analyse data from the US National Highway Traffic Safety Administration's Fatality Analysis Reporting System, which is a nationwide census providing the American public yearly data regarding fatal injuries suffered in motor vehicle traffic crashes.

Use the following functions to analyse data:

-   `fars_summarize_years`: summarises the data for the given years by returning count observations in each year/month category
-   `fars_map_state`: plots accidents for a given state and year on a map

## Installation

You can install the development version of buildingrpackagesw4 from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tui-rob/buildingrpackagesw4")
```
