#' parse the workfile expression
#' 
const __workfiles = function(files_uri) {
    if (length(files_uri) == 0) {
        NULL;
    } else {
        __workfiles_data(files_uri);
    }
}

const __workfiles_data = function(files_uri) {
    let uri = lapply(files_uri, si -> __workfile_uri_parser(si));
    let app = as.character(uri@app);
    let file = as.character(uri@file);
    let app_groups = data.frame(app, file) 
    |> as.list(byrow = TRUE) 
    |> groupBy("app") 
    |> lapply(app -> app@file)
    ;

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