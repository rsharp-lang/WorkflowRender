#' Get the Application Name of a Workflow Module
#'
#' @description
#' Generic function that resolves the application name of a workflow
#' module from either a fully-formed application object or a bare
#' function reference. The function dispatches to one of the
#' specialized implementations based on the type of the supplied
#' argument.
#'
#' @param app the application object whose name should be extracted.
#'   This parameter can be supplied in two forms:
#'   \enumerate{
#'     \item An application list object produced by the
#'       \code{\link{app}} function. In this case the function
#'       dispatches to \code{\link{get_appName.obj}}.
#'     \item A bare function reference that has been registered in
#'       the workflow context via \code{\link{hook}}. In this case
#'       the function dispatches to
#'       \code{\link{get_appName.func_reference}}.
#'   }
#'
#' @return
#' A character vector of the application name. When the supplied
#' object is a bare function reference that has not been registered
#' in the workflow context yet, an empty string is returned.
#'
#' @details
#' The function uses the R# generic function dispatch mechanism to
#' select the appropriate implementation:
#' \itemize{
#'   \item When \code{app} is a list object, the function dispatches
#'     to \code{\link{get_appName.obj}}, which simply returns the
#'     value of the \code{name} slot.
#'   \item When \code{app} is a callable function, the function
#'     dispatches to \code{\link{get_appName.func_reference}}, which
#'     looks up the application name in the \code{symbols} map of
#'     the workflow context.
#' }
#'
#' @examples
#' \dontrun{
#' # from an application object
#' name <- get_app_name(my_app);
#'
#' # from a function reference
#' name <- get_app_name(my_func);
#' }
#'
#' @seealso \code{\link{get_appName.obj}},
#'   \code{\link{get_appName.func_reference}}, \code{\link{app}},
#'   \code{\link{hook}}
#'
#' @author xieguigang
#'
const get_app_name = function(app) {
    let verbose as boolean = as.logical(getOption("verbose"));

    if (is.list(app)) {
        return(get_appName.obj(app));
    } else {
        if(is.function(app)) {
            if (verbose) {
                print("try to get the app reference name from a analysis function!");
            }

            get_appName.func_reference(app);
        } else {
            if (verbose) {
                print(`the given app object '${app}' is a name reference to the application module!`);
            }
            app;
        }
    }
}