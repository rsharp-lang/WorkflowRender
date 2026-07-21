#' Set the Disable Flag of a Workflow Application Module
#'
#' @description
#' Toggles the \code{disable} flag of one or more analysis application
#' modules that have been registered in the workflow context. When a
#' module is disabled, the workflow execution engine will skip it
#' during the next run, but the module is still kept in the workflow
#' registry so that it can be re-enabled later.
#'
#' @param app a character vector of the application names whose
#'   \code{disable} flag should be toggled. Each name must correspond
#'   to a module that has been registered in the workflow context via
#'   \code{\link{hook}}.
#' @param disable a logical value that specifies the new value of the
#'   \code{disable} flag. The default value of \code{TRUE} disables
#'   the supplied modules; passing \code{FALSE} re-enables them.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the modification of the \code{disable} slot of the targeted
#' application modules in the workflow context stored in the global
#' environment.
#'
#' @details
#' This function is used to disable a specific analysis application
#' module in the workflow context. The function iterates over the
#' supplied \code{app} names and sets the \code{disable} slot of the
#' corresponding module in the \code{context$workflow} tuple list to
#' the supplied \code{disable} value. The updated context is then
#' written back to the global environment so that the change is
#' visible to subsequent calls to \code{\link{run}}.
#'
#' @examples
#' \dontrun{
#' # disable the "filter" module for the next run
#' set_disable("filter");
#'
#' # re-enable it later
#' set_disable("filter", disable = FALSE);
#' }
#'
#' @seealso \code{\link{hook}}, \code{\link{run}},
#'   \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const set_disable = function(app, flag = TRUE) {
    const app_name = get_app_name(app);
    const ctx      = .get_context();

    if (app_name in ctx$workflow) {
        app = ctx$workflow[[app_name]];
        app$disable = flag;
    }

    invisible(NULL);
}