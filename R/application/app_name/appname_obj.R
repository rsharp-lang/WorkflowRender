#' Get app name from the generated analysis app module
#' 
const get_appName.obj = function(app) {
    let verbose as boolean = as.logical(getOption("verbose"));

    if (verbose) {
        print("app object is a list.");
    }

    if (nchar(app$name) > 0) {
        return(app$name);
    } else {
        throw_err(["invalid app object: ", JSON::json_encode(app)]);
    }  
}