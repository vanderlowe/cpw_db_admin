dbCreateTableFrom <- function(my.data.frame, table.name=NULL, conn=magicDB(), ...) {
  if (is.null(table.name)) {
    error.msg <- sprintf("You must provide a name for the new table.")
    stop(error.msg)
  }
  
  dbWriteTable(conn=conn, value=my.data.frame, name=table.name, row.names = F, ...)
  return(TRUE)
}
