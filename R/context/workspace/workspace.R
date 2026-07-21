#' Get the Workspace Location of an Analysis Application
#'
#' @description
#' Returns the workspace directory path that has been allocated to a
#' specific analysis application inside the workflow temporary
#' directory. The workspace directory is used by the application to
#' store its intermediate result files so that they can be consumed
#' by downstream modules.
#'
#' @param app the application list object produced by
#'   \code{\link{app}}, or alternatively a character vector giving the
#'   application name directly.
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#' @param verbose a logical value that controls whether diagnostic
#'   information about the resolved workspace path should be printed.
#'   The default value of \code{FALSE} suppresses the output. When
#'   \code{options(verbose = TRUE)} is set, the function always
#'   behaves as if \code{verbose = TRUE}.
#'
#' @return
#' A character vector of the workspace directory path of the specific
#' analysis application. The path is normalized to an absolute path
#' and is located under
#' \code{<temp_dir>/workflow_tmp/<app_name>/}.
#'
#' @details
#' The verbose option can also be configured from the command-line
#' option \code{--verbose}. When the requested application has not
#' been registered in the analysis context yet, a warning is emitted
#' via \code{\link{echo_warning}} but the workspace path is still
#' returned so that the calling code can decide how to handle the
#' situation.
#'
#' @examples
#' \dontrun{
#' ws <- workspace("my_analysis_module");
#' }
#'
#' @seealso \code{\link{workfile}}, \code{\link{workdir_root}},
#'   \code{\link{get_app_name}}, \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const workspace = function(app, ssid = NULL, verbose = FALSE) {
    const verboseOpt = as.logical(getOption("verbose", default = verbose));
    const context    = .get_context(ssid);
    const temp_root  = context$temp_dir;
    const app_name   = get_app_name(app);
    const workdir    = normalizePath(`${temp_root}/workflow_tmp/${app_name}/`);
    const program    = context$pipeline;

    if (verboseOpt) {
        print("view of the given app object for get its workspace dir:");
        print("get app_name:");
        str(app_name);
        print("get pipeline workflow components:");
        str(program);
        print("combine the workdir path:");
        print(workdir);
    };

    if (!(app_name in program)) {
        echo_warning(`The app(${app_name}) has not been registered in the analysis context yet.`, app);
    };

    workdir;
}

