require(RMySQL)
require(magic)

magicDB <- function(db = NULL) {
  if (is.null(db)) {stop("You must specify a database")}
  killConnections()
  connection <- dbConnect(MySQL(), 
                    host = Sys.getenv("magic_host"), 
                    user = Sys.getenv("magic_user"), 
                    password = Sys.getenv("magic_password"),
                    dbname = db
  )
  return(connection)
}

killConnections <- function() {
  all_cons <- dbListConnections(MySQL())
  for(con in all_cons) {
    dbDisconnect(con)
  }
  return(TRUE)
}



