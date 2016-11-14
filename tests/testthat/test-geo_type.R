context("geo_type")

pt <- point('{ "type": "Point", "coordinates": [100.0, 0.0] }')

poly <- polygon('{ "type": "Polygon",
 "coordinates": [
   [ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]
   ]
}')

test_that("geo_type works", {
  expect_is(geo_type(pt), "character")
  expect_equal(geo_type(pt), "Point")

  expect_is(geo_type(poly), "character")
  expect_equal(geo_type(poly), "Polygon")
})

test_that("geo_type fails well", {
  expect_error(geo_type(5), "no 'geo_type' method for numeric")
  expect_error(geo_type(list()), "no 'geo_type' method for list")
  expect_error(geo_type(mtcars), "no 'geo_type' method for data.frame")
  expect_error(geo_type("ASDfasdf"), "no 'geo_type' method for character")
})
