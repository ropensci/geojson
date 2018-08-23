.onLoad <- function(libname, pkgname) {
  linting_opts()

  if (requireNamespace('sf', quietly = TRUE)) {
    setMethod("as.geojson", "sf", function(x) {
      as.geojson(sf::as_Spatial(x))
    })
  }
}
