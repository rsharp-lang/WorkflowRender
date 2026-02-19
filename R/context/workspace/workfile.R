#' Construct of the file path inside an app workspace
#' 
#' @param app this app parameter value could be in 3 kinds 
#'    of data type:
#' 
#'    1. app tuple list object, which is created via the ``app`` function.
#'    2. the app name character vector
#'    3. the workfile path expression, should be in format like: ``app://relpath/to/file.ext``
#' @param ssid the session id for multiple user environment, default NULL means global user environment
#' 
#' @return the data file path of the required reference file inside this workflow 
#' 
#' @details the workfile path expression is in format string of: ``app://filepath``,
#'    example as ``getMzSet://mzset.txt``, where we could parse the reference information
#'    from this character string: app name is ``getMzSet``, and the relpath data is
#'    ``mzset.txt``. so, such configuation could be equals to the function invoke
#'    of the workfile function: ``workfile("getMzSet", "/mzset.txt");``.
#' 
const workfile = function(app, relpath = NULL, ssid = NULL, verbose = FALSE) {
    if (is.empty(relpath)) {
        if (is.character(app)) {
            relpath <- __workfile_uri_parser(app);

            # gets the internal workfile reference
            # its physical file path
            file.path(WorkflowRender::workspace(relpath$app, ssid, verbose = verbose), relpath$file);
        } else {
            throw_err("the given expression value should be an internal workfile path reference!");
        }
    } else {
        file.path(WorkflowRender::workspace(app, ssid, verbose = verbose), relpath);
    }
}