#' function for create application dependency data
#'
#' @param context_env a list of the depends environment symbol in the 
#'    current workflow context, value of this parameter it could be a
#'    character vector of the required symbol(will assume that no data
#'    type is required), or a tuple list object with key name is the symbol
#'    name and the corresponding tuple value is the required symbol type. 
#'
#' @param workfiles a set of the required temp result files in the workflow
#'    the format of this parameter value is a tuple list of the file path,
#'    where the key name is the app name and the corresponding tuple list value
#'    is a character vector of the required multiple reference temp file
#' 
#' @details the allowed data type of the context symbol could be:
#'    ``any``, ``numeric``, ``integer``, ``character``, ``logical``, ``function``
#'
const set_dependency = function(context_env = list(), workfiles = list()) {
    const types = ['any', 'numeric', 'integer', 'character', 'logical', 'function'];

    if (is.list(context_env)) {
        # check type mark is valids or not
        for(name in names(context_env)) {
            const type_mark = context_env[[name]];

            if (![type_mark in types]) {
                throw_err(`Invalid type mark(${type_mark}) for the application dependency!`);
            }
        }
    } else {
        context_env = lapply(context_env, a -> "any", names = context_env);
    }

    list(
        context_env = context_env,
        tempfiles   = workfiles
    );
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
                check = FALSE,
                context = check_env,
                file = check_files
            ));
        }
    }
}

const check_dependency.context_env = function(requires, context) {

}

const check_dependency.localfiles = function(requires, context) {

}