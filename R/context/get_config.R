#' Get a User Parameter Value from the Current Workflow Context
#'
#' @description
#' Retrieves the value of a user-supplied parameter from the workflow
#' context environment. The parameter name may be a simple key or a
#' dotted path separated by \code{$}, in which case the function
#' traverses the nested configuration list to locate the requested
#' value.
#'
#' @param name a character vector of the parameter name. A nested
#'   configuration value can be addressed using the \code{$} separator,
#'   for example \code{"inputs$arg1"}.
#' @param default the default value to return when the parameter is
#'   missing from the workflow context environment. The default value
#'   of \code{NULL} means that no default is supplied.
#' @param warn_msg an optional character vector of a warning message
#'   that should be emitted via \code{\link{echo_warning}} when the
#'   requested parameter is missing. When \code{NULL} (the default),
#'   no warning is emitted and the \code{default} value is returned
#'   silently.
#'
#' @return
#' The parameter value found in the workflow context, or the supplied
#' \code{default} value when the parameter is missing. The returned
#' value may be of any data type; a type cast function expression
#' (such as \code{as.logical}, \code{as.double}, etc.) may be required
#' to convert the returned character value to the desired type.
#'
#' @details
#' The function splits the supplied \code{name} on the \code{$}
#' separator and walks the configuration list returned by
#' \code{\link{pull_configs}} step by step. If any intermediate key is
#' missing, the function returns the \code{default} value (and emits
#' the \code{warn_msg} warning when one is supplied). When the
#' \code{verbose} option is enabled, the function prints the
#' configuration path being resolved for debugging purposes.
#'
#' @examples
#' \dontrun{
#' # simple key
#' arg1 <- get_config("arg1", default = "fallback");
#'
#' # nested path
#' value <- get_config("inputs$arg1", default = 0);
#' }
#'
#' @seealso \code{\link{set_config}}, \code{\link{pull_configs}},
#'   \code{\link{echo_warning}}
#'
#' @author xieguigang
#'
const get_config = function(name, default = NULL, warn_msg = NULL) {
    const path    = strsplit(name, "$", fixed = TRUE);
    const verbose = as.logical(getOption("verbose"));

    if (verbose) {
        if (length(path) > 1) {
            print(`get configuration from path: ${paste(path, sep = " -> ")}`);
        } else {
            print(`get configuation via a key: ${name}`);
        }
    }

    let config = pull_configs();

    for(name in path) {
        if (name in config) {
            config = config[[name]];
        } else {
            return(default);
        }
    }

    if (is.null(warn_msg)) {
        return(config || default);
    } else {
        if (is.null(config)) {
            echo_warning(warn_msg);
            default;
        } else {
            config;
        }
    }
}
