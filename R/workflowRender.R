#' Call this function to start run workflow
#' 
#' @param registry a callable function for create the workflow registry, 
#'    this parameter could be nothing if this workflow processor apps has
#'    been registered into the workflow as the processor components via 
#'    the ``hook`` function.
#' @param disables a tuple list object that contains the workflow module
#'    activate swtches. the list tuple key name should be the analysis app
#'    name and the corresponding slot value should be a logical value for
#'    indicates that the workflow module is disable or not: true for disable 
#'    and skip, and false or null and missing for enable the corresponding
#'    workflow module
#' 
#' @details A workflow is consist with a set of the analysis modules in side,
#'    the executative sequence define in workflow is based on the module name
#'    vector in the pipeline data slot
#' 
const run = function(registry = NULL, disables = list()) {
    const verbose = as.logical(getOption("verbose"));

    if (!is.null(registry)) {
        do.call(registry, args = list());
    }

    if (verbose) {
        print("pipeline modules to run in current workflow:");
        print(.get_context()$pipeline);
        print("workflow parameters:");
        str(.get_context()$configs);
    }

    __runImpl(context = .get_context(), disables);
}

#' An internal function for start the workflow
#'
const __runImpl = function(context, disables = list()) {
    let app_pool = context$workflow;
    let skip = FALSE;
    let verbose = as.logical(getOption("verbose"));

    if (verbose) {
        print("view module configs:");
        str(disables);
    }

    # the pipeline data slot defines the workflow module
    # execute sequence.
    #
    # get a specific workflow analysis app module, and then
    # execute the module under a given workflow context
    for(app in context$pipeline) {
        app = app_pool[[app]];
        skip = FALSE;

        if (app$name in disables) {
            if (as.logical(disables[[app$name]])) {
                skip = TRUE;
            }
        } else {
            if("disable" in app) {
                # current app module may be disable by other
                # application from the workflow upsteam
                skip = app$disable;
            }
        }

        if (!skip) {
            .internal_call(app, context);
        } else {
            if (verbose) {
                print(`skip '${app$name}'!`);
            }            
        }

        NULL;
    }

    invisible(NULL);
}