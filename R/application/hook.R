#' Add workflow app component into the registry
#'
const hook = function(app) {
    const context = .get_context();
    const pool = context$workflow;

    if (!app_check.signature(app)) {
        throw_err([
            "invalid app object signature", 
            "you sould construct the app module via the 'app' function!"
        ]);
    } else {
        pool[[app$name]] = app;
    }

    # turn on/activate current analysis app by default
    context$pipeline = append(context$pipeline, app$name);
    # update the global context symbol
    set(globalenv(), __global_ctx, context);

    invisible(NULL);
}