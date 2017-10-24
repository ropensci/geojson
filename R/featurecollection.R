#' featurecollection class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geofeaturecollection and either geojson
#' (string input), or geo_list (list input)
#' @examples
#' file <- system.file("examples", 'featurecollection1.geojson',
#'   package = "geojson")
#' file <- system.file("examples", 'featurecollection2.geojson',
#'   package = "geojson")
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
#'
#' # features to featurecollection
#' w <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' point(w) %>% feature() %>% featurecollection()
#'
#' ## all points
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' y <- '{ "type": "Point", "coordinates": [100.0, 50.0] }'
#' featls <- lapply(list(x, y), function(z) feature(point(z)))
#' featurecollection(featls)
#'
#' ## mixed geometry types
#' # FIXME - give examples
#'
#' # from a list
#' x <- list(type = "LineString")
#' lngs <- c(-131.5, -123.4, -124.5, -118.8, -122, -114.6, -108.3, -105.8,
#'   -105.1, -97.7, -96.3, -92.1, -90.7, -85.8, -84, -78, -69.6, -83.7, -90.4,
#'   -93.9, -100.9, -97.7, -117.8, -124.8, -132.9)
#' lats <- c(60.9, 60.4, 56.8, 55.4, 50.1, 51.4, 57.1, 55.2, 51.8, 55.6, 51.6,
#'   54, 50.7, 51.2, 48.9, 49.2, 55.2, 53.5, 56.4, 59.4, 63.9, 66.8, 65.9,
#'   70.5, 69.3)
#' x$coordinates <- matrix(c(lngs, lats), ncol = 2, byrow = FALSE)
#' linestring(x) %>% feature() %>% featurecollection()
#' ## many into one FeatureCollection
#' tt <- lapply(replicate(10, linestring(x), simplify = FALSE), feature) %>%
#'   featurecollection()
#' jsonlite::toJSON(unclass(tt), auto_unbox = TRUE, pretty = TRUE)
featurecollection <- function(x) {
  UseMethod("featurecollection")
}

#' @export
featurecollection.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
featurecollection.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_featurecollection(x)
  verify_class_(x, "FeatureCollection")
  switch_verify_names(x)
  gtype <- get_type(x)
  no_feats <- asc(jqr::jq(unclass(x), ".features | length"))
  five_feats <- paste0(
    sub_n(asc(
      jqr::jq(unclass(x), ".features[].geometry.type"))),
    collapse = ", "
  )
  structure(x, class = c("geofeaturecollection", "geojson"),
            type = gtype,
            no_features = no_feats,
            five_feats = five_feats)
}

#' @export
featurecollection.geo_list <- function(x) {
  #hint_geojson(x)
  x <- unclass(x)
  x <- as_featurecollection(x)
  verify_class_.list(x, "FeatureCollection")
  switch_verify_names(x)
  gtype <- get_type(x)
  no_feats <- length(x[["features"]])
  five_feats <- paste0(
        vapply(x$features, "[[", "", c("geometry", "type")), collapse = ", ")
  structure(x, class = c("geofeaturecollection", "geo_list"),
            type = gtype,
            no_features = no_feats,
            five_feats = five_feats)
}

#' @export
featurecollection.geofeature <- function(x) {
  if (inherits(x, "geo_list")) {
    class(x) <- "geo_list"
    return(featurecollection.geo_list(x))
  }
  featurecollection(as_featurecollection(unclass(x)[1]))
}

#' @export
featurecollection.list <- function(x) {
  invisible(lapply(x, is.feature))
  if (
    all(vapply(x, function(z) inherits(z, "geofeature"), TRUE)) &&
    all(vapply(x, function(z) {
      !any(c('geojson', 'json', 'character') %in% class(z))
    }, TRUE))
  ) {
    tmp <- list(type = "FeatureCollection", features = lapply(x, unclass))
    verify_class_.list(tmp, "FeatureCollection")
    switch_verify_names(tmp)
    gtype <- get_type(tmp)
    no_feats <- length(tmp[["features"]])
    five_feats <- paste0(
      vapply(tmp$features, "[[", "", c("geometry", "type")), collapse = ", ")
    res <- structure(tmp, class = c("geofeaturecollection", "geo_list"),
              type = gtype,
              no_features = no_feats,
              five_feats = five_feats)
    return(res)
  }
  featurecollection(as_featurecollection(lapply(x, function(z) unclass(z)[1])))
}

#' @export
print.geofeaturecollection <- function(x, ...) {
  cat("<FeatureCollection>", "\n")
  cat("  type: ", attr(x, 'type'), "\n")
  cat("  no. features: ", attr(x, 'no_features'), "\n")
  cat("  features (1st 5): ", attr(x, 'five_feats'), "\n")
}

as_featurecollection <- function(x) UseMethod("as_featurecollection")
as_featurecollection.character <- function(x) {
  xchar <- as.character(unclass(x))
  if (
    all(vapply(xchar, function(z) {
      asc(jqr::jq(z, ".type")) == "FeatureCollection"
    }, logical(1)))
  ) {
    return(x)
  } else {
    sprintf(
      '{ "type": "FeatureCollection", "features": [%s] }',
      if (length(x) > 1) {
        paste0(x, collapse = ", ")
      } else {
        x
      }
    )
  }
}
as_featurecollection.geo_list <- function(x) {
  if (inherits(x[[1]], "character") && is.null(names(x))) {
    return(
      as_featurecollection.character(unlist(x))
    )
  }

  xx <- unclass(x)
  if (xx[["type"]] == "FeatureCollection") {
    x
  } else {
    list(type = "FeatureCollection", features = list(xx))
  }
}
as_featurecollection.list <- as_featurecollection.geo_list
