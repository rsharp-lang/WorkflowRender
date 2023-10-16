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