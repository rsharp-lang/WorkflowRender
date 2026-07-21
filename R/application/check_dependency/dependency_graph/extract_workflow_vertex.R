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