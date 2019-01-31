context("bbox_add")

x <- '{ "type": "Polygon",
"coordinates": [
  [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
  ]
}'
y <- polygon(x)

test_that("bbox_add: no bbox given", {
  aa <- bbox_add(y)

  expect_is(aa, "jqson")
  expect_is(aa, "character")
  expect_equal(length(aa), 1)
  expect_match(aa, "bbox")
  expect_is(jsonlite::fromJSON(aa)$bbox, "integer")
  expect_equal(length(jsonlite::fromJSON(aa)$bbox), 4)
})

test_that("bbox_add fails well", {
  expect_error(bbox_add(), "argument \"x\" is missing")
  expect_error(bbox_add(5), "is not TRUE")
  expect_error(bbox_add(y, 4), "is not TRUE")
})


context("bbox_get")
test_that("bbox_get: no bbox given", {
  w <- bbox_add(y)
  aa <- bbox_get(w)

  expect_is(aa, "numeric")
  expect_equal(length(aa), 4)
})

test_that("bbox_get fails well", {
  expect_error(bbox_get(), "argument \"x\" is missing")
  expect_error(bbox_get(5), "is not TRUE")
})
