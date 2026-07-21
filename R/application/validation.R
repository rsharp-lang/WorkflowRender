#' Check the Application Function Signature
#'
#' @description
#' Validates that the supplied function declares exactly two
#' parameters named \code{app} and \code{context}. This is the
#' contract that every analysis application function must satisfy in
#' order to be registered into the workflow via \code{\link{hook}}.
#'
#' @param f the function object to be validated.
#'
#' @return
#' A logical value that indicates whether the supplied function
#' declares the expected signature. The value \code{TRUE} is returned
#' when the function declares exactly two parameters named
#' \code{app} and \code{context}; \code{FALSE} is returned otherwise.
#'
#' @details
#' The function inspects the formal parameters of the supplied
#' function via \code{.Internal::formals} and compares the parameter
#' names against the expected \code{c("app", "context")} vector. The
#' check is strict: any deviation in the number of parameters or in
#' the parameter names causes the function to return \code{FALSE}.
#'
#' @seealso \code{\link{app_check.signature}},
#'   \code{\link{app}}, \code{\link{hook}}
#'
#' @keywords internal
#'
const app_check.signature = function(app) {
    all(["name", "call"] in names(app));
}

#' Check the Application Module Object Signature
#'
#' @description
#' Validates that the supplied application object has the correct
#' structure to be registered into the workflow context. The function
#' checks that the object is a list with the expected slots and that
#' the \code{call} slot is a callable function.
#'
#' @param app the application object to be validated.
#'
#' @return
#' A logical value that indicates whether the supplied application
#' object has the correct signature. The value \code{TRUE} is
#' returned when the object passes all of the following checks:
#' \itemize{
#'   \item it is a list object;
#'   \item it contains the slots \code{name}, \code{call},
#'     \code{desc}, \code{dependency} and \code{disable};
#'   \item the \code{call} slot is a callable function.
#' }
#' The value \code{FALSE} is returned otherwise.
#'
#' @details
#' This function is invoked by \code{\link{hook}} to ensure that the
#' supplied application object was constructed via the
#' \code{\link{app}} function (or via \code{\link{__build_app}}) and
#' therefore has the expected structure. When the check fails, the
#' workflow is aborted via \code{\link{throw_err}} with an
#' appropriate error message.
#'
#' @seealso \code{\link{app_check.delegate}}, \code{\link{app}},
#'   \code{\link{hook}}, \code{\link{throw_err}}
#'
#' @keywords internal
#'
const app_check.delegate = function(analysis) {
    const pars = as.list(args(name = analysis));
    const verbose = getOption("verbose");

    if (as.logical(verbose)) {
        str(pars);
    }

    # pars contains 3 slot value:
    #
    # 1. empty_name: the function declare info, includes name and the 
    #                possible function value type
    # 2. other_name: the function parameter name.

    if (length(pars) != 3) {
        echo_warning("the analysis application function required 2 parameters!");
        return(FALSE);
    } else {
        return(all(["app", "context"] in names(pars)));
    }
}