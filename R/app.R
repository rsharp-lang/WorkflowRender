
#' Analysis app constructor
#' 
#' @param analysis a callable function for run the data analysis 
#'   content.
#' 
const app = function(name, analysis, desc = "no description") {
    list(
        name = name,
        call = analysis
    );
}

#' Set user parameters to the workflow context
#' 
#' @param configs a key-value paire tuple list object that
#'    contains the workflow parameter values.
#' 
const set_config = function(configs) {
    const ctx = .get_context();
    const cfg = {
        if (!["configs" in ctx]) {
            ctx$configs = list();
        }

        ctx$configs;
    }

    for(name in names(configs)) {
        cfg[[name]] = configs[[name]];
    }

    invisible(NULL);
}