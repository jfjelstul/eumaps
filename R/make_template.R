# Joshua C. Fjelstul, Ph.D.
# eumaps R package

make_template <- function(date = NULL, subset = NULL) {

  error <- "The argument 'date' should be a string in the format 'YYYY-MM-DD' or an object of class 'Date'."
  if(is.null(date)) {
    date <- Sys.Date()
  } else {
    if (class(date) != "Date") {
      if(class(date) == "character") {
        if(stringr::str_detect(date, "^[0-9]{4}-[0-9]{2}-[0-9]{2}$")) {
          date <- lubridate::ymd(date)
        } else {
          stop(error)
        }
      } else {
        stop(error)
      }
    }
  }

  error <- "The argument 'subset' should be a character vector"
  if(!is.null(subset)) {
    if(class(subset) != "character") {
      stop(error)
    }
  }

  template <- member_states

  template$end_date[is.na(template$end_date)] <- lubridate::ymd(Sys.Date())
  template <- dplyr::filter(template, start_date <= date, end_date >= date)

  if(!is.null(subset)) {
    if(class(subset) == "character") {
      template <- dplyr::filter(template, member_state %in% subset)
    }
  }

  template <- dplyr::select(template, member_state_id, member_state, member_state_code)

  if (nrow(template) == 0) {
    stop("There are no member states on this date!")
  }

  return(template)
}
