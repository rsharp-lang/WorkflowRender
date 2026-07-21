#' Set User Parameters in the Workflow Context
#'
#' @description
#' Stores one or more user-supplied parameter values into the
#' \code{configs} slot of the workflow context. The stored values can
#' later be retrieved at runtime by the workflow modules via the
#' \code{\link{get_config}} function.
#'
#' @param configs a key-value pair tuple list object that contains the
#'   workflow parameter values. The element names of the list are used
#'   as the parameter names, and the corresponding element values are
#'   stored as the parameter values.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the modification of the \code{configs} slot of the workflow context
#' stored in the global environment.
#'
#' @details
#' The function lazily creates the \code{configs} slot of the workflow
#' context when it does not yet exist, and then iterates over the
#' supplied \code{configs} list to merge each key-value pair into the
#' existing configuration. When a value of \code{NULL} is supplied
#' for a given key, a warning is emitted via \code{\link{echo_warning}}
#' because setting a list element to \code{NULL} in R# is interpreted
#' as deleting that element, which is rarely the intended behavior.
#'
#' @examples
#' \dontrun{
#' WorkflowRender::set_config(list(arg1 = "xxx", arg2 = "xxx"));
#' }
#'
#' @seealso \code{\link{get_config}}, \code{\link{pull_configs}},
#'   \code{\link{echo_warning}}, \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const set_config = function(configs = list()) {
    let val = NULL;
    let ctx = .get_context();
    let cfg = {
        if (!("configs" in ctx)) {
            ctx$configs = list();
        }

        ctx$configs;
    }

    for(name in names(configs)) {
        val <- configs[[name]];
        cfg[[name]] <- val;

        if (is.null(val)) {
            # list set NULL means delete element
            # add warning at here
            echo_warning(`the config value of '${name}' is nothing!`);
        }
    }

    invisible(NULL);
}

