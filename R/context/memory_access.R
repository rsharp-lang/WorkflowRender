#' Create an In-Memory Workflow Context for Debugging
#'
#' @description
#' Creates a lightweight in-memory workflow context object that is
#' intended for debugging and unit testing scenarios where no on-disk
#' workspace is required. All workspace directory paths of the created
#' context are set to \code{NULL}, and the optional \code{mounts}
#' callback can be used to register application modules into the
#' workflow registry immediately after the context is created.
#'
#' @param mounts an optional callable function that is invoked (with
#'   no arguments) after the in-memory context has been installed.
#'   This function is expected to mount the application modules into
#'   the workflow registry by calling \code{\link{hook}} for each
#'   module that should participate in the workflow.
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the installation of an in-memory workflow context object in the
#' global environment.
#'
#' @details
#' The created context has the same structure as the one produced by
#' \code{\link{init_context}}, but with all directory paths set to
#' \code{NULL}. This makes the function particularly useful for
#' dependency-graph analysis (see \code{\link{dependency_graph}}) and
#' for unit tests that do not need to touch the filesystem.
#'
#' @examples
#' \dontrun{
#' create_memory_context(function() {
#'   hook(my_analysis_module);
#' });
#' }
#'
#' @seealso \code{\link{init_context}}, \code{\link{.get_context}},
#'   \code{\link{hook}}, \code{\link{dependency_graph}}
#'
#' @author xieguigang
#'
const create_memory_context = function(mounts = NULL,ssid = NULL) {
    set(globalenv(), paste( [__global_ctx,ssid], sep ="-"), list(
        root     = NULL,  # set all workspace to empty
        analysis = NULL,
        temp_dir = NULL,
        t0       = now(),
        workflow = list(),
        pipeline = [],
        symbols  = list()
    ));

    if (!is.null(mounts)) {
        mounts();
    }
}

const __global_ctx = "&[workflow_render]";

#' Get the Current Workflow Environment Context
#'
#' @description
#' Retrieves the workflow context object that was previously installed
#' by \code{\link{init_context}} or \code{\link{create_memory_context}}.
#' The context is looked up from the global environment using a symbol
#' name composed from \code{__global_ctx} and the supplied session
#' identifier.
#'
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#'
#' @return
#' The workflow context object that was generated via the
#' \code{\link{init_context}} function (or its in-memory counterpart
#' \code{\link{create_memory_context}}).
#'
#' @details
#' When the requested context cannot be found in the global
#' environment, the function aborts the workflow with an error
#' message instructing the user to initialize the analysis context
#' first. This makes the function a safe accessor that can be called
#' from any other workflow function without additional null checks.
#'
#' @examples
#' \dontrun{
#' ctx <- .get_context();
#' print(ctx$pipeline);
#' }
#'
#' @seealso \code{\link{init_context}},
#'   \code{\link{create_memory_context}}
#'
#' @author xieguigang
#'
const .get_context = function(ssid = NULL) {
    const workflow_render as string = paste([__global_ctx, ssid], sep = "-");

    if (exists(workflow_render, globalenv())) {
        get(workflow_render, globalenv());
    } else {
        .Internal::stop("You must initialize the analysis context at first!");
    }
}
