context("multipoint")

# spaces
stt <- '{"type":"MultiPoint","coordinates":[[100.0,0.0],[101.0,1.0]]}'
aa <- multipoint(stt)

stt <- '{"type":"MultiPoint","coordinates":[[100.0,0.0],[101.0,1.0],[56.45,4.56]]}'
bb <- multipoint(stt)

test_that("multipoint object structure is correct", {
  expect_is(aa, "multipoint")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "MultiPoint")
  expect_match(aa[[1]], "coordinates")

  expect_is(bb, "multipoint")
  expect_is(bb[[1]], "character")
  expect_match(bb[[1]], "type")
  expect_match(bb[[1]], "MultiPoint")
  expect_match(bb[[1]], "coordinates")
})

test_that("methods on multipoints work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(100, 0, 101, 1))
  expect_equal(geo_type(aa), "MultiPoint")

  geo_write(aa, f <- tempfile())
  expect_match(f, "/var/folders")

  # cleanup
  unlink(f)
})

test_that("multipoint fails well", {
  expect_error(multipoint('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(multipoint('{"type": "MultiPoint"}'), "keys not correct")

  expect_error(multipoint('{"type": "MultiPoint", "coordinates"}'),
               "Objects must consist of key:value pairs")

  expect_is(multipoint('{"type": "MultiPoint", "coordinates": []}'), "multipoint")

  expect_error(multipoint('{"type": "MultiPoint", "coordinates": [1]}'),
               "object not proper GeoJSON")

  expect_error(multipoint('{"type": "MultiPoint", "coordinates": [1,s]}'),
               "Invalid numeric literal")
})
