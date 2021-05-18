
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

    # create graph object at here:
    # create node tuples for each edge links
    # and then add into the graph object
    pushEdges(g, lapply(1:nrow(table), function(i) {
        [from[i], to[i]];
    }), 
        weight = table[, "weight"], 
        type   = table[, "type"]
    );

    # add edge styles at here:
    # set colors
    attributes(edges(g), "color") <- styleIndex(from, to, style = table[, "color"]);
    # set width
    attributes(edges(g), "width") <- styleIndex(from, to, style = table[, "width"]);
    # set dash or solid
    attributes(edges(g), "dash")  <- styleIndex(from, to, style = table[, "dash"]);

    # view of the network graph summary.
    print(g);

    g;
}

#' Create index list of the given styles data
#' 
#' @param from the node labels of the source node
#' @param to the node labels of the target node
#' @param style the one of kind styles data of the edges that specific by the source and target node.
#' 
let styleIndex as function(from, to, style = NULL) {
    if (is.null(style)) {
        NULL;
    } else {
        if (length(style) != length(from) || length(style) != length(to)) {
            stop("vector size is mis-matched!");
        } else {
            lapply(i:length(style), i -> style[i], names = i -> `${from[i]}..${to[i]}`);
        }
    }    
}