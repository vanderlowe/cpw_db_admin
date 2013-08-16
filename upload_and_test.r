require(magic)
# Define directory for the data files etc.
source("config.r")

# Load all functions
setwd("R")
for (f in list.files()) {source(f)}
setwd(.full.path)

# Load all data files
files <- list.files(path=.full.path)

ok.files <- c()

for (filename in files) {
  # Read in local data
  cat(filename,"(")
  d <- read.csv(filename)
  
  if (drop_first_line) {
    d <- d[-1, ]
    temp.file <- tempfile()
    write.csv(d, temp.file)
    d <- read.csv(temp.file)
    unlink(temp.file)
  }
  
  # Rename table and column names (MySQL does not like dots or spaces)
  table.name <- gsub("\\.csv$", "", filename)
  table.name <- gsub("(\\.|\\s+)", "_", table.name)
  names(d) <- gsub("(\\.|\\s+)", "_", names(d)) # Rename columns
  
  cat(table.name)
  cat(")\n")
  dbCreateTableFrom(d, table.name, overwrite = T, conn = magicDB(target_db))
  
  dbVerifyTable(d, table.name, conn = magicDB(target_db))
  ok.files <- c(filename)
}

