test_that("make_filename function works", {
  expect_equal(make_filename(2002),
               "accident_2002.csv.bz2")
})
