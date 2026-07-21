#' Get the Workspace Root Directory
#'
#' @description
#' Returns the root directory path of the current workflow workspace.
#' This is the same directory that was supplied to
#' \code{\link{init_context}} as the \code{outputdir} parameter.
#'
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#'
#' @return
#' A character vector of the workspace root directory path.
#'
#' @details
#' Actually this function returns the \code{root} directory path that
#' was set via the \code{\link{init_context}} function. It is a
#' convenience accessor that allows workflow modules to refer to the
#' workspace root without having to call \code{\link{.get_context}}
#' directly.
#'
#' @examples
#' \dontrun{
#' root <- workdir_root();
#' }
#'
#' @seealso \code{\link{init_context}}, \code{\link{result_dir}},
#'   \code{\link{workspace_temproot}}, \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const workdir_root = function(ssid = NULL) {
    .get_context(ssid)$root;
}

#' Get the Directory Path for the Analysis Output Result
#'
#' @description
#' Returns the directory path where the analysis result output files
#' of the current workflow should be written. This directory is a
#' sub-directory of the workspace root and is created by
#' \code{\link{init_context}}.
#'
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#'
#' @return
#' A character vector of the analysis result output directory path.
#'
#' @details
#' The returned path corresponds to the \code{analysis} slot of the
#' workflow context, which is initialized by
#' \code{\link{init_context}} to \code{<outputdir>/analysis/}.
#'
#' @examples
#' \dontrun{
#' out <- result_dir();
#' }
#'
#' @seealso \code{\link{init_context}}, \code{\link{workdir_root}},
#'   \code{\link{workspace_temproot}}, \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const result_dir = function(ssid = NULL) {
    .get_context(ssid)$analysis;
}

#' Get the Workspace Temporary Root Directory
#'
#' @description
#' Returns the temporary root directory of the current workflow
#' workspace. This directory holds all of the intermediate files
#' produced by the workflow modules, including the per-application
#' workspace directories returned by \code{\link{workspace}}.
#'
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the
#'   global user environment.
#'
#' @return
#' A character vector of the temporary root directory path of the
#' workflow workspace.
#'
#' @details
#' The returned path corresponds to the \code{temp_dir} slot of the
#' workflow context, which is initialized by
#' \code{\link{init_context}} to \code{<outputdir>/tmp/}.
#'
#' @examples
#' \dontrun{
#' tmp <- workspace_temproot();
#' }
#'
#' @seealso \code{\link{init_context}}, \code{\link{workdir_root}},
#'   \code{\link{result_dir}}, \code{\link{workspace}},
#'   \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const workspace_temproot = function(ssid = NULL) {
    const context   = .get_context(ssid);
    const temp_root = context$temp_dir;

    temp_root;
}
