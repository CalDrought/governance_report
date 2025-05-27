#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                         Load Libraries and Data                             ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(tidyverse)
library(testthat)
library(janitor)
library(lubridate)
library(here)
library(DT)

# Load and clean data
historical <- read_csv(here("data", "historical_production_delivery.csv")) |> 
  clean_names()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                         Unit Tests on Key Columns                          ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1. Test: quantity_acre_feet is numeric and valid
test_that("quantity_acre_feet is numeric and non-negative", {
  column <- historical$quantity_acre_feet
  
  expect_true(is.numeric(column), info = "quantity_acre_feet is not numeric")
  
  bad <- !is.finite(column) | column < 0
  total_bad <- sum(bad, na.rm = TRUE)
  bad_rows <- which(bad)
  
  expect(total_bad == 0, 
         failure_message = paste("quantity_acre_feet has", total_bad, "invalid values in rows:", paste(bad_rows, collapse = ", ")))
})

# 2. Test: Dates are valid and present
test_that("start_date and end_date are Date type", {
  for (col in c("start_date", "end_date")) {
    expect_true(any(class(historical[[col]]) == "Date"), info = paste(col, "is not Date type"))
    missing <- is.na(historical[[col]])
    expect(sum(missing) == 0,
           failure_message = paste("Missing", col, "in rows:", paste(which(missing), collapse = ", ")))
  }
})

# 3. Test: org_id is numeric and complete
test_that("org_id is numeric and complete", {
  col <- historical$org_id
  expect_true(is.numeric(col), info = "org_id is not numeric")
  expect(sum(is.na(col)) == 0,
         failure_message = paste("Missing org_id in rows:", paste(which(is.na(col)), collapse = ", ")))
})

# 4. Test: water_produced_or_delivered has valid categories
test_that("Valid values for water_produced_or_delivered", {
  expected <- c("water produced", "water delivered")
  actual <- unique(historical$water_produced_or_delivered)
  invalid <- setdiff(actual, expected)
  expect(length(invalid) == 0,
         failure_message = paste("Invalid category:", paste(invalid, collapse = ", ")))
})

# 5. Test: No duplicate org_id + date + water_type + delivery_type
test_that("No duplicate rows by group", {
  dupes <- historical |> 
    group_by(org_id, start_date, water_type, water_produced_or_delivered) |> 
    filter(n() > 1)
  expect(nrow(dupes) == 0,
         failure_message = paste("Found", nrow(dupes), "duplicate entries."))
})

# 6. Test: Missing water_type only allowed if quantity is NA
test_that("Missing water_type not allowed when quantity_acre_feet is present", {
  bad <- historical |> filter(!is.na(quantity_acre_feet) & is.na(water_type))
  expect(nrow(bad) == 0,
         failure_message = paste("Missing water_type where quantity_acre_feet is present:", nrow(bad), "rows"))
})

# 7. Test: start_date <= end_date
test_that("start_date is before or equal to end_date", {
  historical <- historical |> 
    mutate(start_date = ymd(start_date),
           end_date = ymd(end_date))
  
  bad <- historical |> filter(start_date > end_date)
  expect(nrow(bad) == 0,
         failure_message = paste("start_date is after end_date in", nrow(bad), "rows"))
})

# 8. Test: PWSID format (9-digit or comma-separated 9s)
test_that("PWSID format is valid", {
  invalid <- sapply(historical$pwsid, function(x) {
    if (is.na(x)) return(TRUE)
    parts <- strsplit(x, ",")[[1]] |> trimws()
    any(nchar(parts) != 9)
  })
  bad_rows <- which(invalid)
  expect(length(bad_rows) == 0,
         failure_message = paste("PWSID format invalid in rows:", paste(bad_rows, collapse = ", ")))
})

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                       Collect Data Quality Issues                           ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

issue_list <- list()

# Issue: Negative values
neg_count <- historical |> filter(quantity_acre_feet < 0) |> nrow()
if (neg_count > 0) issue_list[["Negative quantity_acre_feet"]] <- neg_count

# Issue: Missing quantity
missing_qty <- sum(is.na(historical$quantity_acre_feet))
if (missing_qty > 0) issue_list[["Missing quantity_acre_feet"]] <- missing_qty

# Issue: Missing water_type with quantity
missing_type <- historical |> filter(!is.na(quantity_acre_feet) & is.na(water_type)) |> nrow()
if (missing_type > 0) issue_list[["Missing water_type when quantity present"]] <- missing_type

# Issue: Invalid categories
invalid_cat <- historical |> filter(!water_produced_or_delivered %in% c("water produced", "water delivered")) |> nrow()
if (invalid_cat > 0) issue_list[["Invalid water_produced_or_delivered"]] <- invalid_cat

# Issue: Duplicate groupings
duplicate_rows <- historical |> 
  group_by(org_id, start_date, water_type, water_produced_or_delivered) |> 
  filter(n() > 1) |> 
  nrow()
if (duplicate_rows > 0) issue_list[["Duplicate rows by org_id/date/type/category"]] <- duplicate_rows

# Issue: start_date > end_date
date_logic_error <- historical |> filter(start_date > end_date) |> nrow()
if (date_logic_error > 0) issue_list[["start_date after end_date"]] <- date_logic_error

# Issue: Invalid PWSIDs
invalid_pwsid <- sapply(historical$pwsid, function(x) {
  if (is.na(x)) return(TRUE)
  parts <- strsplit(x, ",")[[1]] |> trimws()
  any(nchar(parts) != 9)
}) |> sum()
if (invalid_pwsid > 0) issue_list[["Invalid PWSID format"]] <- invalid_pwsid

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                        Display Issues in Table Format                       ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Convert list to data frame
issues_df <- tibble(
  Issue = names(issue_list),
  Count = as.integer(issue_list)
)

# Show as interactive DT table
DT::datatable(
  issues_df,
  options = list(dom = 't', pageLength = nrow(issues_df)),
  rownames = FALSE,
  caption = "Summary of Data Quality Issues in Historical Production and Delivery Dataset"
)

