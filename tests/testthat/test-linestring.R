context("linestring")

stt <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
aa <- linestring(stt)

test_that("linestring object structure is correct", {
  expect_is(aa, "geolinestring")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "LineString")
  expect_match(aa[[1]], "coordinates")
})

test_that("methods on linestrings work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(100, 0, 101, 1))
  expect_equal(geo_type(aa), "LineString")

  geo_write(aa, f <- tempfile())
  expect_is(f, "character")

  # cleanup
  unlink(f)
})

test_that("print method for multipolygon", {
  expect_output(print(aa), "<LineString>")
  expect_output(print(aa), "coordinates:")
})

test_that("empty linestring object works", {
  expect_is(linestring('{"type": "LineString", "coordinates": [[],[]] }'),
            "geolinestring")
})

test_that("linestring fails well", {
  expect_error(linestring('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(linestring('{"type": "LineString"}'), "keys not correct")

  expect_error(linestring('{"type": "LineString", "coordinates"}'),
               "object key and value must be separated by a colon")

  expect_error(linestring('{"type": "LineString", "coordinates": [1,s]}'),
               "invalid char in json text")

  expect_error(linestring(5), "no method for numeric")
})

test_that("linestring fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE))

  expect_error(linestring('{"type": "LineString", "coordinates": []}'),
            "a line needs to have two or more coordinates to be valid")

  expect_error(linestring('{"type": "LineString", "coordinates": [1]}'),
               "a line needs to have two or more coordinates to be valid")
})

invisible(linting_opts())
