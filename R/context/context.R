#' This function should be call at first
#'
#' @param outputdir the directory path to the workflow analysis workspace,
#'    default path value is current directory.
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
const init_context = function(outputdir = "./") {
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
    set(globalenv(), __global_ctx, context);

    invisible(NULL);
}

const __global_ctx = "&[workflow_render]";

#' get current workflow environment context
#' 
const .get_context = function() {
    const workflow_render as string = __global_ctx;

    if (exists(workflow_render, globalenv())) {
        get(workflow_render, globalenv());
    } else {
        stop("You must initialize the analysis context at first!");
    }
}