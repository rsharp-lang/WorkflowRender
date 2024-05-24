#' try to extract the dependency graph from the application modules
#' 
const dependency_graph = function() {
    let context = .get_context();
    let appList = context$workflow;
    let source      = []; # name of source node
    let source_type = []; # type of the source node
    let target      = []; # name of the target node
    let target_type = []; # type of the target node
    let deps_type   = []; # the dependency type

    # start to analysis application module and generates the input and outputs
    for(name in names(appList)) {
        let analysis = dependency_analysis(appList[[name]]);

        str(analysis);
        stop(); 
    }
}

const dependency_analysis = function(app) {
    str(app);
    stop();
}