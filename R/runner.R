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
    let verbose = as.logical(getOption("verbose"));

    if (dependency$check) {
        if (verbose) {
            print(`  * exec: ${app$name}...`);
        }

        # check success, then
        # run current data analysis node
        do.call(app$call, args = argv);

        if (verbose) {
            print(`done ~ '${app$name}' ...... ${time_span(now() - t0)}`);
        }
    } else {
        # stop the workflow
        const context_err = dependency.context_env_missing(dependency$context);
        const file_err    = dependency.workfiles_missing(dependency$file);
        const msg_err = [
            "There are some dependency of current analysis application is not satisfied:",
            paste(c("analysis_app:", app$name), sep = " ")
        ];

        throw_err([msg_err, context_err, file_err]);
    }

    app$profiler = {
        time: time_span(now() - t0)
    };

    invisible(NULL);
}
