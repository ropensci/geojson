context("geojson_validate")

test_that("geojson_validate works with character inputs", {
  a <- geojson_validate('{"type": "FooBar"}')
  expect_is(a, "logical")
  expect_equal(a, FALSE)
  
  # listid
  expect_equal(geojson_validate('{"type": "Point", "coordinates": [-80,40]}'), TRUE)
  
  # invalid
  expect_equal(geojson_validate('{ "type": "FeatureCollection" }'), FALSE)
  expect_equal(geojson_validate('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'), FALSE)
})

test_that("geojson_validate works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
  d <- geojson_validate(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "logical")
  expect_equal(d, TRUE)
})

test_that("geojson_validate works with url inputs", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- geojson_validate(as.location(url))
  expect_is(as.location(url), "location")
  expect_is(e, "logical")
  expect_equal(e, TRUE)
})

test_that("geojson_validate works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  f <- geojson_validate(x)
  expect_is(x, "json")
  expect_is(f, "logical")
  expect_equal(f, FALSE)
})
