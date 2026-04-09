
#' Analysis app constructor
#' 
#' @param analysis a callable function for run the data analysis 
#'   content. The function declare signature for this parameter
#'   value required of two parameter signature, see comment document
#'   of the ``app_check.delegate`` function.
#'
#' @param name the analysis app name
#' @param dependency usually be the environment context symbol 
#'   dependency or the workspace file dependency
#' 
const app = function(name, analysis, 
                     desc = "no description", 
                     dependency = NULL) {

    # check of the function signature
    if (!app_check.delegate(analysis)) {
        throw_err("invalid function declare signature!");
    }

    list(
        name = name,
        call = analysis,
        desc = desc,
        dependency = dependency,
        disable = FALSE
    );
}


