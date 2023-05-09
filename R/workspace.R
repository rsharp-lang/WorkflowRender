
#' get app workspace location
#' 
#' @param app the app list object or just the app name its 
#'    character text value.
#'
#' @return a character vector of the workspace directory path
#'    of the specific analysis application. 
#'
const workspace = function(app) {
    const context   = .get_context();
    const temp_root = context$temp_dir;
    const app_name  = get_app_name(app);
    const workdir   = normalizePath(`${temp_root}/.works/${app_name}/`);

    if (![app_name in context$pipeline]) {
        echo_warning(`The app(${app_name}) has not been registered in the analysis context yet.`, app);
    }

    workdir;
}