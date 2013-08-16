getMySQLdata <- function(table.name, conn=magicDB()) {
  current.db <- as.character(dbGetQuery(conn, "SELECT DATABASE()"))
  magicSQL("SET NAMES utf8", current.db) 
  sql.query <- sprintf("SELECT * FROM %s", table.name)
  result <- magicSQL(sql.query, current.db)
  return(result)
}