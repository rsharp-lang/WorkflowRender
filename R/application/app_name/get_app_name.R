
#' Helper function for get app name
#'
#' @param app the app object list itself or the character
#'    vector of the name value
#'
#' @return this function always returns the app name
#'    character vector
#'
const get_app_name = function(app) {
    let verbose as boolean = as.logical(getOption("verbose"));

    if (is.list(app)) {
        return(get_appName.obj(app));
    } else {
        if(is.function(app)) {
            if (verbose) {
                print("try to get the app reference name from a analysis function!");
            }

            get_appName.func_reference(app);
        } else {
            if (verbose) {
                print(`the given app object '${app}' is a name reference to the application module!`);
            }
            app;
        }
    }
}