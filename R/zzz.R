utils::globalVariables(c(".data"))

.onLoad <- function(libname, pkgname) {
  options(officer.date_format = "%Y-%m-%d")
}

.onAttach <- function(libname, pkgname) {
  ver <- utils::packageVersion(pkgname)
  packageStartupMessage(
    "officer.dev ", ver, " (development version of officer)\n",
    "https://github.com/markheckmann/officer.dev"
  )
}
