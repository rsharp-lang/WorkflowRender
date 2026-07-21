#' Get the Application Name from an Application Object
#'
#' @description
#' Extracts the application name from an analysis application object
#' that has been constructed via the \code{\link{app}} function. This
#' is the simplest implementation of the \code{\link{get_app_name}}
#' generic function and is used as the fallback when the supplied
#' object is already a fully-formed application list.
#'
#' @param app the application object whose name should be extracted.
#'   The object is expected to be a list with a \code{name} slot, as
#'   produced by \code{\link{app}}.
#'
#' @return
#' A character vector of the application name extracted from the
#' \code{name} slot of the supplied object.
#'
#' @details
#' This function is registered as the default method of the
#' \code{\link{get_app_name}} generic function. When the supplied
#' object is a list with a \code{name} slot, the function simply
#' returns the value of that slot. When the supplied object is a
#' bare function reference, the more specialized
#' \code{\link{get_app_name.func_reference}} method is invoked
#' instead.
#'
#' @seealso \code{\link{get_app_name}},
#'   \code{\link{get_app_name.func_reference}}, \code{\link{app}}
#'
#' @keywords internal
#'
const get_appName.obj = function(app) {
    let verbose as boolean = as.logical(getOption("verbose"));

    if (verbose) {
        print("app object is a list.");
    }

    if (nchar(app$name) > 0) {
        return(app$name);
    } else {
        throw_err(["invalid app object: ", JSON::json_encode(app)]);
    }  
}