setwd("~/Downloads/FB to Import/")

rows.to.sample <- 5000
cut.off <- 15000

areAllMissing <- function(x) {
  if (all(is.na(x))) {
    return(TRUE)
  }
  return(FALSE)
}

getNAcolumns <- function(x) {
  results <- data.frame(col = names(x), state = sapply(x, areAllMissing), stringsAsFactors=F)
  return(results[results$state == T,]$col)
}

isComplete <- function(x) {
  if (identical(getNAcolumns(x), character(0))) {
    return(TRUE)
  }
  return(FALSE)
}

while (rows.to.sample < cut.off) {
  cat(rows.to.sample, "\n")
  x <- read.csv(file="OOS PDATA vIII.csv", header=T, nrows = rows.to.sample)
  print(getNAcolumns)
  if (isComplete(x)) {
    message("The data frame is fully populated")
    break
  }
  rows.to.sample <- rows.to.sample * 2
}

dbWriteTable(magicDB("cpw_bc345"), name="OOS", value=x)