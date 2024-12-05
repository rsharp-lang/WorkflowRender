
#' get app workspace location
#' 
#' @param app the app list object or just the app name its 
#'    character text value.
#'
#' @return a character vector of the workspace directory path
#'    of the specific analysis application. 
#' 
#' @details the verbose option could be config from the 
#'    commandline option: ``--verbose``
#'
const workspace = function(app) {
    const verbose   = as.logical(getOption("verbose"));
    const context   = .get_context();
    const temp_root = context$temp_dir;
    const app_name  = get_app_name(app);
    const workdir   = normalizePath(`${temp_root}/workflow_tmp/${app_name}/`);
    const program   = context$pipeline;

    if (verbose) {
        print("view of the given app object for get its workspace dir:");
        print("get app_name:");
        str(app_name);
        print("get pipeline workflow components:");
        str(program);
        # str(app);
    };

    if (!(app_name in program)) {
        echo_warning(`The app(${app_name}) has not been registered in the analysis context yet.`, app);
    };

    workdir;
}

#' Construct of the file path inside an app workspace
#' 
#' @param app this app parameter value could be in 3 kinds 
#'    of data type:
#' 
#'    1. app tuple list object, which is created via the ``app`` function.
#'    2. the app name character vector
#'    3. the workfile path expression, should be in format like: ``app://relpath/to/file.ext``
#' 
#' @details the workfile path expression is in format string of: ``app://filepath``,
#'    example as ``getMzSet://mzset.txt``, where we could parse the reference information
#'    from this character string: app name is ``getMzSet``, and the relpath data is
#'    ``mzset.txt``. so, such configuation could be equals to the function invoke
#'    of the workfile function: ``workfile("getMzSet", "/mzset.txt");``.
#' 
const workfile = function(app, relpath = NULL) {
    if (is.empty(relpath)) {
        if (is.character(app)) {
            relpath <- __workfile_uri_parser(app);

            # gets the internal workfile reference
            # its physical file path
            file.path(WorkflowRender::workspace(relpath$app), relpath$file);
        } else {
            throw_err("the given expression value should be an internal workfile path reference!");
        }
    } else {
        file.path(WorkflowRender::workspace(app), relpath);
    }
}

#' Get workspace root directory
#'
#' @details actually this function will returns the ``output`` dir 
#'    path which is set via the ``init_context`` function
#' 
const workdir_root = function() {
    .get_context()$root;
}