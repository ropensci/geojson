context("subset-methods")

test_that("subset-methods", {
  expect_is(`[.geomultilinestring`, "function")
  expect_is(`[[.geomultilinestring`, "function")

  x <- '{ "type": "MultiLineString",
    "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
  mls <- multilinestring(x)
  
  expect_is(mls, "geomultilinestring")
  expect_is(mls[[1]], "geomultilinestring")
})

# test_that("subset-methods fail well", {
#   expect_error(is_generator(), "argument \"x\" is missing")
#   expect_error(is.point(), "argument \"x\" is missing")
#   expect_error(is.multipoint(), "argument \"x\" is missing")
#   expect_error(is.linestring(), "argument \"x\" is missing")
#   expect_error(is.multilinestring(), "argument \"x\" is missing")
#   expect_error(is.polygon(), "argument \"x\" is missing")
#   expect_error(is.multipolygon(), "argument \"x\" is missing")
#   expect_error(is.feature(), "argument \"x\" is missing")
#   expect_error(is.featurecollection(), "argument \"x\" is missing")
#   expect_error(is.geometrycollection(), "argument \"x\" is missing")

#   expect_error(is.point("foobar"), "x must be of class 'geopoint'")
#   expect_error(is.multipoint("foobar"), "x must be of class 'geomultipoint'")
#   expect_error(is.linestring("foobar"), "x must be of class 'geolinestring'")
#   expect_error(is.multilinestring("foobar"), 
#     "x must be of class 'geomultilinestring'")
#   expect_error(is.polygon("foobar"), "x must be of class 'geopolygon'")
#   expect_error(is.multipolygon("foobar"), 
#     "x must be of class 'geomultipolygon'")
#   expect_error(is.feature("foobar"), "x must be of class 'geofeature'")
#   expect_error(is.featurecollection("foobar"), 
#     "x must be of class 'geofeaturecollection'")
#   expect_error(is.geometrycollection("foobar"), 
#     "x must be of class 'geogeometrycollection'")
# })
