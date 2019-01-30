context("is-methods")

test_that("is-methods", {
  expect_is(is_generator, "function")
  expect_is(is.point, "function")
  expect_is(is.multipoint, "function")
  expect_is(is.linestring, "function")
  expect_is(is.multilinestring, "function")
  expect_is(is.polygon, "function")
  expect_is(is.multipolygon, "function")
  expect_is(is.feature, "function")
  expect_is(is.featurecollection, "function")
  expect_is(is.geometrycollection, "function")

  pt <- point('{ "type": "Point", "coordinates": [100.0, 0.0] }')
  mpt <- multipoint('{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }')
  ls <- linestring('{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }')
  x <- '{ "type": "MultiLineString",
    "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
  mls <- multilinestring(x)
  x <- '{ "type": "Polygon",
  "coordinates": [
    [ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]
    ]
  }'
  pg <- polygon(x)
  x <- '{ "type": "MultiPolygon",
  "coordinates": [
    [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
    [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
    [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
    ]
  }'
  mpg <- multipolygon(x)
  ft <- feature(pt)
  fc <- featurecollection(geojson_data$polygons_within)
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
  gc <- geometrycollection(x)

  expect_null(is.point(pt))
  expect_null(is.multipoint(mpt))
  expect_null(is.linestring(ls))
  expect_null(is.multilinestring(mls))
  expect_null(is.polygon(pg))
  expect_null(is.multipolygon(mpg))
  expect_null(is.feature(ft))
  expect_null(is.featurecollection(fc))
  expect_null(is.geometrycollection(gc))
})

test_that("is-methods fail well", {
  expect_error(is_generator(), "argument \"x\" is missing")
  expect_error(is.point(), "argument \"x\" is missing")
  expect_error(is.multipoint(), "argument \"x\" is missing")
  expect_error(is.linestring(), "argument \"x\" is missing")
  expect_error(is.multilinestring(), "argument \"x\" is missing")
  expect_error(is.polygon(), "argument \"x\" is missing")
  expect_error(is.multipolygon(), "argument \"x\" is missing")
  expect_error(is.feature(), "argument \"x\" is missing")
  expect_error(is.featurecollection(), "argument \"x\" is missing")
  expect_error(is.geometrycollection(), "argument \"x\" is missing")

  expect_error(is.point("foobar"), "x must be of class 'geopoint'")
  expect_error(is.multipoint("foobar"), "x must be of class 'geomultipoint'")
  expect_error(is.linestring("foobar"), "x must be of class 'geolinestring'")
  expect_error(is.multilinestring("foobar"), 
    "x must be of class 'geomultilinestring'")
  expect_error(is.polygon("foobar"), "x must be of class 'geopolygon'")
  expect_error(is.multipolygon("foobar"), 
    "x must be of class 'geomultipolygon'")
  expect_error(is.feature("foobar"), "x must be of class 'geofeature'")
  expect_error(is.featurecollection("foobar"), 
    "x must be of class 'geofeaturecollection'")
  expect_error(is.geometrycollection("foobar"), 
    "x must be of class 'geogeometrycollection'")
})
