#' This function should be call at first
#'
#' @param outputdir the directory path to the workflow analysis workspace,
#'    default path value is current directory.
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' 
#' @return this function has no return value. and the constructed 
#'   analysis environment context object will be saved in the 
#'   global environment with symbol name ``&[workflow_render]``.
#' 
#' @details for construct of the runtime environment, the generated 
#'   context environment for run the analysis workflow has member 
#'   slots of:
#'
#'   1. root: a character vector for the ``outputdir`` directory path.
#'   2. analysis: a character vector for the directory path that 
#'                contains the analysis result output from current 
#'                workflow process.
#'   3. temp_dir: a character vector for the directory path that 
#'                contains the analysis temp files from current 
#'                workflow process.
#'   4. t0: a date time stamp when start current analysis workflow.
#'   5. workflow: a tuple list object that contains the analysis 
#'                application object that constructed from the 
#'                ``app`` function. 
#'   6. pipeline: a character vector for run the application workflow.
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

    sink(file = `${temp_dir}/run_analysis-${get_timestamp()}.log`);
    set(globalenv(), paste([__global_ctx,ssid], sep = "-"), context);

    invisible(NULL);
}

#' create an in-memory context object just used for run debug
#' 
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' @param mounts should be a callable function for mounts the 
#'    application modules into the workflow registry.
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

#' get current workflow environment context
#' 
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' 
#' @return the context object which is generated via the 
#'    ``init_context`` function.
#'
const .get_context = function(ssid = NULL) {
    const workflow_render as string = paste([__global_ctx, ssid], sep = "-");

    if (exists(workflow_render, globalenv())) {
        get(workflow_render, globalenv());
    } else {
        .Internal::stop("You must initialize the analysis context at first!");
    }
}