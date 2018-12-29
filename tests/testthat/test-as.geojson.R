context("as.geojson - character to geojson")

library("sp")

test_that("character to geojson works - Point", {
  aa <- as.geojson(geojson_data$featurecollection_point)
  expect_is(aa, "geojson")
  expect_is(aa, "json")
  expect_type(aa, "character")
  expect_equal(get_type(aa), "FeatureCollection")
  expect_equal(
    unique(
      gsub("\\\"", "", unclass(jqr::jq(unclass(aa), ".features[].geometry.type"))) # nodoc
    ),
    "Point"
  )
  # length is correct
  expect_equal(
    length(unclass(jqr::jq(unclass(aa), ".features[]"))),
    1
  )
})

test_that("character to geojson works - Polygon", {
  aa <- as.geojson(geojson_data$polygons_average)
  expect_is(aa, "geojson")
  expect_is(aa, "json")
  expect_type(aa, "character")
  expect_equal(get_type(aa), "FeatureCollection")
  expect_equal(
    unique(
      gsub("\\\"", "", unclass(jqr::jq(unclass(aa), ".features[].geometry.type"))) # nodoc
    ),
    "Polygon"
  )
  # length is correct
  expect_equal(
    length(unclass(jqr::jq(unclass(aa), ".features[]"))),
    2
  )
})

test_that("character to geojson - fails well", {
  expect_error(as.geojson(5), "unable to find an inherited method")
  expect_error(as.geojson(mtcars), "unable to find an inherited method")
  expect_error(as.geojson("asdfasdf"), "json invalid")
  expect_error(
    as.geojson("{\"type\":\"Point\",\"coordinates\":[-99.74,32.4])}"),
    "lexical error"
  )
})



context("as.geojson - Spatial objects to geojson")

test_that("SpatialPointsDataFrame to geojson works", {
  x <- c(1,2,3,4,5)
  y <- c(3,2,5,1,4)
  s <- SpatialPoints(cbind(x,y))
  s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])

  aa <- as.geojson(s)

  expect_is(aa, "geojson")
  expect_type(aa, "character")
  expect_equal(get_type(aa), "FeatureCollection")
  expect_equal(
    unique(
      gsub("\\\"", "", unclass(jqr::jq(unclass(aa), ".features[].geometry.type"))) # nodoc
    ),
    "Point"
  )
  # length is correct
  expect_equal(
    length(unclass(jqr::jq(unclass(aa), ".features[]"))),
    5
  )

  # sp_to_geojson works identically
  expect_identical(aa, sp_to_geojson(s))
})

test_that("SpatialLinesDataFrame to geojson works", {
  c1 <- cbind(c(1,2,3), c(3,2,2))
  c2 <- cbind(c1[,1]+.05,c1[,2]+.05)
  c3 <- cbind(c(1,2,3),c(1,1.5,1))
  L1 <- Line(c1)
  L2 <- Line(c2)
  L3 <- Line(c3)
  Ls1 <- Lines(list(L1), ID = "a")
  Ls2 <- Lines(list(L2, L3), ID = "b")
  sl1 <- SpatialLines(list(Ls1))
  sl12 <- SpatialLines(list(Ls1, Ls2))
  dat <- data.frame(X = c("Blue", "Green"),
                    Y = c("Train", "Plane"),
                    Z = c("Road", "River"), row.names = c("a", "b"))
  sldf <- SpatialLinesDataFrame(sl12, dat)

  aa <- as.geojson(sldf)

  expect_is(aa, "geojson")
  # is characater
  expect_type(aa, "character")
  # correct high level type
  expect_equal(get_type(aa), "FeatureCollection")
  # correct feature type
  expect_equal(
    unique(
      gsub("\\\"", "", unclass(jqr::jq(unclass(aa), ".features[].geometry.type"))) # nodoc
    ),
    "MultiLineString"
  )
  # length is correct
  expect_equal(
    length(unclass(jqr::jq(unclass(aa), ".features[]"))),
    2
  )

  # sp_to_geojson works identically
  expect_identical(aa, sp_to_geojson(sldf))
})

test_that("SpatialPolygonsDataFrame to geojson works", {
  poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
                                       c(40,50,45,40)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
                                       c(30,40,35,30)))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")

  aa <- as.geojson(sp_polydf)

  expect_is(aa, "geojson")
  # is characater
  expect_type(aa, "character")
  # correct high level type
  expect_equal(get_type(aa), "FeatureCollection")
  # correct feature type
  expect_equal(
    unique(
      gsub("\\\"", "", unclass(jqr::jq(unclass(aa), ".features[].geometry.type"))) # nodoc
    ),
    "Polygon"
  )
  # length is correct
  expect_equal(
    length(unclass(jqr::jq(unclass(aa), ".features[]"))),
    2
  )

  # sp_to_geojson works identically
  expect_identical(aa, sp_to_geojson(sp_polydf))
})


test_that("sf to geojson works", {
  skip_if_not_installed("sf")

  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  gnc <- geojson::as.geojson(nc)
  expect_is(gnc, "geojson")
})
