#' GeoJSON Linting
#'
#' @export
#' @param lint (logical) lint geojson or not. Default: \code{FALSE}
#' @param method (character) method to use:
#' 
#' - hint - uses `geojsonlint::geojson_hint()`
#' - lint - uses `geojsonlint::geojson_lint()`
#' - validate - uses `geojsonlint::geojson_validate()`
#' 
#' @param error (logical) Throw an error on parse failure? If \code{TRUE}, then
#' function returns \code{TRUE} on success, and stop with the error
#' message on error. Default: \code{FALSE}
#' @param suppress_pkgcheck_warnings (logical) Suppress warning when
#' `geojsonlint` is not installed? Default: \code{FALSE}
#' @details if you have \pkg{geojsonlint} installed, we can lint
#' your GeoJSON inputs for you. If not, we skip that step.
#'
#' Note that even if you aren't linting your geojson with \pkg{geojsonlint},
#' we still do some minimal checks.
#' @examples
#' linting_opts(lint = TRUE)
#'
#' linting_opts(lint = TRUE, method = "hint")
#' linting_opts(lint = TRUE, method = "hint", error = TRUE)
#' linting_opts(lint = TRUE, method = "lint")
#' linting_opts(lint = TRUE, method = "lint", error = TRUE)
#' linting_opts(lint = TRUE, method = "validate")
#' linting_opts(lint = TRUE, method = "validate", error = TRUE)
linting_opts <- function(lint = FALSE, method = "hint", error = FALSE,
  suppress_pkgcheck_warnings = FALSE) {

  if (!method %in% c('hint', 'lint', 'validate')) {
    stop("method must be one of 'hint', 'lint', or 'validate'", call. = FALSE)
  }
  options(geojson.lint = lint)
  method_fun <- switch(
    method,
    hint = 'geojsonlint::geojson_hint',
    lint = 'geojsonlint::geojson_lint',
    validate = 'geojsonlint::geojson_validate'
  )
  options(geojson.method = method_fun)
  options(geojson.error = error)
  options(geojson.suppress_pkgcheck_warnings = suppress_pkgcheck_warnings)

  list(lint = lint, method = method, error = error, 
    suppress_pkgcheck_warnings = suppress_pkgcheck_warnings)
}

hint <- function(x) {
  eval(parse(text = getOption("geojson.method")))(
    x,
    error = getOption("geojson.error")
  )
}

hint_geojson <- function(x) {
  if (checkforpkg('geojsonlint')) {
    if (getOption("geojson.lint")) hint(x)
  }
}
