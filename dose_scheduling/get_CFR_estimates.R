library(reticulate)
reticulate::use_python("/opt/miniconda/envs/mrtool-0.1.0/bin/python")
mrtool <- import("mrtool")
library(measlesCFR)
library(dplyr)
setwd("/mnt")

country.list <- listOfCountries()
short.country.list <- country.list[1:3]

predictAgeCFR <- function(country, age) {
  df <- predictCFR(country=country, start_age=age, end_age=1, start_year=2010, end_year=2019)
  return(df)
  }


concatenated_function <- function(strings) {
  # Initialize an empty data frame to store the results
  result_df <- data.frame()
  
  for (country in strings) {
    for (age in c(3/12, 6/12, 9/12, 12/12)) {
      # Call predictCFR on each string
      df <- predictAgeCFR(country, age)
      # Concatenate the resulting data frame to result_df
      result_df <- bind_rows(result_df, df)      
    }
  }
  
  return(result_df)
}

final_df <- concatenated_function(country.list)
write.csv(final_df, "cfr_estimates.csv")
