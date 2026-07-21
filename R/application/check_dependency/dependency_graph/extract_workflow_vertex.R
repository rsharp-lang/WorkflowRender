#' Extract the Vertex Information from a Workflow Dependency Graph
#'
#' @description
#' Extracts the vertex information from an \code{igraph} object that
#' represents the dependency graph of a workflow. The extracted
#' information is returned as a data frame that can be used for
#' downstream inspection or for rendering a visual overview of the
#' workflow structure.
#'
#' @param graph an \code{igraph} object that represents the
#'   dependency graph of a workflow, as produced by
#'   \code{\link{dependency_graph}}.
#'
#' @return
#' A data frame object that describes the vertices of the supplied
#' dependency graph. The columns of the data frame are:
#' \describe{
#'   \item{\code{name}}{the name of the application module.}
#'   \item{\code{in_degree}}{the number of modules that depend on
#'     this module (i.e. the number of incoming edges).}
#'   \item{\code{out_degree}}{the number of modules that this module
#'     depends on (i.e. the number of outgoing edges).}
#'   \item{\code{is_leaf}}{a logical flag that is \code{TRUE} when
#'     the module has no outgoing edges (i.e. it does not depend on
#'     any other module).}
#'   \item{\code{is_root}}{a logical flag that is \code{TRUE} when
#'     the module has no incoming edges (i.e. no other module
#'     depends on it).}
#' }
#'
#' @details
#' The function uses the standard \code{igraph} functions to extract
#' the vertex names and the in/out degree of each vertex. The
#' \code{is_leaf} and \code{is_root} flags are derived from the
#' degree information to make it easy to identify the entry points
#' and the terminal modules of the workflow.
#'
#' @examples
#' \dontrun{
#' pool <- .get_context()$workflow;
#' g <- dependency_graph(pool);
#' vertices <- extract_workflow_vertex(g);
#' print(vertices);
#' }
#'
#' @seealso \code{\link{dependency_graph}},
#'   \code{\link{dependency_analysis}}
#'
#' @author xieguigang
#'
const extract_workflow_vertex = function(graph) {
    const names       = igraph::V(graph)$name;
    const in_degree   = igraph::degree(graph, mode = "in");
    const out_degree  = igraph::degree(graph, mode = "out");

    data.frame(
        name        = names,
        in_degree   = in_degree,
        out_degree  = out_degree,
        is_leaf     = (out_degree == 0),
        is_root     = (in_degree  == 0),
        row.names   = names
    );
}
