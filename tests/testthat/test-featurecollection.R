context("featurecollection")

invisible(linting_opts(suppress_pkgcheck_warnings = TRUE))

file <- system.file("examples", "featurecollection2.geojson",
  package = "geojson")
str <- paste0(readLines(file), collapse = " ")
aa <- featurecollection(str)

test_that("featurecollection object structure is correct", {
  expect_is(aa, "geofeaturecollection")
  expect_is(unclass(aa)[1], "character")
  expect_match(unclass(aa)[1], "type")
  expect_match(unclass(aa)[1], "FeatureCollection")
  expect_match(unclass(aa)[1], "coordinates")
})

x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
feat <- feature(point(x))

test_that("featurecollection: geofeature class input", {
  expect_is(featurecollection(feat), "geofeaturecollection")
})

test_that("featurecollection: list class input", {
  expect_is(featurecollection(list(feat, feat)), "geofeaturecollection")
})

test_that("methods on featurecollections work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(as.character(geo_bbox(aa)[1]), "-49.277263")
  expect_equal(geo_type(aa), "FeatureCollection")

  f <- file(tempfile())
  geo_write(aa, f)
  expect_is(f, "file")
})

test_that("empty featurecollection object works", {
  expect_is(featurecollection('{"type":"FeatureCollection","features":[]}'),
            "geofeaturecollection")
  expect_is(featurecollection('{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point"}}]}'),
               "geofeaturecollection")
  expect_is(featurecollection('{"type":"FeatureCollection","features":[{"type":"Feature","geometry":{"type":"Point","coordinates":[]}}]}'),
            "geofeaturecollection")
})

test_that("featurecollection fails well", {
  expect_error(featurecollection('{"type": "featurecollection", "coordinates"}'),
               "object key and value must be separated by a colon")
  expect_error(featurecollection('{"type": "featurecollection", "coordinates": [1,s]}'),
               "invalid char in json text")

  expect_error(featurecollection(5), "no method for numeric")
})

test_that("featurecollection fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE, TRUE))

  skip_if_not_installed("geojsonlint")

  expect_error(
    featurecollection('{"type": "featurecollection", "coordinates": [[]]}'),
    "Expected FeatureCollection but got featurecollection")
  expect_error(
    featurecollection('{"type": "FeatureCollection", "coordinates": [[]]}'),
    "FeatureCollection object cannot contain a \"coordinates\" member")
})

invisible(linting_opts())
