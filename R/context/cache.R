#' Work with cache file
#' 
#' @details this function will work around with the specific given 
#'   cache file: this function will do nothing if the cache file is
#'   already exists or invoke the ``create`` function for when file
#'   exists of the cache data is false.
#' 
#' @param create a callable function that accept a file path parameter
#'   to create the target cache file.
#' 
const use_cache = function(filepath, create) {
    if (!has_cachefile(filepath)) {
        create(filepath);
    } else {
        # do nothing
    }
}

#' check the cache file is exists or not
#' 
#' @return a logical value for indicates the specific given file is 
#' existed or not, for the filepath value in situations of:
#' 
#'  1. empty or null string value
#'  2. file is not existed
#'  3. file size is ZERO
#' 
#' will be determined as false.
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