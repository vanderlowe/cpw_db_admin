require(magic)
require(testthat)

# Define directory for the data files etc.
source("config.r")

# Load all functions
setwd("R")
for (f in list.files()) {source(f)}
setwd(.full.path)

# Load variable information
vars <- read.csv("variables.csv", stringsAsFactors = F)

test_that("Source data has the required column names", {
  expect_true(all(c("Database","Name","Table","Description") %in% names(vars)))
})

for (i in 1:nrow(vars)) {
  var <- vars[i, ]
  metaNewVariable(var)
}

