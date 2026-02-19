#' Get workspace root directory
#'
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' @details actually this function will returns the ``output`` dir 
#'    path which is set via the ``init_context`` function
#' 
const workdir_root = function(ssid = NULL) {
    .get_context(ssid)$root;
}

#' get directory folder path for the analysis output result
#' 
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' @details a character vector of the analysis result output directory.
#' 
const result_dir = function(ssid = NULL) {
    .get_context(ssid)$analysis;
}

const workspace_temproot = function(ssid = NULL) {
    const context   = .get_context(ssid);
    const temp_root = context$temp_dir;

    temp_root;
}