context("properties")

test_that("properties_add works - value in fxn call", {
  x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
  y <- linestring(x)
  aa <- y %>% feature() %>% properties_add(population = 1000)

  expect_is(aa, "geofeature")
  expect_equal(length(aa), 1)
  expect_is(unclass(aa), "character")
  expect_match(aa, "population\":1000")
})

test_that("properties_add works - value in fxn call", {
  x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
  y <- linestring(x)
  pop <- 5000
  aa <- y %>% feature() %>% properties_add(population = pop)

  expect_is(aa, "geofeature")
  expect_equal(length(aa), 1)
  expect_is(unclass(aa), "character")
  expect_match(aa, "population\":5000")
})

test_that("properties_add fails well", {
  expect_error(
    properties_add(5),
    "jq method not implemented for numeric")
})



test_that("properties_get works - value in fxn call", {
  xx <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
  y <- linestring(xx)
  aa <- y %>% feature() %>% properties_add(population = 1000)
  x <- properties_get(aa, property = 'population')

  expect_is(x, "jqson")
  expect_equal(length(x), 1)
  expect_is(unclass(x), "character")
  expect_is(as.numeric(unclass(x)), "numeric")
  expect_equal(as.numeric(unclass(x)), 1000)
})

test_that("properties_get fails well", {
  expect_error(
    properties_get("adf", "asdf"),
    "Invalid numeric literal")
  expect_error(
    properties_get(5),
    "jq method not implemented for numeric")

  expect_error(
    properties_add(),
    '"x" is missing'
  )

  # .list must be a list
  expect_error(
    properties_add("", .list = 5),
    ".list must be a list"
  )

  # all .list elements must be named
  expect_error(
    properties_add("x", .list = list(4, a = 5)),
    "all elements of .list must be named"
  )
})
