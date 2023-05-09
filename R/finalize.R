#' Mark end of the analysis workflow
#' 
#' @details release the resources of the pipeline workflow modules
#' 
const finalize = function() {
    print("workflow finalize, ");
    print(`*** Elapsed time '${time_span(now() - .get_context()$t0)}' ***`);
    sink();
}