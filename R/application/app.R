
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
const app = function(name, analysis, desc = "no description", dependency = NULL) {
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

#' check of the required app slot
#'
const app_check.signature = function(app) {
    all(["name", "call"] in names(app));
}

#' Check the function signature of the app function
#' 
#' @param analysis a callable function to check, just check of the required 
#'    parameters is exists in the definition or not.
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
const app_check.delegate = function(analysis) {
    const pars = as.list(args(name = analysis));
    const verbose = getOption("verbose");

    if (as.logical(verbose)) {
        str(pars);
    }

    # pars contains 3 slot value:
    #
    # 1. empty_name: the function declare info, includes name and the 
    #                possible function value type
    # 2. other_name: the function parameter name.

    if (length(pars) != 3) {
        echo_warning("the analysis application function required 2 parameters!");
        return(FALSE);
    } else {
        return(all(["app", "context"] in names(pars)));
    }
}

