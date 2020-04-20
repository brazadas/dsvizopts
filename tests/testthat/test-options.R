test_that("Options", {

  library(tidyverse)

  ## flatten options

  x <- list(a = 1, b = list(b1name = "b1", b2name = "b2"), c = list(cname = "c"))
  expect_equal(names(options_flatten(x)),c("a","b1name","b2name","cname"))
  expect_false(is_flat_list(x))
  expect_true(is_flat_list(flatten(x)))
  x <- list(a = 1, b = list(b1name = "b1", b2name = NULL), c = list(cname = "c"))
  expect_equal(options_flatten(x),
               list(a = 1, b1name = "b1", b2name = NULL, cname = "c"))
  expect_equal(names(options_flatten(x)),c("a","b1name","b2name","cname"))
  x <- list(a = list(name = "a"), b = list(name = "b"))
  expect_error(options_flatten(x), "Not unique names for options: name")

  ## Pull group

  opts <- dsviz_defaults(flat = TRUE)
  expect_equal(dsviz_default_opts()$summarize, pull_opt_group(opts, "summarize"))
  expect_error(pull_opt_group(opts, "stylesss"))
  expect_equal(dsviz_default_opts()$style, pull_opt_group(opts, "style"))

  ## Merge options

  defaults <- list(a = "AAA", b = "BBB")
  myfun <- function(x, ...){
    opts <- mergeOptions(..., defaults = defaults)
    opts
  }
  myfun_opts <- myfun(x = 0)
  # expect_equal(myfun_opts, discard(defaults, is.null))
  expect_equal(myfun_opts, defaults)

  myfun_opts <- myfun(x = 0, a = "a", b = "b")
  expect_equal(myfun_opts, list(a = "a", b = "b"))
  myfun_opts <- myfun(x = 0, agg = "MyAgg")
  expect_true(is_flat_list(myfun_opts))
  expect_equal(myfun_opts$agg,"MyAgg")
  expect_equal(myfun_opts, c(defaults, list(agg = "MyAgg")))

  myfun_opts <- myfun(x = 0, opts = list(agg = "MyAggList", title = "New Title"))
  expect_true(is_flat_list(myfun_opts))
  expect_equal(myfun_opts$agg,"MyAggList")
  expect_equal(myfun_opts$title,"New Title")
  expect_equal(myfun_opts, c(defaults, list(agg = "MyAggList", title =  "New Title")))

  myfun_opts <- myfun(x = 0, agg = "MyAgg", opts = list(agg = "MyAggOpts"))
  expect_true(is_flat_list(myfun_opts))
  expect_equal(myfun_opts$agg,"MyAggOpts")

  # Merge dsviz Options

  opts_defaults <- dsvizopts:::dsviz_defaults()
  fun <- function(...){merge_dsviz_options(...)}
  opts_dsviz <- fun()
  expect_equal(opts_dsviz, opts_defaults)

  myopts <- list( background_color = "#000000" )
  opts_dsviz <- fun(background_color = "#000000")
  opts_flat <- options_flatten(opts_dsviz)
  expect_equal(opts_flat$background_color, "#000000")

  expect_equal(opts_dsviz$theme$logo,opts_defaults$theme$logo)

  myopts <- list(branding_text = "Braning text heeeere",
                 background_color = "#F0F0F0")
  opts_dsviz <- fun(opts = myopts)
  expect_equal(opts_dsviz$theme$branding_text, myopts$branding_text)
  expect_equal(opts_dsviz$theme$background_color, myopts$background_color)





})