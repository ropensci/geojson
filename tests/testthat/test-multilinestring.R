context("multilinestring")

stt <- '{ "type": "MultiLineString",
    "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
aa <- multilinestring(stt)

#' file <- system.file("examples", 'multilinestring_one.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- multilinestring(str))

test_that("multilinestring object structure is correct", {
  expect_is(aa, "multilinestring")
  expect_is(aa[1], "multilinestring")
  expect_is(aa[[1]], "multilinestring")
  expect_is(unclass(aa)[1], "character")
  expect_match(unclass(aa)[1], "type")
  expect_match(unclass(aa)[1], "MultiLineString")
  expect_match(unclass(aa)[1], "coordinates")
})

test_that("methods on multilinestrings work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(100, 0, 101, 1))
  expect_equal(geo_type(aa), "MultiLineString")

  geo_write(aa, f <- tempfile())
  expect_match(f, "/var/folders")

  # cleanup
  unlink(f)
})

test_that("empty multilinestring object works", {
  expect_is(multilinestring('{"type": "MultiLineString", "coordinates": [ [ [],[] ] ] }'),
            "multilinestring")

  expect_is(multilinestring('{"type": "MultiLineString", "coordinates": []}'),
               "multilinestring")

  expect_is(multilinestring('{"type": "MultiLineString", "coordinates": [1]}'),
            "multilinestring")
})

test_that("linestring fails well", {
  expect_error(multilinestring('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(multilinestring('{"type": "MultiLineString"}'), "keys not correct")

  expect_error(multilinestring('{"type": "MultiLineString", "coordinates"}'),
               "Objects must consist of key:value pairs")

  expect_error(multilinestring('{"type": "MultiLineString", "coordinates": [1,s]}'),
               "Invalid numeric literal")
})
