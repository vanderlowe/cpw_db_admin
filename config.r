.base.path <- "/Users/Ilmo/Downloads/"
.data.path <- "FB to Import"
.full.path <- paste0(.base.path, .data.path)

target_db = "cpw_Countries"

drop_first_line = FALSE  # FALSE = regular csv files with names on first row
                         # TRUE = Qualtrics files that have prompt on the second row under the header
