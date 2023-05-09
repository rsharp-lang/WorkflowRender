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
    
    for(app in context$pipeline) {
        .internal_call(app = app_pool[[app]], context);       
    }
}

#' Invoke an analysis application
#' 
const .internal_call = function(app, context) {
    # check of the app dependency
    let dependency = check_dependency(app, context);
    let t0   = now();
    let argv = {
        app: app, 
        context: context
    };

    if (dependency$check) {
        # check success, then
        # run current data analysis node
        do.call(app$call, args = argv);
    } else {
        # stop the workflow
        const context_err = dependency.context_env_missing(dependency$context);
        const file_err = dependency.workfiles_missing(dependency$file);
        const msg_err = [
            "There are some dependency of current analysis application is not satisfied:", 
            paste(c("analysis_app:", app$name))
        ];

        throw_err([msg_err, context_err, file_err]);
    }
    
    app$profiler = {
        time: time_span(now() - t0)
    };
}

const dependency.context_env_missing = function(context) {
    if (is.null(context) || length(context) == 0) {
        "there is no runtime environment required context symbol is missing.";
    } else {
        paste([
            `there are ${length(context)} required context symbol is missing or data type is mis-matched in the workflow:`,
            JSON::json_encode(context)
        ]);
    }
}

const dependency.workfiles_missing = function(file) {
    if (is.null(file) || length(file) == 0) {
        "there is no required workspace tempfile is missing in current workflow.";
    } else {
        paste([
            `there are ${length(file)} required workspace tempfile is missing in the work directory:`,
            paste(file, "; ")
        ]);
    }
}