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