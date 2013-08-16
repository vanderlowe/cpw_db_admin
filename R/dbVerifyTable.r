#' Compares that data in a database matches data in a local data(.frame)
#' 
#' This function helps to verify that data was uploaded correctly into a database.
#' @param original.data A dataframe containing the original copy of the data.
#' @param table.name Name of the table to be tested
#' @param conn A valid RMySQL connection object.
dbVerifyTable <- function(local.data=NULL, table.name = NULL, conn=magicDB()) {
  require(testthat)
  
  if (is.null(table.name)) {
    error.msg <- sprintf("You must give the name of the table you wish to verify.")
    stop(error.msg)
  }
  
  remote.data <- getMySQLdata(table.name, conn = conn)
  
  test_that("Column names are the same", {
    expect_equal(names(local.data), names(remote.data))
  })
  
  test_that("Datasets contain identical data", {
    for (i in 1:ncol(local.data)) {
      v <- names(local.data)[i] # Get column name
      cat("Testing", v)
      
      test_that("Each column has identical data", {
        # Load column data
        local.col <- local.data[,i]
        cat(".")
        if (class(local.col) == "factor") {local.col <- as.character(local.col)}
        cat(".")
        remote.col <- remote.data[,i]
        if (class(remote.col) == "factor") {remote.col <- as.character(remote.col)}
        cat(".")
        
        cat("(")
        cat(class(local.col), "/", class(remote.col))
        cat(")")
        expect_equivalent(local.col,remote.col)
        cat(" - OK\n")  
      })
    }
  })
  cat("All done!")
}
