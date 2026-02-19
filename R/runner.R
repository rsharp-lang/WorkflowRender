
#' Internal Workflow Execution Engine
#' 
#' @description 
#' An internal function that drives the execution of a modular workflow. 
#' It sequentially processes analysis modules according to the pipeline 
#' configuration while respecting disablement rules.
#'
#' @param context A workflow context object containing:
#' \itemize{
#'   \item{pipeline - character vector of module execution order}
#'   \item{workflow - list of module definitions}
#' }
#' @param disables A named list specifying module disablement status. 
#' Format: `list(module_name = TRUE/FALSE)`. Modules with TRUE will be skipped.
#' 
#' @details
#' This function:
#' \enumerate{
#'   \item Retrieves module execution order from `context$pipeline`
#'   \item Checks disablement status through two mechanisms:
#'     \itemize{
#'       \item Explicit disablement via `disables` parameter
#'       \item Module's own `disable` property (set by upstream modules)
#'     }
#'   \item Executes non-disabled modules using `.internal_call()`
#'   \item Provides verbose logging when `options(verbose=TRUE)`
#' }
#' 
#' The workflow context is modified in-place by module execution.
#'
#' @note
#' This is an internal function not meant for direct calling by users. 
#' Modules can control subsequent module execution by setting their 
#' `disable` property.
#' 
#' @return
#' Invisibly returns NULL. Modifies the workflow context object in-place
#' through module executions.
#'
#' @keywords internal
#' @seealso \code{\link{.internal_call}} for module execution logic
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