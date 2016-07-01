#' multilinestring class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "MultiLineString", "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
#' (y <- multilinestring(x))
#' y$string
#' y$type()
#' y$pretty()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' file <- system.file("examples", 'multilinestring_one.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- multilinestring(str))
#' y$string
#' y$type()
#' y$pretty()

multilinestring <- function(x) {
  UseMethod("multilinestring")
}

#' @export
multilinestring.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multilinestring.character <- function(x) {
  x <- as_mls(x)
  switch_verify_names(x)
  verify_class(x, "MultiLineString")
  hint_geojson(x)
  MultiLineString$new(x = x)
  #structure(list(tmp), class = "mls")
}

MultiLineString <- R6::R6Class(
  "MultiLineString",
  public = list(
    x = NULL,
    string = NULL,

    initialize = function(x = NULL) {
      self$string <- x
      #private$is_feat <- is_feature(self$string)
      private$no_lines <- length(asc(jqr::jq(self$string, ".coordinates[] | length ")))
      private$no_nodes_each_line <- get_each_nodes(self$string)
      private$coords <- get_coordinates(self$string)
    },
    print = function(...) {
      cat("<MultiLineString>", "\n")
      cat("  no. lines: ", private$no_lines, "\n")
      cat("  no. nodes / line: ", private$no_nodes_each_line, "\n")
      cat("  coordinates: ", private$coords, "\n")
    },
    type = function() {
      cchar(jqr::jq(unclass(self$string), ".type"))
    },
    pretty = function() {
      jsonlite::prettify(self$string)
    },
    write = function(file) {
      cat(jsonlite::toJSON(jsonlite::fromJSON(self$string), pretty = TRUE, auto_unbox = TRUE), file = file)
    }
  ),

  private = list(
    no_nodes_each_line = NULL,
    no_lines = NULL,
    coords = NULL
  )
)

as_mls <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    jqr::jq(unclass(x), ".geometry")
  } else if (asc(jqr::jq(unclass(x), ".type")) == "MultiLineString") {
    x
  }
}

#' @export
print.mls <- function(x, ...) {
  print(x[[1]])
}
