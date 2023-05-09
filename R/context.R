#' This function should be call at first
#'
#' @param outputdir the directory path to the workflow analysis workspace,
#'    default path value is current directory.
#' 
#' @details for construct of the runtime environment
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

    sink(file = `${temp_dir}/run_analysis-${toString(now(), "yyyy-MM-dd hh-mm-ss")}.log`);

    set(globalenv(), "&[workflow_render]", context);
}

#' Mark end of the analysis workflow
#' 
#' @details release the resources of the pipeline workflow modules
#' 
const finalize = function() {
    print("workflow finalize, ");
    print(`*** Elapsed time '${time_span(now() - .get_context()$t0)}' ***`);
    sink();
}

const .get_context = function() {
    const workflow_render = "&[workflow_render]";

    if (exists(workflow_render, globalenv())) {
        get(workflow_render, globalenv());
    } else {
        stop("You must initialize the analysis context at first!");
    }
}

#' Add workflow app component into the registry
#'
const hook = function(app) {
    const context = .get_context();
    const pool = context$workflow;

    pool[[app$name]] = app;
    context$pipeline = append(context$pool, app$name);

    set(globalenv(), "&[workflow_render]", context);
}