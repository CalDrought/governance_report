# Load libraries
library(tidyverse)
library(testthat)
library(lubridate)

# Load data
five_year_outlook <- read_csv(here::here("data", "five_year_water_shortage_outlook.csv"))

# Test that for numerical columns
test_that("Not all columns have numeric values between 0 and positive infinity", {
  
  columns <- c("benefit_demand_reduction_acre_feet", "benefit_supply_augmentation_acre_feet",
               "water_use_acre_feet", "water_supplies_acre_feet", "org_id", "uwmp_year")
  
  # Create a for loop to iterate for each column
  for (col in columns){
    
    column_values <- five_year_outlook[[col]]
    
    # Check the column is numeric
    expect_true(
      is.numeric(column_values),
      info = paste(col, "is not numeric")
    )
    
    # Identify invalid values: NA, NaN, Inf, -Inf, or < 0
    bad_values <- !is.finite(column_values) | column_values < 0
    total_bad <- sum(bad_values, na.rm = TRUE)
    bad_rows <- which(bad_values)
    
    expect(
      total_bad == 0,
      failure_message = paste(
        "Column", col, "has", total_bad, "invalid values in rows:", paste(bad_rows, collapse = ", ")
      )
    )
  }
})

# Test that checking PWSIDs are correct
test_that("Not all Pwsids are character strings with 9 characters per part", {
  
  # Column name for reference
  column <- "pwsid"
  
  # Access the actual column values from your data frame
  column_values <- five_year_outlook[[column]]
  
  # Check that the column is of character type
  expect_true(
    is.character(column_values),
    info = paste(column, "is not a character string")
  )
  
  # Identify invalid values: NA, or parts that don't have exactly 9 characters
  invalid_values <- sapply(column_values, function(x) {
    
    # NAs are invalid values
    if (is.na(x)) return(TRUE)
    
    # For multiple PWSIDs
    # Split the string by commas
    parts <- strsplit(x, ",")[[1]]
    
    # Trim space from each part
    parts <- trimws(parts)
    
    # Check if any part does NOT have exactly 9 characters
    any(nchar(parts) != 9)
  })
  
  # Sum total invalid values and identify each specific row
  total_invalid <- sum(invalid_values, na.rm = TRUE)
  invalid_rows <- which(invalid_values)
  
  # Failure message
  expect(
    total_invalid == 0,
    failure_message = paste(
      "PWSID column has", total_invalid, "invalid values in rows:", paste(invalid_rows, collapse = ", ")
    )
  )
})

# Multiple PWSID boolean check
test_that("Not all is_multiple_pwsid values are true or false", {
  
  # Column name
  column <- "is_multiple_pwsid"
  
  # Indexing column values
  column_values <- five_year_outlook[[column]]
  
  # Expect values as logicals
  expect_true(
    is.logical(column_values),
    info = paste(column, "is not a logical")
  )
  
  # Identify invalid rows:
  invalid_values <- !is.logical(column_values) | is.na(column_values)
  total_invalid <- sum(invalid_values)
  invalid_rows <- which(invalid_values)
  
  # Failure message
  expect(
    total_invalid == 0,
    failure_message = paste(
      "is_multiple_pwsid has", total_invalid, "invalid values in rows:", paste(invalid_rows, collapse = ", ")
    )
  )
  
})

# Start and end date check
test_that("Not all forecast_start_date and forecast_end_dates are date types", {
  
  # Column names
  columns <- c("forecast_start_date", "forecast_end_date")
  
  # For loop interates over both columns checking date type
  for (column in columns) {
  
  # Indexing column values, itereating in for loop
  column_values <- five_year_outlook[[column]]
  
  # Expecting date type
  expect_true(
    is.Date(column_values),
    info = paste(column, "does not contain all date values")
  )
  
  # Identify missing rows
  invalid_values <- !is.Date(column_values) | is.na(column_values)
  total_invalid <- sum(invalid_values)
  invalid_rows <- which(invalid_values)
  
  # Failure message
  expect(
    total_invalid == 0,
    failure_message = paste(
      "Column", column, "has", total_invalid, "invalid values in rows:", paste(invalid_rows, collapse = ", ")
    ))
  }
})

# Supplier name check
test_that("Not all supplier_name are character strings",{
  
  # Column name
  column <- "supplier_name"
  
  # Indexing values in supplier_name
  column_values <- five_year_outlook[[column]]
  
  # Expecting values as character strings
  expect_true(
    is.character(column_values),
    info = paste(column, "does not contain all character strings")
  )
  
  # Identify missing rows
  invalid_values <- !is.character(column_values) | is.na(column_values)
  total_invalid <- sum(invalid_values)
  invalid_rows <- which(invalid_values)
  
  # Failure message
  expect(
    total_invalid == 0,
    failure_message = paste(
      "supplier_name has", total_invalid, "invalid values in rows:", paste(invalid_rows, collapse = ", ")
    ))
})

# Testing where total water use is greater than water supply + augmentation + reduction 
test_that("Some rows have greater water use than water supply", {
  
  # Column names 
  columns <- c(
    "water_use_acre_feet", 
    "water_supplies_acre_feet", 
    "benefit_supply_augmentation_acre_feet", 
    "benefit_demand_reduction_acre_feet"
  )
  
  # Subset relevant columns
  column_values <- five_year_outlook[, columns]
  
  # Expect to be no NAs
  expect_false(any(is.na(column_values)),
               info = "NA values found in one or more rows")
  
  # Add total_available as a new column to the five_year_outlook
  five_year_outlook <- five_year_outlook %>%
    mutate(total_available = water_supplies_acre_feet +
             benefit_supply_augmentation_acre_feet +
             benefit_demand_reduction_acre_feet)
  
  # Identify rows where there's a gap
  gap_rows <- which(five_year_outlook$water_use_acre_feet > five_year_outlook$total_available)
  
  if (length(gap_rows) == 0) {
    print("✅ No gaps found: all water use is within total available supply.")
    print(head(five_year_outlook[, c(columns, "total_available")]))
  } else {
    print("⚠️ Rows with water use > total available supply:")
    
    gap_df <- five_year_outlook[gap_rows, c(columns, "total_available")]
    
    # Add row number as a column
    gap_df <- gap_df %>%
      mutate(row_number = gap_rows, .before = 1)  # Insert at the beginning
    
    print(gap_df)
  }
  
  
  # Final test assertion
  expect_true(
    length(gap_rows) > 0,
    info = "No rows found where water use exceeds the total available supply."
  )
})




