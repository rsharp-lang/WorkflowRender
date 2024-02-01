#' Check for the upstream file dependency
#' 
#' @param requires the required temp work files, should be a tuple list
#'    object that contains the app reference and the related temp workfile,
#'    example data format of this tuple list would be:
#' 
#'       list(app1 = [file1, file2, ...], app2 = file3, ...)
#' 
#' @details the workfile path in the ``requires`` tuple file list should be 
#'    a relative file path which is relative to the app workdir
#'
const check_dependency.localfiles = function(requires, context) {
    const err = list();
    const verbose = as.logical(getOption("verbose"));

    if (verbose) {
        print("checks for the required app dependency modules:");
        print(names(requires));    

        str(requires);
    }

    for(appName in names(requires)) {
        # the required file in the requires list is a relative file
        # path which is relative to the app workspace
        # the full path will be combine in this for loop and then
        # test for work file is exists or not.
        const workdir   = WorkflowRender::workspace(appName);
        const file_rels = requires[[appName]];
        const checks    = `${workdir}/${file_rels}` |> which(filename -> !file.exists(filename));

        if (length(checks) > 0) {
            err[[appName]] = checks;
        }
    }

    if (length(err) == 0) {
        NULL;
    } else {
        return(err);
    }
}