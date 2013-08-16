metaNewVariable <- function(var) {
  if(!require(magic)) {stop("You must first install magic.")}
  
  # Fix backticks
  var$Description <- gsub("`", "'", var$Description)
  var$Description <- gsub("'", "\\\\'", var$Description)
  
  sql.cmd <- sprintf("
    INSERT INTO cpw_meta.variables
    (`Database`, `Name`, `Table`, `Description`)
    VALUES ('%s', '%s', '%s', '%s')", 
    var$Database, var$Name, var$Table, var$Description
  )
  
  magicSQL(sql.cmd, "cpw_meta")
  print(sprintf("Created variable %s", var$Name))
  return(invisible(NULL))
}