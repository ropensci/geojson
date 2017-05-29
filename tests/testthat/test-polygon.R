context("polygon")

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

  geo_write(aa, f <- tempfile())
  expect_is(f, "character")

  # cleanup
  unlink(f)
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
})

test_that("polygon fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE))

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

test_that("despite masking, we get the old polygon behaviour as well", {
  m <- matrix(c(0, 0.5, 1, 0, 1, 0), ncol = 2); plot(m, type = "n", asp = 1);

  expect_silent(polygon(m, border = "firebrick"))
  expect_silent(polygon(list(x = m[,1], y = m[, 2])))
  expect_silent(polygon(as.data.frame(m)))
  ## list must be named, though data.frame doesn't need them
  expect_error(polygon(list(m[,1], m[, 2])), "no method for list")
})