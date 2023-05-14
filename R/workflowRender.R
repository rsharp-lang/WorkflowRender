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
const run = function(registry = NULL, disables = list()) {
    if (!is.null(registry)) {
        do.call(registry, args = list());
    }

    __runImpl(context = .get_context(), disables);
}

#' An internal function for start the workflow
#'
const __runImpl = function(context, disables = list()) {
    let app_pool = context$workflow;
    let skip = FALSE;

    for(app in context$pipeline) {
        app = app_pool[[app]];
        skip = FALSE;

        if (app$name in disables) {
            if (as.logical(disables[[app$name]])) {
                skip = TRUE;
            }
        } else if("disable" in app) {
            # current app module may be disable by other
            # application from the workflow upsteam
            skip = app$disable;
        }

        if (!skip) {
            .internal_call(app, context);
        }
    }

    invisible(NULL);
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
        const file_err    = dependency.workfiles_missing(dependency$file);
        const msg_err = [
            "There are some dependency of current analysis application is not satisfied:",
            paste(c("analysis_app:", app$name))
        ];

        throw_err([msg_err, context_err, file_err]);
    }

    app$profiler = {
        time: time_span(now() - t0)
    };

    invisible(NULL);
}

#' Generate the error message for missing context symbols
#'
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

#' Generate the error message for the missing required work files
#'
const dependency.workfiles_missing = function(file) {
    if (is.null(file) || length(file) == 0) {
        "there is no required workspace tempfile is missing in current workflow.";
    } else {
        file = file
        |> names
        |> sapply(app -> `${app}: ${paste(file[[app]], " and ")}`)
        |> paste("; ")
        ;

        paste([`there are ${length(file)} required workspace tempfile is missing in the work directory:`, file]);
    }
}