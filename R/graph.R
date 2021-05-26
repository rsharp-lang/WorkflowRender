
#' Build graph from table content
#' 
#' @param table the edges list data in dataframe format.
#'    edges table of this parameter, that must contains at least two fields:
#'    ``from`` and ``to``; some edge property likes 
#'    ``weight``, ``type``, ``color``, ``width``, ``dash`` can be optional.
#' 
#' @return a network graph object
#' 
let buildGraph as function(table) {
    # create a new empty network graph
    const g    = igraph::empty.network();
    const from = table[, "from"];
    const to   = table[, "to"];    

    print(`build edges from ${length(from)} elements...`);

    # create graph object at here:
    # create node tuples for each edge links
    # and then add into the graph object
    g
    |> pushEdges(table ~ from + to, weight = table[, "weight"], type = table[, "type"])
    ;

    print("add edges styles...");

    # add edge styles at here:
    # set colors
    attributes(edges(g), "color") <- styleIndex(from, to, table, "color");
    # set width
    attributes(edges(g), "width") <- styleIndex(from, to, table, "width");
    # set dash or solid
    attributes(edges(g), "dash")  <- styleIndex(from, to, table, "dash");

    print("view of the network graph summary:"); 
    str(g);

    g;
}

#' Config of the nodes attributes in the graph
#' 
#' @param g the network graph
#' @param nodes the nodes property table, the row names of this table
#'    must be the node id in the graph object.
#' @param hasLayout if this parameter is TRUE, then it means the nodes layout
#'    data is already been in the ``nodes`` table, then we will apply the layout
#'    data from the nodes table rather than generates new layout from run 
#'    algorithm.
#' 
let setVertex as function(g, nodes, hasLayout = TRUE, algorithm = "edge_weighted") {
    const id = rownames(nodes);

    print("previews of the nodes table");
    print(head(nodes));

    print("set node groups...");

    for(uniqLabel in unique(nodes[, "group"])) {
        group(g, id[nodes[, "group"] == uniqLabel]) = uniqLabel;
    }

    print("set node style attributes...");

    attributes(vertex(g), "label") = nodes[, "label"];
    attributes(vertex(g), "color") = nodes[, "color"];
    attributes(vertex(g), "shape") = nodes[, "shape"];
    attributes(vertex(g), "size")  = nodes[, "size"];

    if (hasLayout) {
        # layout data in nodes table should be named as 
        # x and y
        attributes(vertex(g), "layout") = ({
            const x = nodes[, "x"];
            const y = nodes[, "y"];

            lapply(1:nrow(nodes), i -> [x[i], y[i]], names = id);
        });
    } else {
        require(igraph.layouts);

        print("generate network graph layout by algorithm...");
        print("force directed");

        # apply of the layout algorithm        
        g = g |> layout.force_directed(algorithm = "edge_weighted");
    }

    g;
}

#' Create index list of the given styles data
#' 
#' @param from the node labels of the source node
#' @param to the node labels of the target node
#' @param style the one of kind styles data of the edges that specific by 
#'    the source and target node.
#' 
let styleIndex as function(from, to, table, style) {
    if (is.null(style)) {
        NULL;
    } else {
        print(`# set ${style}.`);

        style = table[, style];

        if (length(style) != length(from) || length(style) != length(to)) {
            stop("vector size is mis-matched!");
        } else {
            lapply(1:length(style), i -> style[i], names = `${from}..${to}`);
        }
    }    
}
