context("geojson_lint")

test_that("geojson_lint works with character inputs", {
  a <- geojson_lint('{"type": "FooBar"}')
  expect_is(a, "logical")
  expect_false(a)

  # valid
  expect_true(geojson_lint('{"type": "Point", "coordinates": [-80,40]}'))

  # invalid
  expect_false(geojson_lint('{ "type": "FeatureCollection" }'))
  expect_false(geojson_lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'))
})

test_that("geojson_lint works when verbose output", {
  a <- geojson_lint('{"type": "FooBar"}', verbose = TRUE)
  expect_false(a)
  expect_is(a, "logical")
  expect_named(attributes(a), "errors")
  expect_named(sort(attr(a, "errors")), c('message', 'status'))
  expect_equal(attr(a, "errors")$message, "\"FooBar\" is not a valid GeoJSON type.")
  
  # valid - returns only a boolean because valid
  expect_true(geojson_lint('{"type": "Point", "coordinates": [-80,40]}', verbose = TRUE))
  
  # invalid - returns attributes with error reason because not valid
  bb <- geojson_lint('{ "type": "FeatureCollection" }', verbose = TRUE)
  expect_is(bb, "logical")
  expect_is(attributes(bb)[[1]], "data.frame")
  
  cc <- geojson_lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}', verbose = TRUE)
  expect_is(cc, "logical")
  expect_is(attributes(cc)[[1]], "data.frame")
})

test_that("geojson_lint works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
  d <- geojson_lint(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "logical")
})

test_that("geojson_lint works with url inputs", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- geojson_lint(as.location(url))
  expect_is(as.location(url), "location")
  expect_is(e, "logical")
})

test_that("geojson_lint works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  expect_is(x, "json")
  
  # without verbose
  f <- geojson_lint(x)
  expect_is(f, "logical")
  expect_null(attributes(f))
  
  # with verbose
  g <- geojson_lint(x, verbose = TRUE)
  expect_is(g, "logical")
  expect_equal(attr(g, "errors")$message, "A FeatureCollection must have a \"features\" property.")
})
