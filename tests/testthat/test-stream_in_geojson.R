context("stream_in_geojson internal fxn")



test_that("stream_in_geojson", {
  file <- system.file("examples", 'ndgeojson1.json', package = "geojson")
  con <- file(file)
  aa <- stream_in_geojson(con, verbose = FALSE)

  expect_is(aa, "character")
  expect_match(aa, "Feature")
  expect_match(aa, "geometry")
  expect_equal(length(aa), 3)
})

test_that("stream_in_geojson fails well", {
  expect_error(stream_in_geojson(), "argument \"con\" is missing")
  expect_error(stream_in_geojson(5), "Argument 'con' must be a connection")
  z <- file(tempfile())
  w <- file(tempfile())
  expect_error(stream_in_geojson(z, 'foo'), "is not TRUE")
  expect_error(stream_in_geojson(w, verbose = 'foo'),
    "is not TRUE")
  close(z)
  close(w)
})

