#' Package Load Hook
#'
#' @description
#' Displays the content of the \code{DESCRIPTION} file of the
#' \code{WorkflowRender} package when the package is loaded into the
#' R# runtime. This is primarily a diagnostic helper that allows the
#' user to verify the package metadata (version, dependencies, etc.)
#' at load time.
#'
#' @details
#' The function is invoked automatically by the R# runtime when the
#' package is attached. It calls \code{str(description("WorkflowRender"))}
#' to print a compact structure representation of the parsed
#' \code{DESCRIPTION} file to the standard output.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the printing of the package description metadata to the standard
#' output.
#'
#' @keywords internal
#' @seealso \code{\link{description}}
#'
const .onLoad = function() {
    str(description("WorkflowRender"));
}
