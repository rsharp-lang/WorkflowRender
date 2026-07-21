#' Generate the Error Message for Missing Context Symbols
#'
#' @description
#' Builds a human-readable error message that describes the runtime
#' environment context symbols that are required by an analysis
#' application but are missing or have a mismatched data type. This
#' function is invoked by \code{\link{.internal_call}} when the
#' dependency check for an application fails.
#'
#' @param context a named list that describes the missing or mismatched
#'   context symbols. Each element of the list corresponds to a single
#'   symbol, where the element name is the symbol name and the element
#'   value is a short reason string (such as \code{"missing"} or
#'   \code{"mis-matched"}). The first element of the list is expected
#'   to be a debug summary of all available environment symbols.
#'
#' @return
#' A character vector that contains the formatted error message. When
#' \code{context} is \code{NULL} or empty, a message indicating that no
#' required context symbol is missing is returned instead.
#'
#' @details
#' The returned message includes the number of missing or mismatched
#' symbols and a JSON-encoded representation of the \code{context}
#' list, which makes it easy to inspect the exact symbols that caused
#' the dependency check to fail.
#'
#' @seealso \code{\link{check_dependency.context_env}},
#'   \code{\link{dependency.workfiles_missing}}, \code{\link{throw_err}}
#'
#' @keywords internal
#'
const dependency.context_env_missing = function(context) {
    if (is.null(context) || length(context) == 0) {
        "there is no runtime environment required context symbol is missing.";
    } else {
        paste([
            # the first elements is all context symbols
            # for debug used only
            `there are ${length(context)-1} required context symbol is missing or data type is mis-matched in the workflow:`,
            JSON::json_encode(context)
        ], sep = " ");
    }
}

#' Generate the Error Message for Missing Required Work Files
#'
#' @description
#' Builds a human-readable error message that describes the workspace
#' temporary files that are required by an analysis application but are
#' not present in the corresponding application workspace directory.
#' This function is invoked by \code{\link{.internal_call}} when the
#' file dependency check for an application fails.
#'
#' @param file a named list that describes the missing workspace files.
#'   Each element of the list corresponds to a single application, where
#'   the element name is the application name and the element value is a
#'   character vector of the missing file paths relative to that
#'   application's workspace directory.
#'
#' @return
#' A character vector that contains the formatted error message. When
#' \code{file} is \code{NULL} or empty, a message indicating that no
#' required workspace temporary file is missing is returned instead.
#'
#' @details
#' The returned message includes the number of applications with
#' missing files and a per-application breakdown of the missing file
#' paths, joined by semicolons for compactness.
#'
#' @seealso \code{\link{check_dependency.localfiles}},
#'   \code{\link{dependency.context_env_missing}}, \code{\link{throw_err}}
#'
#' @keywords internal
#'
const dependency.workfiles_missing = function(file) {
    if (is.null(file) || length(file) == 0) {
        "there is no required workspace tempfile is missing in current workflow.";
    } else {
        file = file
        |> names
        |> sapply(app -> `${app}: ${paste(file[[app]], sep = " and ")}`)
        |> paste(sep = "; ")
        ;

        paste([`there are ${length(file)} required workspace tempfile is missing in the work directory:`, file], sep = " ");
    }
}
