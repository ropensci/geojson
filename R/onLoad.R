.onLoad <- function(libname, pkgname) { # nocov start

  if (requireNamespace("sf", quietly = TRUE)) {
    setMethod("as.geojson", "sf", function(x) {
      as.geojson(sf::as_Spatial(x))
    })
  }
} # nocov end
