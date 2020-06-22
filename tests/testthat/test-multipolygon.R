context("multipolygon")

invisible(linting_opts(suppress_pkgcheck_warnings = TRUE))

# spaces
stt <- '{ "type": "MultiPolygon",
"coordinates": [
  [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
  [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
  [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
  ]
}'
aa <- multipolygon(stt)

# minified
stt <- '{"type":"MultiPolygon","coordinates":[[[[102.0,2.0],[103.0,2.0],[103.0,3.0],[102.0,3.0],[102.0,2.0]]],[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]],[[100.2,0.2],[100.8,0.2],[100.8,0.8],[100.2,0.8],[100.2,0.2]]]]}'
bb <- multipolygon(stt)

test_that("multipolygon object structure is correct", {
  expect_is(aa, "geomultipolygon")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "MultiPolygon")
  expect_match(aa[[1]], "coordinates")

  expect_is(bb, "geomultipolygon")
  expect_is(bb[[1]], "character")
  expect_match(bb[[1]], "type")
  expect_match(bb[[1]], "MultiPolygon")
  expect_match(bb[[1]], "coordinates")
})

test_that("methods on multipolygons work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(2, 2, 102, 103))
  expect_equal(geo_type(aa), "MultiPolygon")

  f <- file(tempfile())
  geo_write(aa, f)
  expect_is(f, "file")
})

test_that("print method for multipolygon", {
  expect_output(print(aa), "<MultiPolygon>")
  expect_output(print(aa), "no. polygons")
  expect_output(print(aa), "coordinates:")
})

test_that("empty linestring object works", {
  expect_is(multipolygon('{"type": "MultiPolygon", "coordinates": []}'),
            "geomultipolygon")
})

test_that("multipolygon fails well", {
  expect_error(multipolygon('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(multipolygon('{"type": "MultiPolygon"}'), "keys not correct")

  expect_error(multipolygon('{"type": "MultiPolygon", "coordinates"}'),
               "object key and value must be separated by a colon")

  expect_error(multipolygon('{"type": "MultiPolygon", "coordinates": [1,]}'),
               "unallowed token at this point in JSON text")

  expect_error(
    multipolygon('{"type": "MultiPolygon", "coordinates": [
	[[[100.0, 0.0], [101.0, 0.0], [100.0, 0.0]],
                 [[100.2, 0.2], [100.8, 0.2], [100.2, 0.2]]]
                 ]'),
               "premature EOF")

  expect_error(
    multipolygon('{"type": "MultiPolygon", "coordinates": [
                 [[[100.0, 0.0], [101.0, 0.0], [100.0, aa]],
                 [[100.2, 0.2], [100.8, 0.2], [100.2, 0.2]]]
                 ]'),
    "invalid char in json text")

  expect_error(multipolygon(5), "no method for numeric")
})

test_that("multipolygon fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE))

  skip_if_not_installed("geojsonlint")

  expect_error(multipolygon('{"type": "MultiPolygon", "coordinates": [1]}'),
               "a number was found where a coordinate array should")

  expect_error(multipolygon('{"type": "Multipolygon", "coordinates": []}'),
               "Expected MultiPolygon")
})

invisible(linting_opts())
