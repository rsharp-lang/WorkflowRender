#' Mark end of the analysis workflow
#' 
#' @details release the resources of the pipeline workflow modules
#' 
const finalize = function() {
    # saveRDS(.get_context(), file = `${.get_context()$root}/.workflow.rds`);

    print("workflow finalize, ");
    print(`*** Elapsed time '${time_span(now() - .get_context()$t0)}' ***`);

    # unload the workflow context environment
    rm(list = __global_ctx);

    sink();
}