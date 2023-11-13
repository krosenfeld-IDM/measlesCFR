library(reticulate)
reticulate::use_python("/opt/miniconda/envs/mrtool-0.1.0/bin/python")
mrtool <- import("mrtool")
library(measlesCFR)
library(dplyr)
setwd("/mnt")

country.list <- listOfCountries()
short.country.list <- c('NGA')

predictAgeCFR <- function(country, start_age, end_age) {
  df <- predictCFR(country=country, start_age=start_age, end_age=end_age, start_year=2019, end_year=2019)
  return(df)
  }


concatenated_function <- function(strings) {
  # Initialize an empty data frame to store the results
  result_df <- data.frame()
  
  # first do [0, 5) years at monthly resolution
  ages <- seq(0, 5*12-1) / 12
  for (country in strings) {
    for (age in ages) {
      # Call predictCFR on each string
      df <- predictAgeCFR(country, age, ceiling(age))
      # Concatenate the resulting data frame to result_df
      result_df <- bind_rows(result_df, df)      
    }
  }
  
  # then do yearly bins from 5 years out to 40
  for (country in strings) {
      # Call predictCFR 
      df <- predictAgeCFR(country, 5, 40)
      # Concatenate the resulting data frame to result_df
      result_df <- bind_rows(result_df, df)      
  }
  
  return(result_df)
}

final_df <- concatenated_function(country.list)
write.csv(final_df, "cfr_estimates.csv")
