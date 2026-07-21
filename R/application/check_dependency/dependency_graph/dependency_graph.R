#' Build the Dependency Graph of the Workflow Modules
#'
#' @description
#' Constructs an \code{igraph} object that represents the dependency
#' relationships between the analysis application modules registered
#' in the workflow. Each vertex of the graph corresponds to an
#' application module and each edge represents a file dependency
#' from a consumer module to its producing module.
#'
#' @param pool a named list of analysis application objects, as
#'   stored in the \code{workflow} slot of the workflow context.
#'
#' @return
#' An \code{igraph} object that represents the dependency graph of
#' the supplied workflow modules. The vertex names of the graph are
#' the application names, and each edge is directed from a consumer
#' module to its producing module.
#'
#' @details
#' The function iterates over the supplied \code{pool} of
#' application modules and inspects the \code{tempfiles} slot of
#' each module's dependency declaration. For each required file, an
#' edge is added from the consumer module to the producing module.
#'
#' The resulting graph can be used to detect circular references,
#' missing producers, or unreachable modules via the standard
#' \code{igraph} functions. The graph is also used by
#' \code{\link{dependency_analysis}} to produce a comprehensive
#' report of the workflow structure.
#'
#' @examples
#' \dontrun{
#' pool <- .get_context()$workflow;
#' g <- dependency_graph(pool);
#' plot(g);
#' }
#'
#' @seealso \code{\link{dependency_analysis}},
#'   \code{\link{extract_workflow_vertex}}, \code{\link{set_dependency}}
#'
#' @author xieguigang
#'
const dependency_graph = function(pool) {
    let edges = list();
    let vertices = names(pool);

    for(app_name in names(pool)) {
        const dep = pool[[app_name]]$dependency;

        if (!is.null(dep) && "tempfiles" in dep) {
            for(producer in names(dep$tempfiles)) {
                edges[[length(edges) + 1]] = c(app_name, producer);
            }
        }
    }

    if (length(edges) == 0) {
        igraph::make_empty_graph(n = length(vertices), directed = TRUE) |>
            igraph::set_vertex_attr("name", value = vertices);
    } else {
        edges <- do.call(rbind, edges);
        igraph::graph_from_edgelist(edges, directed = TRUE) |>
            igraph::set_vertex_attr("name", value = vertices);
    }
}
