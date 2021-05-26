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