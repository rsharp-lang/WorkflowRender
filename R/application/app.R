
#' Analysis app constructor
#' 
#' @param analysis a callable function for run the data analysis 
#'   content. The function declare signature for this parameter
#'   value required of two parameter signature, see comment document
#'   of the ``app.check`` function.
#'
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
#' @param analysis a callable function to check
#'
#' @details the analysis function should contains only two
#'    required parameters with specific name defined: 
#'
#'    1. app: a list object that defines the app object itself
#'    2. context: a list object that accept the workflow environment context
#'
#'    due to the reason of analysis app function is called via the ``do.call``
#'    function from the RENV base environment, so that the parameter value is
#'    aligned with the invoke function target strictly, so you can not change
#'    the parameter name or the parameter will not be aligned properly when 
#'    call this analysis app function. 
#'
const app.check = function(analysis) {
    const pars = as.list(args(func = analysis));
    
    if (length(pars) != 2) {
        echo_warning("the analysis application function required 2 parameters!");
        return(FALSE);
    } else {
        return(all(["app", "context"] in names(pars)));
    }
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