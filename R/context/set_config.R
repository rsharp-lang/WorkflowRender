#' Set user parameters to the workflow context
#' 
#' @param configs a key-value paire tuple list object that
#'    contains the workflow parameter values.
#' 
const set_config = function(configs = list()) {
    let val = NULL;
    let ctx = .get_context();
    let cfg = {
        if (!("configs" in ctx)) {
            ctx$configs = list();
        }

        ctx$configs;
    }

    for(name in names(configs)) {
        val <- configs[[name]];
        cfg[[name]] <- val;

        if (is.null(val)) {
            # list set NULL means delete element     
            # add warning at here
            echo_warning(`the config value of '${name}' is nothing!`);       
        }        
    }

    invisible(NULL);
}

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
const get_config = function(name, default = NULL) {
    const ctx = .get_context();

    if (!("configs" in ctx)) {
        NULL;
    } else {
        const path = strsplit(name, "$", fixed = TRUE);
        const verbose = as.logical(getOption("verbose"));

        if (verbose) {
            if (length(path) > 1) {
                print(`get configuration from path: ${paste(path, sep = " -> ")}`);
            } else {
                print(`get configuation via a key: ${name}`);
            }
        }

        let config = ctx$configs;

        for(name in path) {
            if (name in config) {
                config = config[[name]];
            } else {
                return(default);
            }
        }

        return(config || default);
    }
}