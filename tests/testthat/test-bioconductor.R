
context("Bioconductor")

test_that("packages can be installed, restored from Bioconductor", {

  skip_on_cran()
  skip_on_appveyor()

  skip("unreliable test")

  skip_if(getRversion() < "3.6")
  skip_if(R.version$nickname == "Unsuffered Consequences")

  renv_tests_scope("limma")

  cran <- "https://cloud.r-project.org"
  install.packages("BiocManager", repos = cran, quiet = TRUE)
  BiocManager <- asNamespace("BiocManager")
  BiocManager$install("limma", quiet = TRUE)

  expect_true(renv_package_installed("BiocManager"))
  expect_true(renv_package_installed("BiocVersion"))
  expect_true(renv_package_installed("limma"))

  snapshot()
  lockfile <- snapshot(lockfile = NULL)
  records <- renv_records(lockfile)
  expect_true("BiocManager" %in% names(records))
  expect_true("BiocVersion" %in% names(records))
  expect_true("limma" %in% names(records))

  if (!renv_platform_linux())
    renv_scope_options(pkgType = "both")

  remove("limma")
  restore()
  expect_true(renv_package_installed("limma"))

})
