#' @title Invoke an Analysis Application (Internal Function)
#' 
#' @description 
#' This internal function executes an analysis application after validating its dependencies. 
#' It handles application execution, error reporting, and performance profiling.
#' 
#' @param app A list defining the analysis application. Must contain:
#'   - `name`: (character) Name of the application (for logging).
#'   - `call`: (function) The function to execute the application logic.
#'   - `profiler`: (list) Stores performance metrics (e.g., execution time).
#' @param context A list or environment providing runtime context, such as input data paths, 
#'   environment variables, or configuration settings required by the application.
#' 
#' @return Invisibly returns `NULL`. The function primarily updates `app$profiler` with execution 
#'   time metrics and may modify the `context` during execution.
#' 
#' @details
#' ### Key Steps:
#' 1. ​**Dependency Check**:  
#'    Validates if required context variables and files exist via `check_dependency(app, context)`.  
#'    - If dependencies are met, proceeds to execute the application.  
#'    - If dependencies are missing, throws an error with detailed missing resources.
#' 
#' 2. ​**Execution**:  
#'    - Logs start/end timestamps if `options(verbose = TRUE)`.  
#'    - Executes `app$call` with arguments `app` and `context` using `do.call()`.  
#' 
#' 3. ​**Error Handling**:  
#'    - Aggregates missing dependencies into readable error messages.  
#'    - Calls `throw_err()` to terminate the workflow and report issues.  
#' 
#' 4. ​**Profiling**:  
#'    Records total execution time in `app$profiler$time` using `time_span()` for human-readable formatting.
#' 
#' @examples
#' \dontrun{
#' # Define a sample application
#' app <- list(
#'   name = "demo_analysis",
#'   call = function(argv) {
#'     print(paste("Running:", argv$app$name))
#'   },
#'   profiler = list()
#' )
#' 
#' # Execute with context
#' .internal_call(app, context = list())
#' }
#' 
#' @note
#' - This is an internal function and not intended for direct use.  
#' - Error messages include:  
#'   - Missing context variables (e.g., `dependency$context_env_missing`).  
#'   - Missing files (e.g., `dependency$workfiles_missing`).  
#' 
#' @keywords internal
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
