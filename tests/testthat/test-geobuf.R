context("geobuf methods")

testpb <- system.file("examples/test.pb", package = "geojson")
lineone <- system.file("examples/linestring_one.geojson", package = "geojson")

test_that("from_geobuf - from file path", {
  aa <- from_geobuf(testpb)
  bb <- from_geobuf(testpb, pretty = TRUE)

  expect_is(aa, "json")
  expect_equal(length(aa), 1)
  expect_false(grepl("\n", aa))
  expect_match(aa, "FeatureCollection")
  #expect_equal_to_reference(aa, "test.rds")

  expect_is(bb, "json")
  expect_equal(length(bb), 1)
  expect_match(bb, "\n")
})

test_that("from_geobuf - from raw bytes", {
  bytes <- readBin(testpb, raw(), file.info(testpb)$size)
  aa <- from_geobuf(bytes)

  expect_is(aa, "json")
  expect_equal(length(aa), 1)
  expect_false(grepl("\n", aa))
  expect_match(aa, "FeatureCollection")
  #expect_equal_to_reference(aa, "test.rds")
})



test_that("to_geobuf - from json", {
  aa <- to_geobuf(lineone)

  expect_is(aa, "raw")
  expect_equal(length(aa), 155)
  expect_equal_to_reference(aa, "linestring_one.rds")
})

test_that("to_geobuf - from character", {
  ## file
  aa <- to_geobuf(lineone)

  expect_is(aa, "raw")
  expect_equal(length(aa), 155)
  expect_equal_to_reference(aa, "linestring_one.rds")

  ## JSON as character string
  json <- paste(readLines(lineone), collapse = "")
  aa <- to_geobuf(json)

  expect_is(aa, "raw")
  expect_equal(length(aa), 155)
  expect_equal_to_reference(aa, "linestring_one.rds")
})

# cleanup
close(file(testpb))
close(file(lineone))

test_that("to_geobuf - from geopolygon", {
  x <- '{ "type": "Polygon",
     "coordinates": [
       [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
     ]
   }'
  y <- polygon(x)
  aa <- to_geobuf(y)

  expect_is(aa, "raw")
  expect_equal(length(aa), 32)
  expect_equal_to_reference(aa, "polygon.rds")
})

test_that("to_geobuf - from geomultipoint", {
  x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
  y <- multipoint(x)
  aa <- to_geobuf(y)

  expect_is(aa, "raw")
  expect_equal(length(aa), 23)
  expect_equal_to_reference(aa, "multipoint.rds")
})



test_that("from_geobuf fails well", {
  expect_error(from_geobuf(), "argument \"x\" is missing")
  expect_error(from_geobuf(list()), "no 'from_geobuf' method for list")
  expect_error(from_geobuf("adfasdf"), "adfasdf does not exist")
  expect_error(from_geobuf(raw()), "No 'data_type' field set")
})

test_that("to_geobuf fails well", {
  expect_error(to_geobuf(), "argument \"x\" is missing")
  expect_error(to_geobuf(list()), "no 'to_geobuf' method for list")
  expect_error(to_geobuf("adfasdf"), "jsonlite::validate\\(json\\) is not TRUE")
})
