context("ndgeo_write")

file <- system.file("examples", 'featurecollection2.geojson',
  package = "geojson")
str <- paste0(readLines(file), collapse = " ")
x <- featurecollection(str)

test_that("ndgeo_write", {
  outfile <- tempfile(fileext = ".geojson")
  aa <- ndgeo_write(x, outfile)
  fconn <- file(outfile)
  bb <- readLines(outfile)

  expect_null(aa)
  expect_true(grepl("FeatureCollection", str))
  expect_false(any(grepl("FeatureCollection", bb)))
  expect_equal(length(str), 1)
  expect_equal(length(bb), 3)

  close(fconn)
  unlink(outfile)
})

test_that("ndgeo_write fails well", {
  expect_error(ndgeo_write(), "argument \"x\" is missing")
  expect_error(ndgeo_write(5), "no 'ndgeo_write' method for numeric")
  expect_error(ndgeo_write(x, 5), "is not TRUE")
  z <- tempfile()
  expect_error(ndgeo_write(x, z, 5), "invalid 'sep' argument")
  unlink(z)
})



context("ndgeo_read")

test_that("ndgeo_read: from file", {
  file <- system.file("examples", 'ndgeojson1.json', package = "geojson")
  aa <- ndgeo_read(file, verbose = FALSE)

  expect_is(aa, "geojson")
  expect_is(unclass(aa), "character")
  expect_true(nzchar(aa))
  expect_match(aa, "FeatureCollection")
  expect_match(aa, "features")
  expect_match(aa, "coordinates")
  expect_equal(length(aa), 1)
})

test_that("ndgeo_read: from url", {
  url <- "https://storage.googleapis.com/osm-extracts.interline.io/honolulu_hawaii.geojsonl"
  aa <- ndgeo_read(url, verbose = FALSE)

  expect_is(aa, "geojson")
  expect_is(unclass(aa), "character")
  expect_true(nzchar(aa))
  expect_true(grepl("FeatureCollection", aa))
  expect_true(grepl("features", aa))
  expect_true(grepl("coordinates", aa))
  expect_equal(length(aa), 1)
})

test_that("ndgeo_read fails well", {
  expect_error(ndgeo_read(), "argument \"txt\" is missing")
  expect_error(ndgeo_read(5), "'txt' must be a string, URL or file.")
  expect_error(ndgeo_read('x', 'x'), "Argument 'con' must be a connection")
  z <- tempfile()
  expect_error(ndgeo_read(file(z), 'x'), "is not TRUE")
  unlink(z)
})

