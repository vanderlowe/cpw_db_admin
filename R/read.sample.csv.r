#' Read a portion of a csv-file
#' 
#' Instead of loading an entire file, the function reads the first n rows (over 9,000 by default)
#' to get a sample of the data.
#' 
#' @param file.name The name of the csv-file
#' @param n The desired number of lines to be read
read.sample.csv <- function(file.name, n = 9001, ...) {
  file.name <- paste0(.full.path, "/", file.name)
  f <- read.csv(file.name, nrows = n, ...)
  return(f)
}
