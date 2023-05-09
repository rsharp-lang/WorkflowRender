#' Call this function to start run workflow
#' 
#' @param registry a callable function for create the workflow registry, 
#'    this parameter could be nothing if this workflow processor apps has
#'    been registered into the workflow as the processor components via 
#'    the ``hook`` function.
#'
const run = function(registry = NULL) {
    if (!is.null(registry)) {
        do.call(registry, args = list());
    }

    __runImpl(context = .get_context());
}

#' An internal function for start the workflow
#'
const __runImpl = function(context) {
    let app_pool = context$workflow;
    let t0    = NULL;
    let argv  = NULL;
    let dependency = NULL;

    for(app in context$pipeline) {
        t0 = now();
        app = app_pool[[app]];
        argv = {
            app: app, 
            context: context
        };

        # check of the app dependency
        dependency = check_dependency(app);

        if (dependency$check) {
            # check success, then
            # run current data analysis node
            do.call(app$call, args = argv);
        } else {
            # stop the workflow
            const context_err = "";
            const file_err = "";
            const msg_err = "";

            throw_err([msg_err, context_err, file_err]);
        }
        
        app$profiler = {
            time: time_span(now() - t0)
        };
    }
}