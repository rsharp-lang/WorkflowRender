#' Construct a File Path Inside an Application Workspace
#'
#' @description
#' Resolves the physical file path of a data file that is located
#' inside the workspace directory of a specific analysis application.
#' The function accepts either an explicit application name plus a
#' relative file path, or a compact workfile URI expression of the
#' form \code{app://relpath/to/file.ext}.
#'
#' @param app this parameter value can be supplied in three different
#'   forms:
#'   \enumerate{
#'     \item An application tuple list object, as created by the
#'       \code{\link{app}} function.
#'     \item A character vector giving the application name directly.
#'     \item A workfile path expression in the format
#'       \code{app://relpath/to/file.ext}. When this form is used, the
#'       \code{relpath} parameter must be left as \code{NULL}.
#'   }
#' @param relpath a character vector of the file path relative to the
#'   workspace directory of the application. When \code{NULL} (the
#'   default), the function assumes that the \code{app} parameter
#'   contains a workfile URI expression that should be parsed to
#'   extract both the application name and the relative file path.
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#' @param verbose a logical value that controls whether diagnostic
#'   information about the resolved file path should be printed. The
#'   default value of \code{FALSE} suppresses the output.
#'
#' @return
#' A character vector of the physical file path of the requested
#' reference file inside the workflow workspace.
#'
#' @details
#' The workfile path expression uses the format string
#' \code{app://filepath}. For example, the expression
#' \code{getMzSet://mzset.txt} is parsed to extract the application
#' name \code{getMzSet} and the relative path \code{mzset.txt}. This
#' expression is therefore equivalent to the explicit function call
#' \code{workfile("getMzSet", "/mzset.txt")}.
#'
#' When the \code{relpath} parameter is supplied as an empty value
#' but the \code{app} parameter is a character vector, the function
#' delegates the parsing of the URI expression to the internal helper
#' \code{\link{__workfile_uri_parser}}. When the \code{app} parameter
#' is not a character vector in this situation, an error is raised
#' because the supplied value cannot be interpreted as an internal
#' workfile path reference.
#'
#' @examples
#' \dontrun{
#' # explicit form
#' path <- workfile("getMzSet", "mzset.txt");
#'
#' # URI expression form
#' path <- workfile("getMzSet://mzset.txt");
#' }
#'
#' @seealso \code{\link{workspace}}, \code{\link{__workfile_uri_parser}},
#'   \code{\link{get_app_name}}
#'
#' @author xieguigang
#'
const workfile = function(app, relpath = NULL, ssid = NULL, verbose = FALSE) {
    if (is.empty(relpath)) {
        if (is.character(app)) {
            relpath <- __workfile_uri_parser(app);

            # gets the internal workfile reference
            # its physical file path
            file.path(WorkflowRender::workspace(relpath$app, ssid, verbose = verbose), relpath$file);
        } else {
            throw_err("the given expression value should be an internal workfile path reference!");
        }
    } else {
        file.path(WorkflowRender::workspace(app, ssid, verbose = verbose), relpath);
    }
}
