require(JSON);

#' Inspect the workflow analysis modules
#' 
const summary = function() {
    const context = .get_context();
    const pool    = context$workflow;
    const seq     = context$pipeline;

    print("Workflow exec modules sequence:");
    print(seq |> which(i -> ![(pool[[i]])$disable]) |> paste(sep = " -> "));

    cat("\n");
    cat("\n");

    print("View summary of all available analysis modules:");
    print(pool |> tabulate_workflow_summary());

    invisible(NULL);
}

#' Extract the workflow analysis contents
#' 
#' @return a dataframe object that contains the workflow analysis 
#'   modules information, example as the reference name, description, 
#'   dependency information, etc.
#' 
const tabulate_workflow_summary = function(pool) {
    const names   = pool@name;
    const description = pool@desc;
    const dependency  = pool@dependency;
    const deps.env    = dependency@context_env;
    const deps.workfiles = dependency@tempfiles;
    const disable     = pool@disable;

    data.frame(
        appName = names, 
        description = description, 
        "dependency.env" = sapply(deps.env, i -> JSON::json_encode(i)),
        "dependency.workfiles" = sapply(deps.workfiles, i -> JSON::json_encode(i)), 
        disable = disable,
        row.names = `#${1:length(pool)}`
    )
}