#' featurecollection class
#'
#' @export
#' @param x input
#' @examples
#' file <- system.file("examples", 'featurecollection1.geojson', package = "geojson")
#' file <- system.file("examples", 'featurecollection2.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- featurecollection(str))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
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
  gtype <- get_type(x)
  no_feats <- asc(jqr::jq(unclass(x), ".features | length"))
  five_feats <- paste0(asc(jqr::jq(unclass(x), ".features[].geometry.type")), collapse = ", ")
  structure(x, class = "featurecollection",
            type = gtype,
            no_features = no_feats,
            five_feats = five_feats)
}

#' @export
print.featurecollection <- function(x, ...) {
  cat("<FeatureCollection>", "\n")
  cat("  type: ", attr(x, 'gtype'), "\n")
  cat("  no. features: ", attr(x, 'no_feats'), "\n")
  cat("  features (1st 5): ", attr(x, 'five_feats'), "\n")
}

# helpers ---------
as_featurecollection <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "FeatureCollection") {
    x
  } else {
    sprintf('{ "type": "FeatureCollection", "features": %s }', x)
  }
}
