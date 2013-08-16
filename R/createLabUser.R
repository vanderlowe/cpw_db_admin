createLabUser <- function(user, password) {  
  # Start by dropping the user
  try(magicSQL(sprintf("DROP USER '%s'@'%%';", user), "cpw_meta"), silent = T)

  create.user <- sprintf("CREATE USER '%s'@'%%' IDENTIFIED BY '%s';", user, password)
  cat(create.user,"\n")
  magicSQL(create.user, "cpw_meta")
  
  # Read-only privileges to all tables
  grant.select <- sprintf("GRANT SELECT ON `cpw%%`.* TO '%s'@'%%' IDENTIFIED BY '%s';", user, password)
  cat(grant.select, "\n")
  magicSQL(grant.select, "cpw_meta")
  
  # Select and insert to results and litReview tables
  results.table <- sprintf("GRANT SELECT, INSERT ON `cpw_results`.* TO '%s'@'%%' IDENTIFIED BY '%s';", user, password)
  cat(results.table, "\n")
  magicSQL(results.table, "cpw_meta")
  litReview.table <- sprintf("GRANT SELECT, INSERT ON `cpw_litReview`.* TO '%s'@'%%' IDENTIFIED BY '%s';", user, password)
  cat(litReview.table, "\n")
  magicSQL(litReview.table, "cpw_meta")
  
  # Flush privileges
  magicSQL("FLUSH PRIVILEGES;", "cpw_meta")
  return(invisible(NULL))
}
