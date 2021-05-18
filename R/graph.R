
#' Build graph from table content
#' 
#' @param table the edges list data in dataframe format.
#'    edges table of this parameter, that must contains at least two fields:
#'    ``from`` and ``to``; some edge property likes 
#'    ``weight``, ``type``, ``color``, ``width``, ``dash`` can be optional.
#' 
#' @param nodes the nodes property table
#' 
let buildGraph as function(table, nodes = NULL) {
    # create a new empty network graph
    const g    = igraph::empty.network();
    const from = table[, "from"];
    const to   = table[, "to"];


    g;
}