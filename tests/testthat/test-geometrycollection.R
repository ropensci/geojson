context("geometrycollection")



x <- '{
 "type": "GeometryCollection",
 "geometries": [
   {
     "type": "Point",
     "coordinates": [100.0, 0.0]
   },
   {
     "type": "LineString",
     "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
   }
  ]
}'
aa <- geometrycollection(x)

test_that("geometrycollection object structure is correct", {
  expect_is(aa, "geogeometrycollection")
  expect_is(unclass(aa)[1], "character")
  expect_match(unclass(aa)[1], "type")
  expect_match(unclass(aa)[1], "GeometryCollection")
  expect_match(unclass(aa)[1], "coordinates")
})

test_that("geometrycollection: character class input", {
  file <- system.file("examples", "geometrycollection1.geojson",
    package = "geojson")
  txt <- paste0(readLines(file), collapse="")
  aa <- geometrycollection(txt)

  expect_is(aa, "geogeometrycollection")
  expect_is(unclass(aa)[1], "character")
  expect_match(unclass(aa)[1], "type")
  expect_match(unclass(aa)[1], "GeometryCollection")
  expect_match(unclass(aa)[1], "coordinates")
})

test_that("geometrycollection: self input", {
  expect_equal(geometrycollection(aa), aa)
})

test_that("methods on geometrycollections work", {
  expect_equal(geo_type(aa), "GeometryCollection")

  expect_match(geo_pretty(aa), "\n")

  f <- file(tempfile())
  geo_write(aa, f)
  expect_is(f, "file")
})

test_that("empty geometrycollection object works", {
  expect_is(geometrycollection('{"type":"GeometryCollection","geometries":[]}'),
            "geogeometrycollection")
  expect_is(geometrycollection('{"type":"GeometryCollection","geometries":[{}]}'),
               "geogeometrycollection")
  expect_is(geometrycollection('{"type":"GeometryCollection","geometries":[{},{}]}'),
            "geogeometrycollection")
})

test_that("geometrycollection fails well", {
  expect_error(geometrycollection('{"type": "GeometryCollection", "geometries"}'),
               "object key and value must be separated by a colon")
  expect_error(geometrycollection('{"type": "GeometryCollection", "geometries": [1,s]}'),
               "invalid char in json text")

  expect_error(geo_bbox(aa), "no 'geo_bbox' method for geogeometrycollection")
  expect_error(geometrycollection(5), "no method for numeric")
})

