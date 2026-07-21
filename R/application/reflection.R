#' Build a Workflow Application Object from a Tagged Function
#'
#' @description
#' Builds a new workflow application module object based on the
#' custom attribute values that have been tagged on the target
#' function. This function is invoked internally by
#' \code{\link{hook}} when a bare function (rather than an
#' application list object) is supplied for registration.
#'
#' @param f the target function \code{f} that has been tagged with
#'   the required attribute data. The following custom attributes are
#'   inspected:
#'   \describe{
#'     \item{\code{app}}{(character) The application name. When this
#'       attribute is missing or empty, the function emits a warning
#'       and returns \code{NULL}.}
#'     \item{\code{desc}}{(character) The human-readable description
#'       of the application. When this attribute is missing, the
#'       function attempts to extract a description from the
#'       \code{r-sharp-help} JSON attribute of the function.}
#'     \item{\code{context_env}}{(list) The environment symbol
#'       dependency declaration, forwarded to
#'       \code{\link{set_dependency}}.}
#'     \item{\code{workfiles}}{(list) The workspace file dependency
#'       declaration, parsed by \code{\link{__workfiles}} and then
#'       forwarded to \code{\link{set_dependency}}.}
#'   }
#'
#' @return
#' A named list object that represents the analysis application
#' module, as produced by \code{\link{app}}. When the \code{app}
#' attribute is missing or empty, the function returns \code{NULL}
#' after emitting a warning via \code{\link{echo_warning}}.
#'
#' @details
#' When the \code{desc} attribute is missing or empty, the function
#' falls back to the \code{r-sharp-help} JSON attribute of the
#' function (when present) and extracts either the \code{description}
#' or the \code{title} field from the parsed JSON object. This allows
#' the description text to be derived automatically from the function
#' comment documentation when no explicit \code{@desc} attribute has
#' been supplied.
#'
#' @examples
#' \dontrun{
#' [@app "demo"]
#' [@desc "a demo module"]
#' let demo = function(app, context) { print("hi"); };
#'
#' app_obj <- __build_app(demo);
#' }
#'
#' @seealso \code{\link{hook}}, \code{\link{app}},
#'   \code{\link{set_dependency}}, \code{\link{__workfiles}},
#'   \code{\link{echo_warning}}
#'
#' @keywords internal
#' @author xieguigang
#'
const __build_app = function(f) {
    let attrs = .Internal::attributes(f);
    let app_name = attrs$app || "";
    let desc = attrs$desc;
    let context_env = attrs$context_env;
    let workfiles = attrs$workfiles;

    if (str_empty(desc, test_empty_factor=TRUE)) {
        # get description text from the function comment docs
        let json_str = attr(f, which = "r-sharp-help");

        if (!is.null(json_str)) {
            json_str = JSON::json_decode(json_str);
            json_str = (json_str$description) || (json_str$title);

            desc <- json_str;
        }
    }

    if (nchar(app_name) == 0) {
        echo_warning([
            "invalid application function configuration was found:",
            JSON::json_encode(attrs),
            JSON::json_encode(f)
        ]);

        return(NULL);
    } else {
        app(app_name, analysis = f,
                    desc = desc,
                    dependency = set_dependency(
                        context_env = context_env,
                        workfiles = __workfiles(files_uri = workfiles)
                    ));
    }
}

