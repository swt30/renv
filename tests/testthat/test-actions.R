
context("Actions")

test_that("we can query actions for a sample project", {

  renv_tests_scope("bread")
  renv_scope_options(renv.config.auto.snapshot = FALSE)

  renv::init(settings = list(snapshot.type = "simple"))
  renv::install("breakfast")

  acts <- actions("snapshot", library = renv_paths_library(), project = getwd())
  expect_true(nrow(acts) == 3)
  expect_setequal(acts$Package, c("breakfast", "oatmeal", "toast"))
  expect_true(all(acts$Action == "install"))

  # note: empty for non-clean restore as we don't remove packages
  acts <- actions("restore", library = renv_paths_library(), project = getwd())
  expect_true(nrow(acts) == 0)

  # now non-empty
  acts <- actions("restore", library = renv_paths_library(), project = getwd(), clean = TRUE)
  expect_true(nrow(acts) == 3)
  expect_setequal(acts$Package, c("breakfast", "oatmeal", "toast"))
  expect_true(all(acts$Action == "remove"))

})
