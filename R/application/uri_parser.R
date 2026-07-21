#' Internal Function for Parsing the Workfile URI Expression
#'
#' @description
#' Wraps the actual URI parser \code{\link{__workfiles_data}} with a
#' short-circuit for the empty-input case. This function is invoked
#' internally by \code{\link{__build_app}} to convert the
#' \code{@workfiles} attribute of a tagged function into the
#' structured dependency list expected by \code{\link{set_dependency}}.
#'
#' @param files_uri a character vector of workfile URI expressions
#'   in the format \code{app://relpath/to/file.ext}. May be
#'   \code{NULL} or empty.
#'
#' @return
#' A named list object that groups the parsed file paths by their
#' producing application name, suitable for direct use as the
#' \code{workfiles} argument of \code{\link{set_dependency}}. When
#' \code{files_uri} is empty, \code{NULL} is returned instead.
#'
#' @seealso \code{\link{__workfiles_data}},
#'   \code{\link{__workfile_uri_parser}}, \code{\link{set_dependency}}
#'
#' @keywords internal
#'
const __workfiles = function(files_uri) {
    if (length(files_uri) == 0) {
        NULL;
    } else {
        __workfiles_data(files_uri);
    }
}

#' Group the Parsed Workfile URI Expressions by Application Name
#'
#' @description
#' Parses a vector of workfile URI expressions and groups the
#' resulting file paths by their producing application name. This
#' function is the workhorse behind \code{\link{__workfiles}} and is
#' not intended to be called directly.
#'
#' @param files_uri a character vector of workfile URI expressions
#'   in the format \code{app://relpath/to/file.ext}.
#'
#' @return
#' A named list object whose element names are the application names
#' and whose element values are character vectors of the file paths
#' produced by each application.
#'
#' @seealso \code{\link{__workfiles}},
#'   \code{\link{__workfile_uri_parser}}
#'
#' @keywords internal
#'
const __workfiles_data = function(files_uri) {
    let uri = lapply(files_uri, si -> __workfile_uri_parser(si));
    let app = as.character(uri@app);
    let file = as.character(uri@file);
    let app_groups = data.frame(app, file)
    |> as.list(byrow = TRUE)
    |> groupBy("app")
    |> lapply(app -> app@file)
    ;

    app_groups;
}

#' Parse a Single Workfile URI Expression
#'
#' @description
#' Parses a single workfile URI expression of the form
#' \code{app://relpath/to/file.ext} into a list with two elements
#' that can be used to look up the physical file path via the
#' \code{\link{workfile}} function.
#'
#' @param uri a character vector that contains the workfile reference
#'   expression to be parsed.
#'
#' @return
#' A named list object that contains the necessary parameter values
#' for calling the \code{\link{workfile}} function to obtain the
#' reference file path of the required data file. The list has two
#' elements:
#' \describe{
#'   \item{\code{app}}{the name of the producing application.}
#'   \item{\code{file}}{the relative file path inside that
#'     application's workspace directory.}
#' }
#'
#' @details
#' The expected URI format is \code{app_name://file/path/to/file.txt}.
#' The function splits the input string on the \code{://} separator
#' via \code{\link{tagvalue}} and uses the left-hand side as the
#' application name and the right-hand side as the relative file path.
#'
#' @examples
#' \dontrun{
#' ref <- __workfile_uri_parser("getMzSet://mzset.txt");
#' # ref$app   == "getMzSet"
#' # ref$file  == "mzset.txt"
#' }
#'
#' @seealso \code{\link{workfile}}, \code{\link{__workfiles}},
#'   \code{\link{tagvalue}}
#'
#' @keywords internal
#'
const __workfile_uri_parser = function(uri) {
    # example as:
    # app_name://file/path/to/file.txt
    let tuple = tagvalue(uri, '://', as.list = TRUE);
    let ref = list(
        app = names(tuple),
        file = unlist(tuple)
    );

    # app, file
    return(ref);
}
