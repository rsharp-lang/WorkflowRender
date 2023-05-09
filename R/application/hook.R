#' Add workflow app component into the registry
#'
const hook = function(app) {
    const context = .get_context();
    const pool = context$workflow;

    pool[[app$name]] = app;
    # turn on/activate current analysis app by default
    context$pipeline = append(context$pool, app$name);

    set(globalenv(), "&[workflow_render]", context);

    invisible(NULL);
}