context("geo_pretty")

invisible(linting_opts(suppress_pkgcheck_warnings = TRUE))

pt <- point('{ "type": "Point", "coordinates": [100.0, 0.0] }')
poly <- polygon('{ "type": "Polygon", "coordinates": [[ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]]}')

test_that("geo_type works", {
  expect_is(geo_pretty(pt), "json")
  expect_match(geo_pretty(pt), "\n")
  expect_false(grepl("\n", unclass(pt)))

  expect_is(geo_pretty(poly), "json")
  expect_match(geo_pretty(poly), "\n")
  expect_false(grepl("\n", unclass(poly)))
})

test_that("geo_pretty fails well", {
  expect_error(geo_pretty(5), "no 'geo_pretty' method for numeric")
  expect_error(geo_pretty(list()), "no 'geo_pretty' method for list")
  expect_error(geo_pretty(mtcars), "no 'geo_pretty' method for data.frame")
  expect_error(geo_pretty("ASDfasdf"), "no 'geo_pretty' method for character")
})
