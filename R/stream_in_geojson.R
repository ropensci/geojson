# modified from jsonlite::stream_in
# con <- file(file)
# stream_in_geojson(con)

# con <- file('/Users/sckott/Downloads/honolulu_hawaii_small.geojsonl')
# stream_in_geojson(con)

stream_in_geojson <- function(con, pagesize = 500) {
  if (!inherits(con, "connection")) {
    stop("Argument 'con' must be a connection.")
  }

  res <- character()
  count <- 0
  counter <- function(x) {
    res <<- c(res, x)
    count <<- count + length(x)
  }

  if (!isOpen(con, "r")) {
    message("opening ", class(con)[1L]," input connection.")

    # binary connection prevents recoding of utf8 to latin1 on windows
    open(con, "rb")
    on.exit({
      message("closing ", class(con)[1L]," input connection.")
      close(con)
    })
  }

  # Read data page by page
  repeat {
    page <- readLines(con, n = pagesize, encoding = "UTF-8")
    if (length(page)) {
      cleanpage <- Filter(nchar, page)
      counter(Map(to_feature, cleanpage, extract_features(cleanpage)))
      cat("\r Found", count, "records...")
    }
    if (length(page) < pagesize) break
  }

  return(res)
}

to_feature <- function(w, type) {
  # type <- tolower(cchar(jqr::jq(unclass(w), ".type")))
  if (
    type %in% c('point', 'multipoint', 'polygon', 'multipolygon', 
    'linestring', 'multilinestring')
  ) {
    w <- feature(w)[[1]]
  } 
  return(w)
}

extract_features <- function(w) {
  tolower(cchar(jqr::jq(w, ".type")))
}
