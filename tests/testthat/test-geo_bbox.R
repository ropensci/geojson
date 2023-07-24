context("geo_bbox")



test_that("geo_bbox works - Point input", {
  x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
  y <- point(x)
  aa <- y %>% feature() %>% geo_bbox()

  expect_is(aa, "numeric")
  expect_type(aa, "double")
  expect_equal(length(aa), 4)
  expect_equal(aa, c(100, 0, 100, 0))
})

test_that("geo_bbox works - Point input", {
  x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
  y <- multipoint(x)
  aa <- y %>% feature() %>% geo_bbox()

  expect_is(aa, "numeric")
  expect_type(aa, "double")
  expect_equal(length(aa), 4)
  expect_equal(aa, c(100, 0, 101, 1))
})

test_that("geo_bbox works - Negative coordinates", {
  x <- '{"type": "Polygon", "coordinates": [ [ [-101, 0], [-100, 0], [-100, -1], [-101, 0] ] ] }'
  y <- polygon(x)
  aa <- geo_bbox(y)

  expect_is(aa, "numeric")
  expect_type(aa, "double")
  expect_equal(length(aa), 4)
  expect_equal(aa, c(-101, -1, -100, 0))
})

test_that("geo_bbox fails well", {
  expect_error(
    geo_bbox(5),
    "no 'geo_bbox' method for numeric")
})
