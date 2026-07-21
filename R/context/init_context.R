#' Initialize the Workflow Analysis Context
#'
#' @description
#' This function should be called first before any other workflow
#' operation. It constructs the runtime environment context object
#' that holds the workspace directory paths, the start timestamp, the
#' registered workflow modules, the pipeline execution sequence and
#' the user-supplied configuration values. The constructed context is
#' stored in the global environment so that it can be accessed by all
#' subsequent workflow functions.
#'
#' @param outputdir the directory path to the workflow analysis
#'   workspace. The default value of \code{"./"} refers to the current
#'   working directory. Two sub-directories \code{analysis/} and
#'   \code{tmp/} will be created inside this directory to hold the
#'   analysis result output and the temporary files respectively.
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment. When a non-null value is supplied, the
#'   context is stored under a session-specific symbol name so that
#'   multiple users can run workflows concurrently without interfering
#'   with each other.
#'
#' @return
#' This function has no return value. The constructed analysis
#' environment context object is saved in the global environment with
#' the symbol name \code{`&[workflow_render]`} (or a session-specific
#' variant thereof).
#'
#' @details
#' For the construction of the runtime environment, the generated
#' context object for running the analysis workflow has the following
#' member slots:
#'
#' \enumerate{
#'   \item \code{root}: a character vector for the \code{outputdir}
#'     directory path, normalized to an absolute path.
#'   \item \code{analysis}: a character vector for the directory path
#'     that contains the analysis result output from the current
#'     workflow process.
#'   \item \code{temp_dir}: a character vector for the directory path
#'     that contains the analysis temporary files from the current
#'     workflow process.
#'   \item \code{t0}: a date-time stamp that records when the current
#'     analysis workflow was started. Used by \code{\link{finalize}}
#'     to compute the total elapsed time.
#'   \item \code{workflow}: a named list object that contains the
#'     analysis application objects constructed from the \code{\link{app}}
#'     function or registered via \code{\link{hook}}.
#'   \item \code{pipeline}: a character vector that defines the
#'     execution order of the application modules in the workflow.
#'   \item \code{symbols}: a named list that maps analysis function
#'     names to their registered application module names, used by
#'     \code{\link{get_appName.func_reference}}.
#' }
#'
#' In addition to constructing the context, this function opens a log
#' file inside \code{<temp_dir>/logs/} via \code{sink()} so that all
#' subsequent console output is also captured to disk for later
#' inspection.
#'
#' @examples
#' \dontrun{
#' WorkflowRender::init_context("/path/to/workdir/");
#' }
#'
#' @seealso \code{\link{finalize}}, \code{\link{.get_context}},
#'   \code{\link{set_config}}, \code{\link{hook}}, \code{\link{run}}
#'
#' @author xieguigang
#'
const init_context = function(outputdir = "./", ssid = NULL) {
    const analysis_output = normalizePath(`${outputdir}/analysis/`);
    const temp_dir = normalizePath(`${outputdir}/tmp/`);
    const context = list(
        root     = normalizePath(outputdir),
        analysis = analysis_output,
        temp_dir = temp_dir,
        t0       = now(),
        workflow = list(),
        pipeline = [],
        symbols  = list()
    );

    sink(file = `${temp_dir}/logs/run_analysis-${get_timestamp()}.log`);
    set(globalenv(), paste([__global_ctx,ssid], sep = "-"), context);

    invisible(NULL);
}

