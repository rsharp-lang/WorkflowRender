#' Invoke an Analysis Application (Internal Function)
#'
#' @title Invoke an Analysis Application (Internal Function)
#'
#' @description
#' This internal function executes a single analysis application after
#' validating its declared dependencies. It is responsible for application
#' invocation, error reporting on missing dependencies, and performance
#' profiling of the executed module.
#'
#' @param app A list defining the analysis application. The following
#'   slots are expected to be present:
#'   \describe{
#'     \item{\code{name}}{(character) Name of the application, used for
#'       logging and error reporting.}
#'     \item{\code{call}}{(function) The function that implements the
#'       application logic. It must accept two parameters named
#'       \code{app} and \code{context}.}
#'     \item{\code{profiler}}{(list) A slot used to store performance
#'       metrics, such as the total execution time of the module.}
#'   }
#' @param context A list or environment providing the runtime context,
#'   such as input data paths, environment variables, or configuration
#'   settings required by the application. This is the workflow context
#'   object created by \code{\link{init_context}}.
#'
#' @return
#' Invisibly returns \code{NULL}. The function primarily updates
#' \code{app$profiler} with execution time metrics and may modify the
#' \code{context} object during execution as a side effect of running
#' the application.
#'
#' @details
#' The function performs the following steps in order:
#' \enumerate{
#'   \item \strong{Dependency Check}: Validates whether the required
#'     context variables and workspace files exist via
#'     \code{\link{check_dependency}}.
#'     \itemize{
#'       \item If all dependencies are satisfied, the function proceeds
#'         to execute the application.
#'       \item If any dependency is missing, an error is thrown with a
#'         detailed report of the missing resources.
#'     }
#'   \item \strong{Execution}:
#'     \itemize{
#'       \item Logs the start and end timestamps when
#'         \code{options(verbose = TRUE)} is set.
#'       \item Executes \code{app$call} with arguments \code{app} and
#'         \code{context} using \code{do.call()}.
#'     }
#'   \item \strong{Error Handling}:
#'     \itemize{
#'       \item Aggregates missing dependencies into a human-readable
#'         error message.
#'       \item Calls \code{\link{throw_err}} to terminate the workflow
#'         and report the issues to the user.
#'     }
#'   \item \strong{Profiling}:
#'     Records the total execution time in \code{app$profiler$time}
#'     using \code{\link{time_span}} for human-readable formatting.
#' }
#'
#' @examples
#' \dontrun{
#' # Define a sample application
#' app <- list(
#'   name = "demo_analysis",
#'   call = function(app, context) {
#'     print(paste("Running:", app$name))
#'   },
#'   profiler = list()
#' )
#'
#' # Execute with context
#' .internal_call(app, context = list())
#' }
#'
#' @note
#' This is an internal function and is not intended for direct use by
#' end users. The error messages produced by this function include:
#' \itemize{
#'   \item Missing context variables, reported via
#'     \code{\link{dependency.context_env_missing}}.
#'   \item Missing workspace files, reported via
#'     \code{\link{dependency.workfiles_missing}}.
#' }
#'
#' @keywords internal
#' @seealso \code{\link{check_dependency}}, \code{\link{throw_err}},
#'   \code{\link{time_span}}, \code{\link{__runImpl}}
#'
const .internal_call = function(app, context) {
    # check of the app dependency
    let dependency = check_dependency(app, context);
    let t0   = now();
    let argv = {
        app: app,
        context: context
    };
    let verbose = as.logical(getOption("verbose"));

    if (dependency$check) {
        if (verbose) {
            print(`  * exec: ${app$name}...`);
        }

        # check success, then
        # run current data analysis node
        do.call(app$call, args = argv);

        if (verbose) {
            print(`done ~ '${app$name}' ...... ${time_span(now() - t0)}`);
        }
    } else {
        # stop the workflow
        const context_err = dependency.context_env_missing(dependency$context);
        const file_err    = dependency.workfiles_missing(dependency$file);
        const msg_err = [
            "There are some dependency of current analysis application is not satisfied:",
            paste(c("analysis_app:", app$name), sep = " ")
        ];

        throw_err([msg_err, context_err, file_err]);
    }

    app$profiler = {
        time: time_span(now() - t0)
    };

    invisible(NULL);
}
