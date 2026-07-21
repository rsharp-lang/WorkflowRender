require(JSON);

#' Inspect the Workflow Analysis Modules
#'
#' @description
#' Prints a human-readable summary of the workflow analysis modules
#' that have been registered in the current workflow context. The
#' summary includes the execution sequence of the active modules as
#' well as a tabulated overview of all available modules with their
#' description and dependency information.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the printing of the workflow summary to the standard output.
#'
#' @details
#' The function performs two main actions:
#' \enumerate{
#'   \item Prints the execution sequence of the modules that are
#'     currently active (i.e. not disabled) in the workflow pipeline.
#'     The module names are joined by the \code{ -> } separator to
#'     make the execution order easy to read.
#'   \item Prints a tabulated overview of all registered analysis
#'     modules via \code{\link{tabulate_workflow_summary}}. The
#'     overview includes the application name, description, dependency
#'     information and disable flag of each module.
#' }
#'
#' @examples
#' \dontrun{
#' WorkflowRender::init_context("/path/to/workdir/");
#' hook(app("demo", function(app, context) { print("hi"); }));
#' summary();
#' }
#'
#' @seealso \code{\link{tabulate_workflow_summary}},
#'   \code{\link{.get_context}}, \code{\link{hook}}
#'
#' @author xieguigang
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

#' Extract the Workflow Analysis Contents as a Data Frame
#'
#' @description
#' Builds a data frame object that summarizes the workflow analysis
#' modules contained in the supplied module pool. The data frame is
#' intended to be printed by \code{\link{summary}} for human
#' inspection of the registered modules.
#'
#' @param pool a named list of analysis application objects, as
#'   stored in the \code{workflow} slot of the workflow context.
#'
#' @return
#' A data frame object that contains the workflow analysis modules
#' information. The columns of the data frame are:
#' \describe{
#'   \item{\code{appName}}{the name of the analysis application.}
#'   \item{\code{description}}{the human-readable description of the
#'     application.}
#'   \item{\code{dependency.env}}{a JSON-encoded representation of
#'     the environment symbol dependency declaration.}
#'   \item{\code{dependency.workfiles}}{a JSON-encoded representation
#'     of the workspace file dependency declaration.}
#'   \item{\code{disable}}{a logical flag that indicates whether the
#'     module is disabled.}
#' }
#' The row names of the data frame are set to \code{#1}, \code{#2},
#' \dots to provide a stable index for each module.
#'
#' @details
#' The dependency information of each module is JSON-encoded via
#' \code{JSON::json_encode} so that the complex nested list structure
#' of the dependency declaration can be displayed in a compact form
#' inside a single data frame cell.
#'
#' @examples
#' \dontrun{
#' pool <- .get_context()$workflow;
#' df <- tabulate_workflow_summary(pool);
#' print(df);
#' }
#'
#' @seealso \code{\link{summary}}, \code{\link{.get_context}}
#'
#' @author xieguigang
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
