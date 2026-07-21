const app_not_registered = "target app function is not registered in the workflow yet!";
const invalid_app_target = "we can not get the workflow app name for the given function object!";

#' get app name from the analysis function as reference
#' 
const get_appName.func_reference = function(app) {
    # test app signature
    let fname = get_functionName(app);
    let ctx   = .get_context()$symbols;
    let verbose = as.logical(getOption("verbose"));

    if (verbose) {
        print("view of the workflow symbol maps:");
        str(ctx);
    }

    if (app_check.delegate(app)) {
        if (fname in ctx) {
            ctx[[fname]];
        } else {
            throw_err(app_not_registered);
        }
    } else {
        throw_err(invalid_app_target);
    }
}
