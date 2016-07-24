context("point")

# spaces
stt <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
aa <- point(stt)

# minified
stt <- '{"type":"Point","coordinates":[1,2]}'
bb <- point(stt)

test_that("point object structure is correct", {
  expect_is(aa, "point")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "Point")
  expect_match(aa[[1]], "coordinates")

  expect_is(bb, "point")
  expect_is(bb[[1]], "character")
  expect_match(bb[[1]], "type")
  expect_match(bb[[1]], "Point")
  expect_match(bb[[1]], "coordinates")
})

test_that("methods on points work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(100, 0, 100, 0))
  expect_equal(geo_type(aa), "Point")

  geo_write(aa, f <- tempfile())
  expect_match(f, "/var/folders")

  # cleanup
  unlink(f)
})

test_that("point fails well", {
  expect_error(point('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(point('{"type": "Point"}'), "keys not correct")

  expect_error(point('{"type": "Point", "coordinates"}'),
               "Objects must consist of key:value pairs")

  expect_error(point('{"type": "Point", "coordinates": []}'),
               "object not proper GeoJSON")

  expect_error(point('{"type": "Point", "coordinates": [1,]}'),
               "Expected another array element")

  expect_error(point('{"type": "Point", "coordinates": [1,s]}'),
               "Invalid numeric literal")
})
