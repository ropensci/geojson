context("crs_add")

invisible(linting_opts(suppress_pkgcheck_warnings = TRUE))

x <- '{ "type": "Polygon",
"coordinates": [
  [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
  ]
}'
crs <- '{"type": "name",
 "properties": {
     "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
}}'
zz <- x %>% feature()

test_that("crs_add", {
  aa <- crs_add(zz, crs)

  expect_is(aa, "jqson")
  expect_is(aa, "character")
  expect_equal(length(aa), 1)
  expect_match(aa, "crs")
  expect_match(aa, "properties")
  expect_match(aa, "urn:ogc:def:crs")
})

test_that("crs_add fails well", {
  expect_error(crs_add(), "argument \"x\" is missing")
  expect_error(crs_add(5), "is not TRUE")
  expect_error(crs_add(zz, 4), "is not TRUE")
})

context("crs_get")
test_that("crs_get", {
  w <- crs_add(zz, crs)
  aa <- crs_get(w)

  expect_is(aa, "list")
  expect_named(aa, c("type", "properties"))
  expect_equal(length(aa), 2)
  expect_equal(aa$type, "name")
  expect_match(aa$properties$name, "urn:ogc:def:crs")
})

test_that("crs_get fails well", {
  expect_error(crs_get(), "argument \"x\" is missing")
  expect_error(crs_get(5), "is not TRUE")
})
