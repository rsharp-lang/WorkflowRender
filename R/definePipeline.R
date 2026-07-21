#' Create a Custom Pipeline Workflow Execution Sequence
#'
#' @description
#' Overrides the execution order of the workflow modules by replacing
#' the \code{pipeline} slot of the workflow context with the supplied
#' sequence of module names. This function is typically used for
#' debugging or running a specific subset of the registered workflow
#' modules without modifying the registration order.
#'
#' @param seq a character vector of the application module names that
#'   should be executed, in the order in which they should be invoked.
#'   Each name must correspond to a module that has been registered in
#'   the workflow context via \code{\link{hook}}.
#'
#' @details
#' This function is usually used for debugging a specific workflow
#' module or for reordering the execution sequence at runtime. The
#' supplied sequence replaces the existing \code{pipeline} slot of the
#' workflow context in-place, and the updated context is written back
#' to the global environment so that subsequent calls to
#' \code{\link{run}} will respect the new order.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the modification of the \code{pipeline} slot of the workflow context
#' stored in the global environment.
#'
#' @examples
#' \dontrun{
#' # run only the "filter" and "export" modules in that order
#' WorkflowRender::definePipeline(c("filter", "export"));
#' WorkflowRender::run();
#' }
#'
#' @seealso \code{\link{run}}, \code{\link{hook}},
#'   \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const definePipeline = function(seq) {
    const ctx = .get_context();
    const ssid = NULL;

    ctx$pipeline = seq;
    # update the global context symbol
    set(globalenv(), paste([__global_ctx,ssid],sep ="-"), ctx);

    invisible(NULL);
}
