#' @note modified from jsonlite::stream_in
#' @noRd 
#' @param con a connection. closed on exit. make a new connection if you reuse
#' the same file on subsequent uses. required
#' @param pagesize (integer) number of lines to process in each loop. 
#' default: 500
#' @param verbose (logical) print messages. default: `TRUE`
#' @examples \dontrun{
#' file <- system.file("examples", 'ndgeojson1.json', package = "geojson")
#' con <- file(file)
#' con
#' stream_in_geojson(con)
#' }
stream_in_geojson <- function(con, pagesize = 500, verbose = TRUE) {
  if (!inherits(con, "connection")) {
    stop("Argument 'con' must be a connection.")
  }
  stopifnot(inherits(pagesize, c('integer', 'numeric')))
  stopifnot(inherits(verbose, 'logical'))

  res <- character()
  count <- 0
  counter <- function(x) {
    res <<- c(res, x)
    count <<- count + length(x)
  }

  if (!isOpen(con, "r")) {
    if (verbose) message("opening ", class(con)[1L]," input connection.")

    # binary connection prevents recoding of utf8 to latin1 on windows
    open(con, "rb")
    on.exit({
      if (verbose) message("closing ", class(con)[1L]," input connection.")
      close(con)
    })
  }

  # Read data page by page
  repeat {
    page <- readLines(con, n = pagesize, encoding = "UTF-8")
    if (length(page)) {
      # remove zero length lines
      cleanpage <- Filter(nchar, page)
      # clean up text sequences special character
      cleanpage <- gsub("\036", "", cleanpage)
      # process
      counter(unlist(unname(
        Map(to_feature, cleanpage, extract_features(cleanpage)))))
      if (verbose) cat("\r Found", count, "records...")
    }
    if (length(page) < pagesize) break
  }

  return(res)
}

to_feature <- function(w, type) {
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
