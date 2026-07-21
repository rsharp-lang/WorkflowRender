#' Mark the End of the Analysis Workflow
#'
#' @description
#' Finalizes the current workflow session by reporting the total elapsed
#' time, unloading the workflow context environment, and closing the log
#' file that was opened by \code{\link{init_context}}. This function
#' should be called as the last step of a workflow run to ensure that
#' all allocated resources are released cleanly.
#'
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the global
#'   session environment. When a non-null value is supplied, only the
#'   context associated with that session identifier is unloaded.
#'
#' @details
#' This function is used to unload a specific workflow environment. It
#' performs the following actions in order:
#' \enumerate{
#'   \item Prints a finalization banner together with the total elapsed
#'     time of the workflow, computed as the difference between the
#'     current time and the \code{t0} timestamp stored in the workflow
#'     context.
#'   \item Removes the workflow context object from the global
#'     environment. The symbol name of the context is composed from
#'     \code{__global_ctx} and the supplied \code{ssid}.
#'   \item Closes the log file connection that was opened by
#'     \code{\link{init_context}} via \code{sink()}, flushing any
#'     buffered messages to disk.
#' }
#'
#' Releasing the resources of the pipeline workflow modules in this way
#' avoids memory leaks across successive workflow runs and ensures that
#' log files are properly closed.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effects of this function are
#' the removal of the workflow context object from the global
#' environment and the closing of the active log file connection.
#'
#' @examples
#' \dontrun{
#' WorkflowRender::init_context("/path/to/workdir/");
#' # ... run workflow modules ...
#' WorkflowRender::run();
#' WorkflowRender::finalize();
#' }
#'
#' @seealso \code{\link{init_context}}, \code{\link{run}},
#'   \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const finalize = function(ssid=NULL) {
    # saveRDS(.get_context(), file = `${.get_context()$root}/.workflow.rds`);

    print("workflow finalize, ");
    print(`*** Elapsed time '${time_span(now() - .get_context()$t0)}' ***`);

    # unload the workflow context environment
    rm(list = paste([__global_ctx,ssid], sep="-"));

    sink();
}
