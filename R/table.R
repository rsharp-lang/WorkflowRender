# tools for convert any dataframe as the required table format for build a network graph

#' 
#' 
#' 
let mapEdge as function(edges, 
    from   = "from", 
    to     = "to", 
    weight = "weight", 
    type   = "type", 
    color  = "color", 
    width  = "width", 
    dash   = "dash") {

    edges = as.data.frame(edges);

    edges[, "from"]   = edges[, from];
    edges[, "to"]     = edges[, to];
    edges[, "weight"] = edges[, weight];
    edges[, "type"]   = edges[, type];
    edges[, "color"]  = edges[, color];
    edges[, "width"]  = edges[, width];
    edges[, "dash"]   = edges[, dash];
    edges;
}

let mapNode as function(nodes, 
    group = "group", 
    label = "label", 
    color = "color", 
    shape = "shape", 
    size  = "size") {

    nodes = as.data.frame(nodes);

    nodes[, "group"] = nodes[, group];
    nodes[, "label"] = nodes[, label];
    nodes[, "color"] = nodes[, color];
    nodes[, "shape"] = nodes[, shape];
    nodes[, "size"]  = nodes[, size];
    nodes;
}