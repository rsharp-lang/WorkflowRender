#' Work with a Cache File
#'
#' @description
#' Conditionally creates a cache file by invoking a user-supplied
#' factory function only when the cache file does not yet exist (or
#' is considered invalid). This pattern allows expensive computations
#' to be skipped on subsequent runs when the cached result is already
#' available on disk.
#'
#' @param filepath a character vector of the cache file path to be
#'   tested and (when necessary) created.
#' @param create a callable function that accepts a single file path
#'   parameter and is responsible for producing the target cache file
#'   at that location. This function is invoked only when
#'   \code{\link{has_cachefile}} reports that the cache file is missing
#'   or invalid.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the potential creation of the cache file at the supplied path.
#'
#' @details
#' This function works around the specific given cache file as
#' follows: it does nothing if the cache file already exists (and is
#' non-empty), and it invokes the supplied \code{create} function
#' when the cache file is missing or has a size of zero bytes. The
#' validity of the cache file is determined by
#' \code{\link{has_cachefile}}.
#'
#' @examples
#' \dontrun{
#' use_cache("/path/to/cache.rds", function(path) {
#'   saveRDS(compute_expensive_result(), path);
#' });
#' }
#'
#' @seealso \code{\link{has_cachefile}}
#'
#' @author xieguigang
#'
const use_cache = function(filepath, create) {
    if (!has_cachefile(filepath)) {
        create(filepath);
    } else {
        # do nothing
    }
}

#' Check Whether a Cache File Exists
#'
#' @description
#' Tests whether a given cache file path refers to an existing,
#' non-empty file that can be safely reused as a cache. The function
#' returns \code{FALSE} for any of the following situations:
#' \enumerate{
#'   \item the \code{filepath} value is \code{NULL};
#'   \item the \code{filepath} value is an empty string;
#'   \item the file does not exist on disk;
#'   \item the file exists but has a size of zero bytes.
#' }
#'
#' @param filepath a character vector of the cache file path to be
#'   tested.
#'
#' @return
#' A logical value that indicates whether the specific given file is
#' a valid cache file. The value \code{TRUE} is returned only when the
#' file exists and has a non-zero size; \code{FALSE} is returned
#' otherwise.
#'
#' @seealso \code{\link{use_cache}}, \code{\link{file.exists}},
#'   \code{\link{file.size}}
#'
#' @author xieguigang
#'
const has_cachefile = function(filepath) {
    if (is.null(filepath)) {
        return(FALSE);
    }
    if (filepath == "") {
        return(FALSE);
    }
    if (!file.exists(filepath)) {
        return(FALSE);
    }
    if (file.size(filepath) == 0) {
        return(FALSE);
    }

    return(TRUE);
}
