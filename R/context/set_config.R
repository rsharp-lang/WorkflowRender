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

