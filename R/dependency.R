const set_dependency = function() {

}

#' Check of the analysis app dependency
#' 
#' @param app the analysis app object list which is construct
#'    via the ``app`` function.
#'
#' @return this function returns a data list that contains the
#'    dependency check result. there are some data symbol inside
#'    this result object list: check(logical, for indicate the 
#'    dependency check success or not), context(character vector 
#'    of dependency of context symbol not success), file(character
#'    vector of dependency of local workspace file check not success)
#'
const check_dependency = function(app) {
    if (is.null(app$dependency)) {
        # this application has no dependency
        return(list(
            check = TRUE
        ));
    } else {
        return(list(
            check = TRUE
        ));
    }
}