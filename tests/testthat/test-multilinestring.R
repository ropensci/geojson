context("multilinestring")

stt <- '{ "type": "MultiLineString",
    "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
aa <- multilinestring(stt)

#' file <- system.file("examples", 'multilinestring_one.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- multilinestring(str))

test_that("multilinestring object structure is correct", {
  expect_is(aa, "geomultilinestring")
  # expect_is(aa[1], "geomultilinestring")
  # expect_is(aa[[1]], "geomultilinestring")
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
  expect_is(f, "character")

  # cleanup
  unlink(f)
})

test_that("print method for multilinestring", {
  expect_output(print(aa), "<MultiLineString>")
  expect_output(print(aa), "no. lines")
  expect_output(print(aa), "no. nodes / line:")
  expect_output(print(aa), "coordinates:")
})

test_that("empty multilinestring object works", {
  expect_is(multilinestring('{"type": "MultiLineString", "coordinates": [ [ [],[] ] ] }'),
            "geomultilinestring")

  expect_is(multilinestring('{"type": "MultiLineString", "coordinates": []}'),
               "geomultilinestring")

  expect_is(multilinestring('{"type": "MultiLineString", "coordinates": [1]}'),
            "geomultilinestring")

  expect_error(multilinestring(5), "no method for numeric")
})

test_that("multilinestring fails well", {
  expect_error(multilinestring('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(multilinestring('{"type": "MultiLineString"}'), "keys not correct")

  expect_error(multilinestring('{"type": "MultiLineString", "coordinates"}'),
               "object key and value must be separated by a colon")

  expect_error(multilinestring('{"type": "MultiLineString", "coordinates": [1,s]}'),
               "invalid char in json text")
})

test_that("multilinestring fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE))

  expect_error(multilinestring('{"type": "MultiLineString", "coordinates": [[]]}'),
               "a line needs to have two or more coordinates to be valid")
})

invisible(linting_opts())
