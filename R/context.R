#' This function should be call at first
#' 
const init_context = function(outputdir = "./") {
    const analysis_output = normalizePath(`${outputdir}/analysis/`);
    const temp_dir = normalizePath(`${outputdir}/tmp/`);
    const context = list(
        root = normalizePath(outputdir),
        analysis = analysis_output,
        temp_dir = temp_dir,
        t0 = now(),
        workflow = list(),
        pipeline = []
    );

    set(globalenv(), "&[workflow_render]", context);
}

const .get_context = function() {
    get("&[workflow_render]", globalenv());
}

const hook = function(app) {
    const context = .get_context();
    const pool = context$workflow;

    pool[[app$name]] = app;
    context$pipeline = append(context$pool, app$name);

    set(globalenv(), "&[workflow_render]", context);
}