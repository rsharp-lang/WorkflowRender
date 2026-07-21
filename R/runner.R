#' Internal Workflow Execution Engine
#'
#' @description
#' An internal function that drives the execution of a modular workflow.
#' It sequentially processes analysis modules according to the pipeline
#' configuration stored inside the workflow context while respecting the
#' disablement rules that may be configured either through the
#' \code{disables} argument or through the \code{disable} flag of each
#' individual application module.
#'
#' @param context A workflow context object, typically obtained via
#' \code{\link{.get_context}}. The following slots are used by this
#' function:
#' \itemize{
#'   \item{\code{pipeline} - a character vector that defines the module
#'         execution order.}
#'   \item{\code{workflow} - a named list of registered module
#'         definitions, keyed by module name.}
#' }
#' @param disables A named list specifying module disablement status.
#' The expected format is \code{list(module_name = TRUE/FALSE)}. Modules
#' whose entry is set to \code{TRUE} will be skipped during execution.
#'
#' @details
#' This function performs the following steps for each module name found
#' in \code{context$pipeline}:
#' \enumerate{
#'   \item Retrieves the module definition object from
#'         \code{context$workflow}.
#'   \item Checks the disablement status through two independent
#'         mechanisms:
#'     \itemize{
#'       \item Explicit disablement via the \code{disables} parameter
#'             passed to this function.
#'       \item The module's own \code{disable} property, which may have
#'             been set by upstream modules to short-circuit downstream
#'             execution.
#'     }
#'   \item Executes non-disabled modules by invoking
#'         \code{\link{.internal_call}} with the module definition and
#'         the workflow context.
#'   \item Produces verbose logging when
#'         \code{options(verbose = TRUE)} is set, including the list of
#'         disabled modules and the configuration values.
#' }
#'
#' The workflow context is modified in-place by each module execution,
#' which allows downstream modules to consume results produced by their
#' upstream predecessors.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is the
#' execution of the workflow modules and the in-place modification of the
#' workflow context object.
#'
#' @note
#' This is an internal function and is not intended to be called directly
#' by users. Modules may control the execution of subsequent modules by
#' setting their own \code{disable} property to \code{TRUE} at runtime.
#'
#' @keywords internal
#' @seealso \code{\link{.internal_call}} for the module execution logic,
#'   \code{\link{run}} for the public entry point of the workflow engine.
#'
const __runImpl = function(context, disables = list()) {
    let app_pool = context$workflow;
    let skip = FALSE;
    let verbose = as.logical(getOption("verbose"));

    if (verbose) {
        print("view module configs:");
        str(disables);
    }

    # the pipeline data slot defines the workflow module
    # execute sequence.
    #
    # get a specific workflow analysis app module, and then
    # execute the module under a given workflow context
    for(let app_name in context$pipeline) {
        let app  = app_pool[[app_name]];
        let skip = FALSE;

        if (is.null(app$name)) {
            throw_err(`missing app module definition object for '${app_name}', please check of the app function has been hooked or not?`);
        }

        if (app$name in disables) {
            if (as.logical(disables[[app$name]])) {
                skip = TRUE;
            }
        } else {
            if("disable" in app) {
                # current app module may be disable by other
                # application from the workflow upsteam
                skip = app$disable;
            }
        }

        if (!skip) {
            .internal_call(app, context);
        } else {
            if (verbose) {
                print(`skip '${app$name}'!`);
            }
        }

        NULL;
    }

    invisible(NULL);
}
