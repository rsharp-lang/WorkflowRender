#' Analysis Application Module Constructor
#'
#' @description
#' Constructs a new analysis application module object from a callable
#' function and its associated metadata. The returned list object is
#' the canonical representation of a workflow module and is the value
#' that is registered into the workflow context via the
#' \code{\link{hook}} function.
#'
#' @param name a character vector of the analysis application name.
#'   The name is used as the unique identifier of the module inside
#'   the workflow registry and is also used to derive the workspace
#'   directory path of the module.
#' @param analysis a callable function that implements the data
#'   analysis content of the module. The function declaration
#'   signature for this parameter value requires exactly two
#'   parameters named \code{app} and \code{context}; see the
#'   documentation of \code{\link{app_check.delegate}} for the
#'   rationale behind this constraint.
#' @param desc a character vector of the human-readable description
#'   of the analysis application. The default value of
#'   \code{"no description"} is used when no description is supplied.
#' @param dependency the dependency declaration of the application
#'   module, usually produced by the \code{\link{set_dependency}}
#'   function. The dependency declaration describes the environment
#'   symbols and the workspace files that the module requires in
#'   order to run successfully. The default value of \code{NULL}
#'   means that the module has no declared dependencies.
#'
#' @return
#' A named list object that represents the analysis application
#' module. The list contains the following slots:
#' \describe{
#'   \item{\code{name}}{the analysis application name.}
#'   \item{\code{call}}{the analysis function to be invoked.}
#'   \item{\code{desc}}{the human-readable description.}
#'   \item{\code{dependency}}{the dependency declaration list.}
#'   \item{\code{disable}}{a logical flag initialized to \code{FALSE}
#'     that can be flipped at runtime by \code{\link{set_disable}}.}
#' }
#'
#' @details
#' Before constructing the application object, the function validates
#' the declaration signature of the supplied \code{analysis} function
#' via \code{\link{app_check.delegate}}. When the signature is
#' invalid (i.e. the function does not declare exactly two parameters
#' named \code{app} and \code{context}), the workflow is aborted via
#' \code{\link{throw_err}} with an appropriate error message.
#'
#' @examples
#' \dontrun{
#' my_module <- app(
#'   name = "demo",
#'   analysis = function(app, context) {
#'     print("running demo module");
#'   },
#'   desc = "a demo analysis module"
#' );
#' hook(my_module);
#' }
#'
#' @seealso \code{\link{hook}}, \code{\link{set_dependency}},
#'   \code{\link{app_check.delegate}}, \code{\link{set_disable}}
#'
#' @author xieguigang
#'
const app = function(name, analysis,
                     desc = "no description",
                     dependency = NULL) {

    # check of the function signature
    if (!app_check.delegate(analysis)) {
        throw_err("invalid function declare signature!");
    }

    list(
        name = name,
        call = analysis,
        desc = desc,
        dependency = dependency,
        disable = FALSE
    );
}


