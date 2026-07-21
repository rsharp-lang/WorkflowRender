const app_not_registered = "target app function is not registered in the workflow yet!";
const invalid_app_target = "we can not get the workflow app name for the given function object!";

#' Get the Application Name from a Function Reference
#'
#' @description
#' Resolves the application name that has been associated with a bare
#' function reference. This implementation of the
#' \code{\link{get_app_name}} generic function is used when the
#' supplied object is a callable function rather than a fully-formed
#' application list.
#'
#' @param f the function reference whose associated application name
#'   should be resolved.
#'
#' @return
#' A character vector of the application name that has been
#' associated with the supplied function reference. When the function
#' has not been registered in the workflow context yet, an empty
#' string is returned and a warning is emitted via
#' \code{\link{echo_warning}}.
#'
#' @details
#' The function looks up the name of the supplied function via
#' \code{\link{get_functionName}} and then uses that name as a key
#' into the \code{symbols} map of the workflow context. The
#' \code{symbols} map is populated by \code{\link{hook}} when an
#' application is registered, and maps the function name of the
#' analysis callable to the application name.
#'
#' When the function name cannot be found in the \code{symbols} map,
#' the function emits a warning via \code{\link{echo_warning}} and
#' returns an empty string. This allows the calling code to detect
#' the missing registration and handle it gracefully.
#'
#' @seealso \code{\link{get_app_name}},
#'   \code{\link{get_appName.obj}}, \code{\link{get_functionName}},
#'   \code{\link{hook}}, \code{\link{echo_warning}}
#'
#' @keywords internal
#'
const get_appName.func_reference = function(app) {
    # test app signature
    let fname = get_functionName(app);
    let ctx   = .get_context()$symbols;
    let verbose = as.logical(getOption("verbose"));

    if (verbose) {
        print("view of the workflow symbol maps:");
        str(ctx);
    }

    if (app_check.delegate(app)) {
        if (fname in ctx) {
            ctx[[fname]];
        } else {
            throw_err(app_not_registered);
        }
    } else {
        throw_err(invalid_app_target);
    }
}
