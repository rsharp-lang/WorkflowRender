#' try to extract the dependency graph from the application modules
#' 
const dependency_graph = function() {
    require(igraph);

    let context = .get_context();
    let appList = context$workflow;
    let source      = []; # name of source node
    let source_type = []; # type of the source node
    let target      = []; # name of the target node
    let target_type = []; # type of the target node
    let deps_type   = []; # the dependency type
    let vertex      = NULL;
    let app_data    = NULL;
    let pool        = list();

    # start to analysis application module and generates the input and outputs
    for(name in names(appList)) {
        app_data <- dependency_analysis(appList[[name]]);
        vertex <- rbind(vertex, extract_workflow_vertex(app_data));
        pool[[name]] <- app_data;
    }

    vertex = vertex 
    |> groupBy("id") 
    |> lapply(x -> list(
        id    = unique(x$id), 
        name  = unique(x$name), 
        label = unique(x$label), 
        type  = unique(x$type)
    ));

    vertex <- data.frame(
        id = vertex@id,
        name = vertex@name,
        label = vertex@label,
        type = vertex@type,
        row.names = vertex@id
    );

    print("view of the vertex information:");
    print(vertex);

    let graph = igraph::empty.network();

    for(v in tqdm(as.list(vertex, byrow = TRUE))) {
        # List of 4
        #  $ id    : chr "b897b9f7a69357f1104f00b2e26c4a4f"
        #  $ name  : chr "singlecell_matrix"
        #  $ label : chr "export single cell expression data"
        #  $ type  : chr "application"
        graph |> add.node(
            v$id,
            label = v$name, group = v$type, desc = v$label
        );
    }

    for(app in pool) {
        let app_id = md5(`app_${app$id}`); # target node
        let files = app$input_files;

        for(name in meta$pars) {         
            # u -> v
            graph |> add.edge(u = md5(name), v = app_id);
        }
        for(app_name in names(files)) {
            let filenames = files[[app_name]];

            for(file in filenames) {
                graph |> add.edge(
                    u = md5(`${app_name}://${file}`), 
                    v = app_id
                ); 
            }
        }
    }

    return(graph);
}

const extract_workflow_vertex = function(meta) {
    let vex = list();
    let i = 1;
    let files = meta$input_files;

    vex[["app"]] = list(id = md5(`app_${meta$id}`), 
        name  = meta$id, 
        label = meta$label, type = "application"
    );
    
    for(name in meta$pars) {
        vex[[`v_${i = i+1}`]] = list(id = md5(name), 
            name = name, 
            label = name, type = "environment");
    }

    for(app_name in names(files)) {
        let filenames = files[[app_name]];

        for(file in filenames) {
            vex[[`f_${i=i+1}`]] = list(id = md5(`${app_name}://${file}`), 
                name = file, 
                label = `${app_name}://${file}`, 
                type = "file");
        }
    }

    data.frame(
        id = vex@id, 
        name = vex@name, 
        label = vex@label, 
        type = vex@type
    );
}

const dependency_analysis = function(app) {
    list(
        id = app$name,
        label = app$desc,
        pars = names(app$dependency$contex_env),
        input_files = app$dependency$tempfiles
    );
}