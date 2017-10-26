context("to_geojson")

pt <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
ls <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
py <- '{ "type": "Polygon",
  "coordinates": [
[ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
]
}'
mpt <- '{ "type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
mls <- '{ "type": "MultiLineString",
    "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
mpy <- '{ "type": "MultiPolygon",
"coordinates": [
[[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
[[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
[[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
]
}'
ft <- '{"type":"Feature","properties":{"a":"b"},
"geometry":{"type": "MultiPoint","coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}}'
fc <- '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"a":"b"},
"geometry":{"type": "MultiPoint","coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}}]}'
gc <- '{
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

test_that("to_geojson works for all types", {
  expect_is(to_geojson(pt), "geopoint")
  expect_is(to_geojson(ls), "geolinestring")
  expect_is(to_geojson(py), "geopolygon")
  expect_is(to_geojson(mpt), "geomultipoint")
  expect_is(to_geojson(mls), "geomultilinestring")
  expect_is(to_geojson(mpy), "geomultipolygon")
  expect_is(to_geojson(ft), "geofeature")
  expect_is(to_geojson(fc), "geofeaturecollection")
  expect_is(to_geojson(gc), "geogeometrycollection")
})

test_that("to_geojson fails on incorrect type", {
  expect_error(to_geojson('{"type": "foo"}'), "Invalid GeoJSON type: foo")
})

