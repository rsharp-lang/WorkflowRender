#' Check of the analysis app dependency
#' 
#' @param app the analysis app object list which is construct
#'    via the ``app`` function.
#'
#' @return this function returns a data list that contains the
#'    dependency check result. there are some data symbol inside
#'    this result object list: 
#'
#'    1. check: logical, for indicate the dependency check success or not;
#'    2. context: a tuple list object that contains of context symbol names 
#'                which are not check success, and the reason of failure;
#'    3. file: character vector of dependency of local workspace file 
#'             check not success
#'
const check_dependency = function(app, context = .get_context()) {
    const SUCCESS = list(check = TRUE);

    if (is.null(app$dependency)) {
        # this application has no dependency
        return(SUCCESS);
    } else {
        const dependency  = app$dependency;
        const check_env   = check_dependency.context_env(requires = dependency$context_env, context); 
        const check_files = check_dependency.localfiles(requires = dependency$tempfiles, context);
        const pass1 = is.null(check_env);
        const pass2 = is.null(check_files);

        if (pass1 && pass2) {
            return(SUCCESS);
        } else {
            return(list(
                check   = FALSE,
                context = check_env,
                file    = check_files
            ));
        }
    }
}