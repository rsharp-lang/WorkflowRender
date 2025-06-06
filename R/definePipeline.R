#' Create a custom pipeline workflow execute sequence
#' 
#' @param seq a character vector of the app module names inside the workflow.
#' 
const definePipeline = function(seq) {
    const ctx = .get_context();
    const ssid = NULL;

    ctx$pipeline = seq;
    # update the global context symbol
    set(globalenv(), paste([__global_ctx,ssid],sep ="-"), ctx);

    invisible(NULL);
}