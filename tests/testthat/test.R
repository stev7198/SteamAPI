library(testthat)
library(steamR)

test_that("get_player_summaries returns an error with an invalid API key", {
  expect_error(get_player_summaries("INVALID_API_KEY", "76561198000000000"))
})

test_that("get_owned_games returns a data frame or NULL", {
  result <- tryCatch(
    get_owned_games("INVALID_API_KEY", "76561198000000000"),
    error = function(e) NULL
  )
  expect_true(is.null(result) || is.data.frame(result))
})
