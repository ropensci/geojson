geojson_types <- c(
  "FeatureCollection",
  "Feature",
  "Point",
  "MultiPoint",
  "MultiPoint",
  "LineString",
  "MultiLineString",
  "Polygon",
  "MultiPolygon"
)

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

switch_verify_names <- function(x) {
  switch(
    get_type(x),
    FeatureCollection = verify_names(x, c('type', 'features')),
    Feature = verify_names(x, c('type', 'properties', 'geometry')),
    Point = verify_names(x, c('type', 'coordinates')),
    MultiPoint = verify_names(x, c('type', 'coordinates')),
    MultiPoint = verify_names(x, c('type', 'coordinates')),
    LineString = verify_names(x, c('type', 'coordinates')),
    MultiLineString = verify_names(x, c('type', 'coordinates')),
    Polygon = verify_names(x, c('type', 'coordinates')),
    MultiPolygon = verify_names(x, c('type', 'coordinates'))
  )
}

verify_names <- function(x, nms) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    keys <- strsplit(
      asc(unclass(jqr::jq(unclass(x), ".geometry | keys"))), ",")[[1]]
  } else {
    keys <- strsplit(asc(unclass(jqr::jq(unclass(x), "keys"))), ",")[[1]]
  }
  if (!all(nms %in% keys)) stop("keys not correct", call. = FALSE)
}

verify_class_ <- function(x, clss) {
  if (asc(jqr::jq(unclass(x), ".type")) != clss) stop("object is not of type ",
                                                      clss, call. = FALSE)
}

verify_class <- function(x, clss) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    cl <- cchar(jqr::jq(unclass(x), ".geometry.type"))
  } else {
    cl <- cchar(jqr::jq(unclass(x), ".type"))
  }
  if (cl != clss) stop("object is not of type ", clss, call. = FALSE)
}

checkforpkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    if (!getOption("geojson.suppress_pkgcheck_warnings")) {
      warning(sprintf("'%s' not installed, skipping GeoJSON linting", x),
        call. = FALSE)
    }
    invisible(FALSE)
  } else {
    invisible(TRUE)
  }
}

cchar <- function(x) {
  gsub("\"", "", as.character(x))
}

# use stringi if it's installed, else use straight up gsub, dueces
asc <- function(x) {
  if (requireNamespace('stringi')) {
    stringi::stri_replace_all_regex(x, "\\\"|\\[|\\]", "")
  } else {
    gsub("\\\"|\\[|\\]", "", as.character(x))
  }
}

is_feature <- function(x) {
  cchar(jqr::jq(unclass(x), ".type")) == "Feature"
}

get_coordinates <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    x <- cchar(jqr::jq(unclass(x), ".geometry.coordinates"))
  } else if (asc(jqr::jq(unclass(x), ".type")) == "FeatureCollection") {
    #x <- cchar(jqr::jq(unclass(x), ".features"))
    stop("fixme", call. = FALSE)
  } else {
    x <- cchar(jqr::jq(unclass(x), ".coordinates"))
  }
  paste0(substring(x, 1, 70), if (nchar(x) > 70) " ..." else "" )
}

dotprint <- function(x) {
  paste0(substring(x, 1, 70), if (nchar(x) > 70) " ..." else "" )
}

get_each_nodes <- function(x) {
  z <- asc(jqr::jq(x, ".coordinates[] | length "))
  z <- z[1:min(c(10, length(z)))]
  paste0(z, collapse = ", ")
}

stex <- function(str, pattern) regmatches(str, gregexpr(pattern, str))[[1]]

as_x <- function(clz, x) {
  ext <- asc(jqr::jq(unclass(x), ".type"))
  if (ext == "Feature") {
    jqr::jq(unclass(x), ".geometry")
  } else if (ext == clz) {
    x
  } else {
    stop("type can not be '",
         ext, sprintf("'; must be one of '%s' or 'Feature'", clz),
         call. = FALSE)
  }
}

json_val <- function(x) {
  val <- jsonlite::validate(x)
  if (!val) stop(attr(val, "err"), call. = FALSE)
}

sub_n <- function(x, n = 5) {
  to <- min(length(x), n)
  if (to == 0) x else x[1:to]
}
