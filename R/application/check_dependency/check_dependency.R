#' Check the Dependencies of an Analysis Application
#'
#' @description
#' Generic function that validates the dependencies of an analysis
#' application against the current workflow context. The function
#' dispatches to one of the specialized implementations based on the
#' type of the dependency declaration found in the application
#' object.
#'
#' @param app the application object whose dependencies should be
#'   checked. The object is expected to be a list with a
#'   \code{dependency} slot, as produced by \code{\link{app}}.
#' @param context the workflow context object that is used to resolve
#'   the dependency declarations. The object is typically obtained
#'   via \code{\link{.get_context}}.
#'
#' @return
#' A named list object that summarizes the result of the dependency
#' check. The list contains the following elements:
#' \describe{
#'   \item{\code{check}}{a logical value that is \code{TRUE} when all
#'     dependencies are satisfied and \code{FALSE} otherwise.}
#'   \item{\code{context}}{a list describing the missing or
#'     mismatched environment symbols, when applicable.}
#'   \item{\code{file}}{a list describing the missing workspace
#'     files, when applicable.}
#' }
#'
#' @details
#' The function inspects the \code{dependency} slot of the supplied
#' application object and dispatches to the appropriate
#' implementation:
#' \itemize{
#'   \item When the dependency declaration contains a
#'     \code{context_env} slot, the function dispatches to
#'     \code{\link{check_dependency.context_env}} to validate the
#'     environment symbol dependencies.
#'   \item When the dependency declaration contains a
#'     \code{tempfiles} slot, the function dispatches to
#'     \code{\link{check_dependency.localfiles}} to validate the
#'     workspace file dependencies.
#' }
#'
#' The two checks are combined so that the overall \code{check}
#' result is \code{TRUE} only when both the environment symbol and
#' the workspace file dependencies are satisfied.
#'
#' @examples
#' \dontrun{
#' result <- check_dependency(my_app, .get_context());
#' if (!result$check) {
#'   print("dependency check failed!");
#' }
#' }
#'
#' @seealso \code{\link{check_dependency.context_env}},
#'   \code{\link{check_dependency.localfiles}},
#'   \code{\link{set_dependency}}, \code{\link{.internal_call}}
#'
#' @author xieguigang
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
                check   = FALSE,
                context = check_env,
                file    = check_files
            ));
        }
    }
}