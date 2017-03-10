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

verify_names <- function(x, nms) UseMethod("verify_names")
verify_names.default <- function(x, nms) stop("no 'verify_names' method for ",
                                              class(x))
verify_names.character <- function(x, nms) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    keys <- strsplit(
      asc(unclass(jqr::jq(unclass(x), ".geometry | keys"))), ",")[[1]]
  } else {
    keys <- strsplit(asc(unclass(jqr::jq(unclass(x), "keys"))), ",")[[1]]
  }
  if (!all(nms %in% keys)) stop("keys not correct", call. = FALSE)
}
verify_names.list <- function(x, nms) {
  if (unclass(x)[["type"]] == "Feature") {
    keys <- names(unclass(x)[["geometry"]])
  } else {
    keys <- names(unclass(x))
  }
  if (!all(nms %in% keys)) stop("keys not correct", call. = FALSE)
}


verify_class_ <- function(x, clss) UseMethod("verify_class_")
verify_class_.default <- function(x, clss) stop("no 'verify_class_' method for ",
                                              class(x))
verify_class_.character <- function(x, clss) {
  if (asc(jqr::jq(unclass(x), ".type")) != clss) {
    stop("object is not of type ", clss, call. = FALSE)
  }
}
verify_class_.list <- function(x, clss) {
  if (unclass(x)[["type"]] != clss) {
    stop("object is not of type ", clss, call. = FALSE)
  }
}

verify_class <- function(x, clss) UseMethod("verify_class")
verify_class.default <- function(x, clss) stop("no 'verify_class' method for ",
                                                class(x))
verify_class.character <- function(x, clss) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    cl <- cchar(jqr::jq(unclass(x), ".geometry.type"))
  } else {
    cl <- cchar(jqr::jq(unclass(x), ".type"))
  }
  if (cl != clss) stop("object is not of type ", clss, call. = FALSE)
}
verify_class.list <- function(x, clss) {
  if (unclass(x)[["type"]] == "Feature") {
    cl <- unclass(x)[["geometry"]][["type"]]
  } else {
    cl <- unclass(x)[["type"]]
  }
  if (cl != clss) stop("object is not of type ", clss, call. = FALSE)
}


checkforpkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    warning(sprintf("'%s' not installed, skipping GeoJSON linting", x),
            call. = FALSE)
    invisible(FALSE)
  } else {
    invisible(TRUE)
  }
}

cchar <- function(x) {
  gsub("\"", "", as.character(x))
}

asc <- function(x) gsub("\\\"|\\[|\\]", "", as.character(x))

is_feature <- function(x) {
  cchar(jqr::jq(unclass(x), ".type")) == "Feature"
}

get_coordinates <- function(x) UseMethod("get_coordinates")
get_coordinates.default <- function(x, clss) {
  stop("no 'get_coordinates' method for ", class(x))
}
get_coordinates.character <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    x <- cchar(jqr::jq(unclass(x), ".geometry.coordinates"))
  } else {
    x <- cchar(jqr::jq(unclass(x), ".coordinates"))
  }
  paste0(substring(x, 1, 70), if (nchar(x) > 70) " ..." else "" )
}
get_coordinates.list <- function(x) {
  if (unclass(x)[["type"]] == "Feature") {
    x <- unclass(x)[["geometry"]][["coordinates"]]
  } else {
    x <- unclass(x)[["coordinates"]]
  }
  x <- coords2str(x)
  paste0(substring(x, 1, 70), if (nchar(x) > 70) " ..." else "" )
}

get_each_nodes <- function(x) UseMethod("get_each_nodes")
get_each_nodes.default <- function(x) {
  stop("no 'get_each_nodes' method for ", class(x))
}
get_each_nodes.character <- function(x) {
  z <- asc(jqr::jq(x, ".coordinates[] | length "))
  z <- z[1:min(c(10, length(z)))]
  paste0(z, collapse = ", ")
}
get_each_nodes.list <- function(x) {
  z <- vapply(x[["coordinates"]], NROW, 1)
  z <- z[1:min(c(10, length(z)))]
  paste0(z, collapse = ", ")
}

stex <- function(str, pattern) regmatches(str, gregexpr(pattern, str))[[1]]

as_x <- function(x, clz) UseMethod("as_x")
as_x.default <- function(x, clz) stop("no 'as_x' method for ", class(x))
as_x.character <- function(x, clz) {
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
as_x.list <- function(x, clz) {
  ext <- unclass(x)[["type"]]
  if (ext == "Feature") {
    unclass(x)[["geometry"]]
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

toit <- function(x) sprintf("[%s]", x)

#' coords2str
#' @export
#' @keywords internal
coords2str <- function(x) UseMethod("coords2str")
#' @export
coords2str.default <- function(x) stop("no 'coords2str' method for ", class(x))
#' @export
coords2str.matrix <- function(x) {
  toit(paste0(
    apply(x, 1, function(z) sprintf("[%s]", paste0(z, collapse = ","))),
    collapse = ", "
  ))
}
#' @export
coords2str.list <- function(x) {
  toit(paste0(lapply(x, coords2str), collapse = ", "))
}
