
#' get app workspace location
#' 
#' @param app the app list object or just the app name its 
#'    character text value.
#'
#' @return a character vector of the workspace directory path
#'    of the specific analysis application. 
#'
const workspace = function(app) {
    const verbose   = as.logical(getOption("verbose"));
    const context   = .get_context();
    const temp_root = context$temp_dir;
    const app_name  = get_app_name(app);
    const workdir   = normalizePath(`${temp_root}/workflow_tmp/${app_name}/`);

    if (verbose) {
        print("view of the given app object for get its workspace dir:");
        # str(app_name);
        # str(context$pipeline);
        str(app);
    };

    if (![app_name in context$pipeline]) {
        echo_warning(`The app(${app_name}) has not been registered in the analysis context yet.`, app);
    };

    workdir;
}

#' Construct of the file path inside an app workspace
#' 
const workfile = function(app, relpath) {
    file.path(workspace(app), relpath);
}

#' Get workspace root directory
#'
#' @details actually this function will returns the ``output`` dir 
#'    path which is set via the ``init_context`` function
#' 
const workdir_root = function() {
    .get_context()$root;
}