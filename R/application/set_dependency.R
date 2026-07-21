#' Create an Application Dependency Declaration
#'
#' @description
#' Constructs a dependency declaration list that describes the
#' environment symbols and the workspace files that an analysis
#' application requires in order to run successfully. The returned
#' list is intended to be supplied as the \code{dependency} argument
#' of the \code{\link{app}} function.
#'
#' @param context_env a list of the environment symbols that the
#'   application depends on in the current workflow context. The
#'   value of this parameter can be supplied in two forms:
#'   \enumerate{
#'     \item A character vector of the required symbol names. In this
#'       case no data type is required for any of the symbols and
#'       each symbol is implicitly marked as type \code{"any"}.
#'     \item A named list object whose element names are the symbol
#'       names and whose element values are the required symbol
#'       types. The allowed type values are listed in the Details
#'       section below.
#'   }
#' @param workfiles a set of the required temporary result files in
#'   the workflow. The format of this parameter value is a tuple list
#'   of the file paths, where the key name is the producing
#'   application name and the corresponding tuple list value is a
#'   character vector of the required reference temporary files. The
#'   expected data format of this parameter is:
#'   \code{list(app1 = [file1, file2, ...], app2 = file3, ...)}.
#'
#' @return
#' A named list object with two elements:
#' \describe{
#'   \item{\code{context_env}}{the validated environment symbol
#'     dependency list.}
#'   \item{\code{tempfiles}}{the workspace file dependency list,
#'     identical to the supplied \code{workfiles} argument.}
#' }
#'
#' @details
#' The allowed data type values for the context symbols are:
#' \code{"any"}, \code{"numeric"}, \code{"integer"},
#' \code{"character"}, \code{"logical"} and \code{"function"}.
#'
#' When the \code{context_env} parameter is supplied as a character
#' vector rather than a named list, the function converts it into a
#' named list in which every symbol is marked as type \code{"any"}.
#' When the \code{context_env} parameter is supplied as a named list,
#' the function validates each type mark against the list of allowed
#' types and aborts the workflow via \code{\link{throw_err}} when an
#' invalid type mark is encountered.
#'
#' @examples
#' \dontrun{
#' deps <- set_dependency(
#'   context_env = list(arg1 = "character", arg2 = "numeric"),
#'   workfiles   = list(upstream = "result.txt")
#' );
#' }
#'
#' @seealso \code{\link{app}}, \code{\link{check_dependency}},
#'   \code{\link{throw_err}}
#'
#' @author xieguigang
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

