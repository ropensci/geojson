context("polygon")

invisible(linting_opts(suppress_pkgcheck_warnings = TRUE))

# spaces
stt <- '{ "type": "Polygon",
  "coordinates": [
  [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
  ]
}'
aa <- polygon(stt)

# minified
stt <- '{"type":"Polygon","coordinates":[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]]]}'
bb <- polygon(stt)

test_that("polygon object structure is correct", {
  expect_is(aa, "geopolygon")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "Polygon")
  expect_match(aa[[1]], "coordinates")

  expect_is(bb, "geopolygon")
  expect_is(bb[[1]], "character")
  expect_match(bb[[1]], "type")
  expect_match(bb[[1]], "Polygon")
  expect_match(bb[[1]], "coordinates")
})

test_that("methods on polygons work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(100, 0, 101, 1))
  expect_equal(geo_type(aa), "Polygon")

  f <- file(tempfile())
  geo_write(aa, f)
  expect_is(f, "file")
})

test_that("print method for polygon", {
  expect_output(print(aa), "<Polygon>")
  expect_output(print(aa), "no. lines")
  expect_output(print(aa), "no. holes")
  expect_output(print(aa), "no. nodes / line:")
  expect_output(print(aa), "coordinates:")
})

test_that("polygon fails well", {
  expect_error(polygon('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(polygon('{"type": "Polygon"}'), "keys not correct")

  expect_error(polygon('{"type": "Polygon", "coordinates"}'),
               "object key and value must be separated by a colon")

  expect_is(polygon('{"type": "Polygon", "coordinates": []}'), "geopolygon")

  expect_error(polygon('{"type": "Polygon", "coordinates": [1,]}'),
               "unallowed token at this point in JSON text")

  expect_error(polygon('{"type": "Polygon", "coordinates": [[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,aa]]]}'),
               "invalid char in json text")

  expect_error(polygon(5), "no method for numeric")
})

test_that("polygon fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE, TRUE))

  skip_if_not_installed("geojsonlint")

  expect_error(polygon('{"type": "Polygon", "coordinates": [[100.0,0.0],[101.0,0.0]]}'),
               "a number was found where a coordinate array should have been found")

  expect_error(polygon('{"type": "Polygon", "coordinates": [[]]}'),
               "a number was found where a coordinate array should")

  expect_error(polygon('{"type": "Polygon", "coordinates": [[1]]}'),
               "a number was found where a coordinate array should")

  expect_error(polygon('{"type": "polygon", "coordinates": [[]]}'),
               "Expected Polygon")
})

invisible(linting_opts())
