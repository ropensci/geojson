context("linestring")

stt <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
aa <- linestring(stt)

test_that("linestring object structure is correct", {
  expect_is(aa, "linestring")
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
  expect_match(f, "/var/folders")

  # cleanup
  unlink(f)
})

test_that("empty linestring object works", {
  expect_is(linestring('{"type": "LineString", "coordinates": [[],[]] }'),
            "linestring")
})

test_that("linestring fails well", {
  expect_error(linestring('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(linestring('{"type": "LineString"}'), "keys not correct")

  expect_error(linestring('{"type": "LineString", "coordinates"}'),
               "Objects must consist of key:value pairs")

  expect_error(linestring('{"type": "LineString", "coordinates": []}'),
            "object not proper GeoJSON")

  expect_error(linestring('{"type": "LineString", "coordinates": [1]}'),
               "object not proper GeoJSON")

  expect_error(linestring('{"type": "LineString", "coordinates": [1,s]}'),
               "Invalid numeric literal")
})
