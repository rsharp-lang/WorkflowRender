
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
        if (verbose) {
            print("app object is a list.");
        }

        if (nchar(app$name) > 0) {
            return(app$name);
        } else {
            throw_err(["invalid app object: ", JSON::json_encode(app)]);
        }        
    } else if(is.function(app)) {
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

const app_not_registered = "Target app function is not registered in the workflow yet!";
const invalid_app_target = "we can not get the workflow app name for the given function object!";

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

#' get function name
#' 
const get_functionName = function(f) {
    let list = as.list(args(f));
    let func = list[[""]];

    return(func$symbol);
}