context("feature")

x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
pt <- point(x)
ft_pt <- feature(pt)
x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
mpt <- multipoint(x)
ft_mpt <- feature(mpt)
x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
ls <- linestring(x)
ft_ls <- feature(ls)
x <- '{ "type": "MultiLineString",
 "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
mls <- multilinestring(x)
ft_mls <- feature(mls)
# library('tibble')
# tibble(a = 1:5, b = list(multifeature(x)))

test_that("feature object structure is correct", {
  expect_is(ft_pt, "geofeature")
  expect_is(ft_pt[[1]], "character")
  expect_match(ft_pt[[1]], "type")
  expect_match(ft_pt[[1]], "Feature")
  expect_match(ft_pt[[1]], "Point")
  expect_match(ft_pt[[1]], "coordinates")
})

test_that("methods on feature work", {
  expect_is(geo_bbox(ft_pt), "numeric")
  expect_equal(geo_bbox(ft_pt), c(100, 0, 100, 0))
  expect_equal(geo_type(ft_pt), "Feature")

  geo_write(ft_pt, f <- tempfile())
  expect_is(f, "character")

  # cleanup
  unlink(f)
})

test_that("empty feature object works", {
  expect_is(feature('{"type":"Feature","geometry":{}}'),
            "geofeature")
})

test_that("feature fails well", {
  expect_error(feature('{"type": "FooBar"}'), 
    "type must be one of")

  expect_error(feature('{"type": "LineString"}'), "keys not correct")

  expect_error(feature('{"type": "LineString", "coordinates"}'),
               "object key and value must be separated by a colon")

  expect_error(feature('{"type": "LineString", "coordinates": [1,s]}'),
               "invalid char in json text")
})

test_that("linestring fails well with geojson linting on", {
  invisible(linting_opts(TRUE, method = "hint", error = TRUE))

  expect_error(feature('{"type":"Feature","coordinates":[]}'),
            "Feature object cannot contain a \"coordinates\" member")

  expect_error(feature('{"type":"Feature","properties":{}}'),
               "\"geometry\" member required")

  expect_error(feature('{"type":"Feature","properties":{},"geometry":{}}'),
               "\"type\" member required")

  expect_error(feature('{"type":"Feature","properties":{},"geometry":{"type":"Point"}}'),
               "\"coordinates\" member required")

  expect_error(feature('{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[]}}'),
               "position must have 2 or more elements")

  expect_error(feature('{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[a]}}'),
               "invalid char in json text")
})

invisible(linting_opts())
