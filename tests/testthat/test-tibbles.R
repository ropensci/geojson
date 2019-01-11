context("tibble's work")

test_that("tibbles work with multipolygon inputs", {
  x <- '{ "type": "MultiPolygon",
  "coordinates": [
    [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
    [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
    [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
    ]
  }'
  y <- multipolygon(x)

  aa <- tibble::tibble(a = 1:5, b = list(y))

  expect_is(aa, "tbl_df")
  expect_type(aa$a, "integer")
  expect_type(aa$b, "list")
  expect_is(aa$b[[1]], "geomultipolygon")
  expect_equal(attr(aa$b[[1]], "no_polygon"), 2)
  expect_is(attr(aa$b[[1]], "coords"), "character")
  expect_equal(length(aa$b), 5)
})
