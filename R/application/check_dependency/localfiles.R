#' Check the Workspace File Dependencies of an Application
#'
#' @description
#' Validates that all of the workspace files declared by an analysis
#' application are present in the workspace directories of their
#' producing applications. This implementation of the
#' \code{\link{check_dependency}} generic function is responsible for
#' the \code{tempfiles} part of the dependency declaration.
#'
#' @param workfiles a named list object that describes the required
#'   workspace files. The element names are the names of the
#'   producing applications and the element values are character
#'   vectors of the file paths relative to each application's
#'   workspace directory.
#' @param context the workflow context object that is used to resolve
#'   the workspace directory paths. The object is typically obtained
#'   via \code{\link{.get_context}}.
#'
#' @return
#' A named list object that summarizes the result of the workspace
#' file dependency check. The list contains the following elements:
#' \describe{
#'   \item{\code{check}}{a logical value that is \code{TRUE} when all
#'     required workspace files are present on disk, and \code{FALSE}
#'     otherwise.}
#'   \item{\code{file}}{a named list that describes the missing
#'     files. The element names are the names of the producing
#'     applications and the element values are character vectors of
#'     the missing file paths relative to each application's
#'     workspace directory.}
#' }
#'
#' @details
#' The function iterates over the supplied \code{workfiles}
#' declaration and checks each file against the workspace directory
#' of its producing application. The workspace directory path is
#' resolved via \code{\link{workspace}}. When a required file does
#' not exist on disk, the file path is recorded in the \code{file}
#' list under the name of its producing application.
#'
#' When at least one file is missing, the \code{check} result is set
#' to \code{FALSE}. The recorded \code{file} list is later used by
#' \code{\link{dependency.workfiles_missing}} to produce a
#' human-readable error message.
#'
#' @seealso \code{\link{check_dependency}},
#'   \code{\link{check_dependency.context_env}},
#'   \code{\link{set_dependency}}, \code{\link{workspace}},
#'   \code{\link{dependency.workfiles_missing}}
#'
#' @keywords internal
#'
const check_dependency.localfiles = function(requires, context) {
    const err = list();
    const verbose = as.logical(getOption("verbose"));

    if (verbose) {
        print("checks for the required app dependency modules:");
        print(names(requires));    

        str(requires);
    }

    for(appName in names(requires)) {
        # the required file in the requires list is a relative file
        # path which is relative to the app workspace
        # the full path will be combine in this for loop and then
        # test for work file is exists or not.
        const workdir   = WorkflowRender::workspace(appName);
        const file_rels = requires[[appName]];
        const checks    = `${workdir}/${file_rels}` |> which(filename -> !file.exists(filename));

        if (length(checks) > 0) {
            err[[appName]] = checks;
        }
    }

    if (length(err) == 0) {
        NULL;
    } else {
        return(err);
    }
}