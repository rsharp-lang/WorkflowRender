#' Create a custom pipeline workflow execute sequence
#' 
const definePipeline = function(seq) {
    const ctx = .get_context();
    ctx$pipeline = seq;
    # update the global context symbol
    set(globalenv(), __global_ctx, ctx);

    invisible(NULL);
}