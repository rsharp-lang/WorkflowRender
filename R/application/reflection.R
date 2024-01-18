# imports attributes = .Internal::attributes;

#' Build workflow app object
#' 
#' @details Build a new workflow app module object based on the
#'    custom attribute values that tagged on the target function
#' 
#' @param f the target function f which tagged the required
#'    attribute data inside: app, desc, context_env, workfiles
#' 
const __build_app = function(f) {
    let attrs = .Internal::attributes(f);
    let app_name = attrs$app || "";
    let desc = attrs$desc;
    let context_env = attrs$context_env;
    let workfiles = attrs$workfiles;
    
    if (nchar(app_name) == 0) {
        return(NULL);
    } else {
        app(app_name, analysis = f, 
                    desc = desc, 
                    dependency = set_dependency(
                        context_env = context_env, 
                        workfiles = __workfiles(files_uri = workfiles)
                    ));
    }
}

#' parse the workfile expression
#' 
const __workfiles = function(files_uri) {
    const uri = lapply(files_uri, si -> __workfile_uri_parser(si));
    const app = uri@app;
    const file = uri@file;
    const app_groups = data.frame(app, file) 
    |> as.list(byrow = TRUE) 
    |> groupBy("app") 
    |> lapply(function(app) {
        sapply(app, a -> a$file); 
    });

    app_groups;
}

#' parse the workfile expression
#' 
#' @param uri a character vector that contains the workfile 
#'    reference expression.
#' 
#' @return a tuple list object that contains the necessary 
#'    parameter value for call ``workfile`` function for gets
#'    the reference file path to the required data files.
#' 
const __workfile_uri_parser = function(uri) {
    # example as: 
    # app_name://file/path/to/file.txt
    let tuple = tagvalue(uri, '://', as.list = TRUE);
    let ref = list(
        app = names(tuple),
        file = unlist(tuple)
    );

    # app, file
    return(ref);
}