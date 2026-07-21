#' Analyze the Dependency Graph of the Workflow Modules
#'
#' @description
#' Builds a dependency graph of all analysis application modules that
#' have been registered in the current workflow context and analyzes
#' the graph to detect potential issues such as missing dependencies,
#' circular references, or unreachable modules. The function is
#' primarily intended for debugging and for producing a visual
#' overview of the workflow structure.
#'
#' @param verbose a logical value that controls whether diagnostic
#'   information about the dependency analysis should be printed.
#'   The default value of \code{FALSE} suppresses the output. When
#'   \code{options(verbose = TRUE)} is set, the function always
#'   behaves as if \code{verbose = TRUE}.
#'
#' @return
#' A named list object that contains the result of the dependency
#' analysis. The list contains the following elements:
#' \describe{
#'   \item{\code{graph}}{an \code{igraph} object that represents the
#'     dependency graph of the workflow modules. Each vertex
#'     corresponds to an application module and each edge represents
#'     a file dependency from one module to another.}
#'   \item{\code{vertices}}{a data frame that describes the vertices
#'     of the dependency graph, as produced by
#'     \code{\link{extract_workflow_vertex}}.}
#'   \item{\code{issues}}{a list of detected issues, such as missing
#'     dependencies or circular references.}
#' }
#'
#' @details
#' The function performs the following steps:
#' \enumerate{
#'   \item Retrieves the workflow context via \code{\link{.get_context}}
#'     and collects the dependency declarations of all registered
#'     application modules.
#'   \item Builds a dependency graph via \code{\link{dependency_graph}}
#'     in which each vertex represents an application module and each
#'     edge represents a file dependency from a consumer module to
#'     its producing module.
#'   \item Extracts the vertex information via
#'     \code{\link{extract_workflow_vertex}} for downstream
#'     inspection.
#'   \item Analyzes the graph for potential issues such as missing
#'     dependencies, circular references, or unreachable modules.
#' }
#'
#' When \code{verbose} is \code{TRUE}, the function prints the
#' dependency graph and the detected issues to the standard output
#' for debugging purposes.
#'
#' @examples
#' \dontrun{
#' WorkflowRender::init_context("/path/to/workdir/");
#' hook(app("demo", function(app, context) { print("hi"); }));
#' result <- dependency_analysis();
#' print(result$graph);
#' }
#'
#' @seealso \code{\link{dependency_graph}},
#'   \code{\link{extract_workflow_vertex}}, \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const dependency_analysis = function(verbose = FALSE) {
    const verboseOpt = as.logical(getOption("verbose", default = verbose));
    const context    = .get_context();
    const pool       = context$workflow;
    const graph      = dependency_graph(pool);

    let issues = list();

    # check for missing dependencies
    for(app_name in names(pool)) {
        const dep = pool[[app_name]]$dependency;

        if (!is.null(dep) && "tempfiles" in dep) {
            for(producer in names(dep$tempfiles)) {
                if (!(producer in pool)) {
                    issues[[length(issues) + 1]] = list(
                        type = "missing_producer",
                        consumer = app_name,
                        producer = producer
                    );
                }
            }
        }
    }

    # check for circular references
    if (length(issues) == 0) {
        const cycles = graph |> igraph::cycles();

        if (length(cycles) > 0) {
            issues[[length(issues) + 1]] = list(
                type = "circular_reference",
                cycles = cycles
            );
        }
    }

    if (verboseOpt) {
        print("dependency graph:");
        print(graph);
        print("detected issues:");
        str(issues);
    }

    list(
        graph     = graph,
        vertices  = extract_workflow_vertex(graph),
        issues    = issues
    );
}
