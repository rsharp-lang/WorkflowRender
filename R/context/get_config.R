#' get user parameter value inside current workflow context environment
#' 
#' @param name a character vector of the parameter name
#' @param default the default value for the parameter if missing from the 
#'    workflow context environment.
#' 
#' @return the parameter value, maybe is object value in character type,
#'    a type cast function expression invoke example as: 
#'    ``as.logical``, ``as.double``, etc maybe required.
#' 
const get_config = function(name, default = NULL, warn_msg = NULL) {
    const path    = strsplit(name, "$", fixed = TRUE);
    const verbose = as.logical(getOption("verbose"));

    if (verbose) {
        if (length(path) > 1) {
            print(`get configuration from path: ${paste(path, sep = " -> ")}`);
        } else {
            print(`get configuation via a key: ${name}`);
        }
    }

    let config = pull_configs();

    for(name in path) {
        if (name in config) {
            config = config[[name]];
        } else {
            return(default);
        }
    }

    if (is.null(warn_msg)) {
        return(config || default);
    } else {
        if (is.null(config)) {
            echo_warning(warn_msg);
            default;
        } else {
            config;
        }
    }    
}