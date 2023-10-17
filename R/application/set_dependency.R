#' function for create application dependency data
#'
#' @param context_env a list of the depends environment symbol in the 
#'    current workflow context, value of this parameter it could be: 
#' 
#'    1. a character vector of the required symbol(will assume that 
#'       no data type is required), or 
#'    2. a tuple list object with key name is the symbol name and 
#'       the corresponding tuple value is the required symbol type. 
#'
#' @param workfiles a set of the required temp result files in the workflow
#'    the format of this parameter value is a tuple list of the file path,
#'    where the key name is the app name and the corresponding tuple list value
#'    is a character vector of the required multiple reference temp file.
#' 
#'    the data format of this parameter would be:
#'       list(app1 = [file1, file2, ...], app2 = file3, ...)
#' 
#' @details the allowed data type of the context symbol could be:
#'    ``any``, ``numeric``, ``integer``, ``character``, ``logical``, 
#'    ``function``
#'
const set_dependency = function(context_env = list(), workfiles = list()) {
    const types = ['any', 'numeric', 'integer', 
       'character', 'logical', 'function'];

    if (is.list(context_env)) {
        # check type mark is valids or not
        for(name in names(context_env)) {
            const type_mark = context_env[[name]];

            if (!(type_mark in types)) {
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

