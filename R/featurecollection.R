#' featurecollection class
#'
#' @export
#' @param x input
#' @examples
#' file <- system.file("examples", 'featurecollection1.geojson', package = "geojson")
#' file <- system.file("examples", 'featurecollection2.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- featurecollection(str))
#' y$string
#' y$type()
#' y$pretty()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
featurecollection <- function(x) {
  UseMethod("featurecollection")
}

#' @export
featurecollection.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
featurecollection.character <- function(x) {
  x <- as_featurecollection(x)
  verify_class_(x, "FeatureCollection")
  switch_verify_names(x)
  hint_geojson(x)
  FeatureCollection$new(x = x)
}

FeatureCollection <- R6::R6Class(
  "FeatureCollection",
  public = list(
    x = NULL,
    string = NULL,
    gtype = NULL,
    no_feats = NULL,
    five_feats = NULL,

    initialize = function(x = NULL) {
      self$string <- x
      self$gtype <- get_type(self$string)
      self$no_feats <- asc(jqr::jq(unclass(self$string), ".features | length"))
      self$five_feats <- paste0(asc(jqr::jq(unclass(self$string), ".features[].geometry.type")), collapse = ", ")
    },
    print = function(...) {
      cat("<FeatureCollection>", "\n")
      cat("  type: ", self$gtype, "\n")
      cat("  no. features: ", self$no_feats, "\n")
      cat("  features (1st 5): ", self$five_feats, "\n")
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
  )
)

as_featurecollection <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "FeatureCollection") {
    x
  } else {
    sprintf('{ "type": "FeatureCollection", "features": %s }', x)
  }
}
