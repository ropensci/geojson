context("point")

test_that("point works", {
  stt <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
  aa <- point(stt)

  expect_is(aa, "point")
  expect_is(aa[[1]], "character")
  expect_match(aa[[1]], "type")
  expect_match(aa[[1]], "Point")
  expect_match(aa[[1]], "coordinates")
})

# test_that("methods on points work", {
#   stt <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#   aa <- point(stt)
#
#   expect_is(aa, "point")
#   expect_is(aa[[1]], "character")
#   expect_match(aa[[1]], "type")
#   expect_match(aa[[1]], "Point")
#   expect_match(aa[[1]], "coordinates")
# })

test_that("point fails well", {
  expect_error(point('{"type": "FooBar"}'), "jq method not")
})
