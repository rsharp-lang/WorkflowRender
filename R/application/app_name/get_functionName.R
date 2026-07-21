#' Get the Function Name of a Function Object
#'
#' @description
#' Extracts the name of a function object by inspecting the
#' \code{name} attribute that is set on the function when it is
#' defined. This function is used internally by
#' \code{\link{get_appName.func_reference}} to look up the application
#' name that has been associated with a bare function reference.
#'
#' @param f the function object whose name should be extracted.
#'
#' @return
#' A character vector of the function name. When the supplied
#' function does not carry a \code{name} attribute, an empty string
#' is returned.
#'
#' @details
#' The function inspects the custom attributes of the supplied
#' function via \code{.Internal::attributes} and returns the value of
#' the \code{name} attribute. When the attribute is missing or its
#' value is \code{NULL}, the function returns an empty string so
#' that downstream code can safely use the result as a character
#' vector without additional null checks.
#'
#' @examples
#' \dontrun{
#' let demo = function(app, context) { print("hi"); };
#' print(get_functionName(demo));
#' }
#'
#' @seealso \code{\link{get_appName.func_reference}},
#'   \code{\link{get_app_name}}
#'
#' @keywords internal
#'
const get_functionName = function(f) {
    let list = as.list(args(f));
    let func = list[[""]];

    return(func$symbol);
}