
#' get app workspace location
#' 
#' @param app the app list object or just the app name its 
#'    character text value.
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' 
#' @return a character vector of the workspace directory path
#'    of the specific analysis application. 
#' 
#' @details the verbose option could be config from the 
#'    commandline option: ``--verbose``
#'
const workspace = function(app, ssid = NULL, verbose = FALSE) {
    const verboseOpt = as.logical(getOption("verbose", default = verbose));
    const context    = .get_context(ssid);
    const temp_root  = context$temp_dir;
    const app_name   = get_app_name(app);
    const workdir    = normalizePath(`${temp_root}/workflow_tmp/${app_name}/`);
    const program    = context$pipeline;

    if (verboseOpt) {
        print("view of the given app object for get its workspace dir:");
        print("get app_name:");
        str(app_name);
        print("get pipeline workflow components:");
        str(program);
        print("combine the workdir path:");
        print(workdir);
    };

    if (!(app_name in program)) {
        echo_warning(`The app(${app_name}) has not been registered in the analysis context yet.`, app);
    };

    workdir;
}

