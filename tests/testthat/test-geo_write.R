context("geo_write")

pt <- point('{ "type": "Point", "coordinates": [100.0, 0.0] }')
poly <- polygon('{ "type": "Polygon", "coordinates": [[ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]]}')

f1 <- tempfile(fileext = ".geojson")
f2 <- tempfile(fileext = ".geojson")

test_that("geo_write works", {
  expect_null(geo_write(pt, file = f1))
  expect_null(geo_write(poly, file = f2))

  expect_is(readLines(f1, warn = FALSE), "character")
  expect_match(paste0(readLines(f1, warn = FALSE), collapse = ""), "Point")
  expect_match(paste0(readLines(f1, warn = FALSE), collapse = ""), "coordinates")

  expect_is(readLines(f2, warn = FALSE), "character")
  expect_match(paste0(readLines(f2, warn = FALSE), collapse = ""), "Polygon")
  expect_match(paste0(readLines(f2, warn = FALSE), collapse = ""), "coordinates")
})

unlink(f1)
unlink(f2)

test_that("geo_write fails well", {
  expect_error(geo_write(pt), "argument \"file\" is missing")

  expect_error(geo_write(5), "no 'geo_write' method for numeric")
  expect_error(geo_write(list()), "no 'geo_write' method for list")
  expect_error(geo_write(mtcars), "no 'geo_write' method for data.frame")
  expect_error(geo_write("ASDfasdf"), "no 'geo_write' method for character")
})