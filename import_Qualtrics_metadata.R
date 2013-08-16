# TODO: Script is currently not fully functional

require(magic)
require(RMySQL)
require(stringr)

importQualtricsMetaData <- function(filename, database) {
  filedata <- readLines(con=filename, warn = F)
  prompts <- getPrompts(removeSPSScode(filedata))
  response.options <- getResponseOptions(filedata)
  table.name <- gsub("\\.sps$", "", filename)
  dbWritePrompts(prompts, database, table.name)
  dbWriteResponseOptions(response.options, database)
}

dbWritePrompts <- function(prompts, database, table.name) {
  for (i in 1:length(prompts)) {
    sql <- sprintf("INSERT INTO `variables` (`Database`, `Name`, `Table`, `Description`) VALUES ('%s', '%s', '%s', '%s')",
                   database, names(prompts)[i], table.name, dbEscapeStrings(magicDB("cpw_meta"), prompts[[i]])
    )
    magicSQL(sql, "cpw_meta")
  }
}

removeSPSScode <- function(filedata) {
  # Get rid of SPSS commands
  spss.junk <- c('\\.', 'CACHE\\.', 'EXECUTE.', 'TITLE \\".+\\"\\.', 'SUBTITLE \\"\\".', 'VALUE LABELS', 'VARIABLE LABELS')
  
  for (junk in spss.junk) {
    target <- paste("^", junk, "$", sep = "")
    filedata <- gsub(target, "", filedata)
  }
  
  filedata <- setdiff(filedata, "")  # Remove blank entries
  return(filedata)
}

getPrompts <- function(data) {
  prompts <- list()
  
  for (i in 1:length(data)) {
    line <- data[i]
    if (isVariableName(line) | isResponseOption(line)) {next}  # Skip variable names and response options
    
    # Split line to variable name and prompt
    elements <- strsplit(x=line, split ='\\s\\"')[[1]]  # Split at space followed by quote
    prompts[elements[1]] <- gsub('\\"$', "", elements[2])  # Remove closing quote
  }
  
  return(prompts)
}

isVariableName <- function(x) {
  if (grepl(pattern="\\t/", x)) {  # Check if line has a variable title (indicated by tab + /)
    return(TRUE)
  }
  return(FALSE)
}

isResponseOption <- function(x) {
  if (grepl(pattern="\\t\\t\\d", x)) {  # Check if line has a response option (indicated by tab * 2 + a number)
    return(TRUE)
  }
  return(FALSE)
}

getResponseOptions <- function(data) {
  responses <- list()
  
  for (i in 1:length(data)) {
    line <- data[i]
    
    if (isVariableName(line)) {  # Check if line has a variable title
        title <- str_trim(gsub("/", "", line))  # Get rid of whitespace and /-character
        responses[[title]] <- list()  # Create a placeholder for response options
    }
    
    if (isResponseOption(line)) {  # Check if line has a response option
      options <- strsplit(x = gsub(pattern="^\\\\t\\\\t", replacement="", x=line), split = '"')[[1]]
      responses[[title]][[length(responses[[title]]) + 1]] <- str_trim(options)
    }
    
  }
  
  return(responses)
}

dbWriteResponseOptions <- function(r, db) {
  for (var in names(r)) {
    sql <- sprintf("SELECT ID FROM `variables` WHERE `Name` = '%s' AND `Database` = '%s'", var, db)
    id <- magicSQL(sql, "cpw_meta")
    if (nrow(id) == 0) {stop("Cannot locate variable")}
    id <- id[,1]
    
    for (i in 1:length(r[[var]])) {  # Repeat for each of the variable's response option
      resp <- r[[var]][[i]]  # Character vector of length two
      if (length(resp) != 2) {stop("Problem: Response option should have a code and a label (i.e., two items). Yours does not.")}
      
      # Insert response option into cpw_meta
      sql <- sprintf("INSERT INTO responseOptions (`ID`, `Name`, `Code`, `Label`)
                      VALUES (%i, '%s', %i, '%s')",
                      id, as.character(var), as.numeric(resp[1]), dbEscapeStrings(magicDB("cpw_meta"), as.character(resp[2])))
      magicSQL(sql, "cpw_meta")
    }
  }  
}

setwd("~/Downloads/")
filename <- "developer_survey.sps"
db <- "cpw_OpenSource"
importQualtricsMetaData(filename, db)

