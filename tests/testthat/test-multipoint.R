context("multipoint")

invisible(linting_opts(suppress_pkgcheck_warnings = TRUE))

# spaces
stt <- '{"type":"MultiPoint","coordinates":[[100.0,0.0],[101.0,1.0]]}'
aa <- multipoint(stt)

stt <- '{"type":"MultiPoint","coordinates":[[100.0,0.0],[101.0,1.0],[56.45,4.56]]}'
bb <- multipoint(stt)

test_that("multipoint object structure is correct", {
  expect_is(aa, "geomultipoint")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "MultiPoint")
  expect_match(aa[[1]], "coordinates")

  expect_is(bb, "geomultipoint")
  expect_is(bb[[1]], "character")
  expect_match(bb[[1]], "type")
  expect_match(bb[[1]], "MultiPoint")
  expect_match(bb[[1]], "coordinates")
})

test_that("methods on multipoints work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(100, 0, 101, 1))
  expect_equal(geo_type(aa), "MultiPoint")

  f <- file(tempfile())
  geo_write(aa, f)
  expect_is(f, "file")
})

test_that("print method for multipoint", {
  expect_output(print(aa), "<MultiPoint>")
  expect_output(print(aa), "coordinates:")
})

test_that("multipoint fails well", {
  expect_error(multipoint('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(multipoint('{"type": "MultiPoint"}'), "keys not correct")

  expect_error(multipoint('{"type": "MultiPoint", "coordinates"}'),
               "object key and value must be separated by a colon")

  expect_is(multipoint('{"type": "MultiPoint", "coordinates": []}'), "geomultipoint")

  expect_error(multipoint('{"type": "MultiPoint", "coordinates": [1,s]}'),
               "invalid char in json text")

  expect_error(multipoint(5), "no method for numeric")
})

test_that("multipoint fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE))

  skip_if_not_installed("geojsonlint")

  expect_error(multipoint('{"type": "MultiPoint", "coordinates": [1]}'),
               "position should be an array, is a number instead")

  expect_error(multipoint('{"type": "MultiFart", "coordinates": []}'),
               "The type MultiFart is unknown")
})

invisible(linting_opts())
