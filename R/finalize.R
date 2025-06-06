#' Mark end of the analysis workflow
#' 
#' @details this function used for unload a specific workflow environment
#' 
#' @param ssid the session id for the multiple user environment,default NULL means global session environment
#' @details release the resources of the pipeline workflow modules
#' 
const finalize = function(ssid=NULL) {
    # saveRDS(.get_context(), file = `${.get_context()$root}/.workflow.rds`);

    print("workflow finalize, ");
    print(`*** Elapsed time '${time_span(now() - .get_context()$t0)}' ***`);

    # unload the workflow context environment
    rm(list = paste([__global_ctx,ssid], sep="-"));

    sink();
}