
#' Analysis app constructor
#' 
#' @param analysis a callable function for run the data analysis 
#'   content.
#' @param name the analysis app name
#' @param dependency usually be the environment context symbol 
#'   dependency or the workspace file dependency
#' 
const app = function(name, analysis, desc = "no description", dependency = NULL) {
    # check of the function signature
    if (!app.check(analysis)) {
        throw_err("invalid function declare signature!");
    }

    list(
        name = name,
        call = analysis,
        desc = desc,
        dependency = dependency
    );
}

#' Check the function signature of the app function
#'
const app.check = function(analysis) {

}

#' Set user parameters to the workflow context
#' 
#' @param configs a key-value paire tuple list object that
#'    contains the workflow parameter values.
#' 
const set_config = function(configs = list()) {
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