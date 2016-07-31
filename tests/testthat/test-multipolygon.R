context("multipolygon")

# spaces
stt <- '{ "type": "MultiPolygon",
"coordinates": [
  [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
  [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
  [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
  ]
}'
aa <- multipolygon(stt)

# minified
stt <- '{"type":"MultiPolygon","coordinates":[[[[102.0,2.0],[103.0,2.0],[103.0,3.0],[102.0,3.0],[102.0,2.0]]],[[[100.0,0.0],[101.0,0.0],[101.0,1.0],[100.0,1.0],[100.0,0.0]],[[100.2,0.2],[100.8,0.2],[100.8,0.8],[100.2,0.8],[100.2,0.2]]]]}'
bb <- multipolygon(stt)

test_that("multipolygon object structure is correct", {
  expect_is(aa, "multipolygon")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "MultiPolygon")
  expect_match(aa[[1]], "coordinates")

  expect_is(bb, "multipolygon")
  expect_is(bb[[1]], "character")
  expect_match(bb[[1]], "type")
  expect_match(bb[[1]], "MultiPolygon")
  expect_match(bb[[1]], "coordinates")
})

test_that("methods on multipolygons work", {
  expect_is(geo_bbox(aa), "numeric")
  expect_equal(geo_bbox(aa), c(2, 2, 102, 103))
  expect_equal(geo_type(aa), "MultiPolygon")

  geo_write(aa, f <- tempfile())
  expect_match(f, "/var/folders")

  # cleanup
  unlink(f)
})

test_that("empty linestring object works", {
  expect_is(multipolygon('{"type": "MultiPolygon", "coordinates": []}'),
            "multipolygon")
})

test_that("multipolygon fails well", {
  expect_error(multipolygon('{"type": "FooBar"}'), "type can not be 'FooBar'")

  expect_error(multipolygon('{"type": "MultiPolygon"}'), "keys not correct")

  expect_error(multipolygon('{"type": "MultiPolygon", "coordinates"}'),
               "Objects must consist of key:value pairs")

  expect_error(multipolygon('{"type": "MultiPolygon", "coordinates": [1,]}'),
               "Expected another array element")

  expect_error(
    multipolygon('{"type": "MultiPolygon", "coordinates": [
	[[[100.0, 0.0], [101.0, 0.0], [100.0, 0.0]],
                 [[100.2, 0.2], [100.8, 0.2], [100.2, 0.2]]]
                 ]'),
               "Unfinished JSON term at EOF at line 4")

  expect_error(
    multipolygon('{"type": "MultiPolygon", "coordinates": [
                 [[[100.0, 0.0], [101.0, 0.0], [100.0, aa]],
                 [[100.2, 0.2], [100.8, 0.2], [100.2, 0.2]]]
                 ]'),
    "Invalid numeric literal")
})
