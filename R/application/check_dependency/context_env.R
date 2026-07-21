#' Check the Environment Symbol Dependencies of an Application
#'
#' @description
#' Validates that all of the environment symbols declared by an
#' analysis application are present in the current workflow context
#' and that their data types match the declared types. This
#' implementation of the \code{\link{check_dependency}} generic
#' function is responsible for the \code{context_env} part of the
#' dependency declaration.
#'
#' @param context_env a named list object that describes the required
#'   environment symbols. The element names are the symbol names and
#'   the element values are the required symbol types (one of
#'   \code{"any"}, \code{"numeric"}, \code{"integer"},
#'   \code{"character"}, \code{"logical"} or \code{"function"}).
#' @param context the workflow context object that is used to resolve
#'   the dependency declarations. The object is typically obtained
#'   via \code{\link{.get_context}}.
#'
#' @return
#' A named list object that summarizes the result of the environment
#' symbol dependency check. The list contains the following elements:
#' \describe{
#'   \item{\code{check}}{a logical value that is \code{TRUE} when all
#'     required environment symbols are present and have the correct
#'     data type, and \code{FALSE} otherwise.}
#'   \item{\code{context}}{a named list that describes the missing or
#'     mismatched symbols. The first element of the list is a debug
#'     summary of all available environment symbols, and the
#'     remaining elements describe each problematic symbol with a
#'     short reason string (such as \code{"missing"} or
#'     \code{"mis-matched"}).}
#' }
#'
#' @details
#' The function iterates over the supplied \code{context_env}
#' declaration and checks each symbol against the workflow context:
#' \enumerate{
#'   \item When a declared symbol is not present in the workflow
#'     context, the symbol is recorded as \code{"missing"}.
#'   \item When a declared symbol is present but its data type does
#'     not match the declared type, the symbol is recorded as
#'     \code{"mis-matched"}.
#'   \item When a declared symbol is present and its data type
#'     matches the declared type, the symbol is considered satisfied.
#' }
#'
#' The type matching is performed via the \code{is.<type>} family of
#' functions, with the special case that the \code{"any"} type mark
#' always matches. When at least one symbol is missing or
#' mismatched, the \code{check} result is set to \code{FALSE}.
#'
#' @seealso \code{\link{check_dependency}},
#'   \code{\link{check_dependency.localfiles}},
#'   \code{\link{set_dependency}},
#'   \code{\link{dependency.context_env_missing}}
#'
#' @keywords internal
#'
const check_dependency.context_env = function(requires, context) {
    const env = context$configs;
    const map = {
              'any': "any", 
          'numeric': "num", 
          'integer': "int", 
        'character': "chr", 
          'logical': "logi", 
         'function': "function"
    };
    const env_symbols = names(env);
    const err = list(
        "environment_symbols(all)" = `[${paste(env_symbols, sep = ", ")}]`
    );

    for(name in names(requires)) {
        const mark  = requires[[name]];
        const missing = !(name in env);

        if (missing) {
            err[[name]] = "missing";
        } else if (mark != "any") {
            if (map[[mark]] != typeof(env[[name]])) {
                err[[name]] = "mis-matched";
            }
        }
    }

    if (length(err) <= 1) {
        NULL;
    } else {
        return(err);
    }
}