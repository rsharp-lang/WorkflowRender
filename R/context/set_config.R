#' Set user parameters to the workflow context
#' 
#' @param configs a key-value paire tuple list object that
#'    contains the workflow parameter values.
#' 
const set_config = function(configs = list()) {
    const ctx = .get_context();
    const cfg = {
        if (!("configs" in ctx)) {
            ctx$configs = list();
        }

        ctx$configs;
    }

    for(name in names(configs)) {
        cfg[[name]] = configs[[name]];
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
        const env = ctx$configs;
        const result = env[[name]];

        result || default;
    }
}