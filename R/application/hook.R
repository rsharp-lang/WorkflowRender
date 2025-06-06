#' Add workflow app component into the registry
#'
#' @param app the app object which is generated via the ``app`` function
#' 
#' @details the application module will be add to the ``context$workflow`` tuple list.
#' 
const hook = function(app) {
    const ssid      = NULL;
    const context   = .get_context(ssid);
    const pool      = context$workflow;
    const symbolMap = context$symbols;
    const verbose   = as.logical(getOption("verbose"));

    if (is.function(app)) {
        if (verbose) {
            print("register a function as the application module:");
            print(app);
        }

        # build application module by parsing 
        # the function metadata.
        app <- __build_app(f = app);
    }

    const app_name = app$name;

    if (nchar(app_name) == 0) {
        print("We found that an application module has in-correct configuration:");
        str(app);
        throw_err("workflow app name could not be empty!");
    }

    if (!app_check.signature(app)) {
        throw_err([
            "invalid app object signature", 
            "you sould construct the app module via the 'app' function!"
        ]);
    } else {
        pool[[app_name]] = app;
        symbolMap[[get_functionName(app$call)]] = app_name;
    }

    # turn on/activate current analysis app by default
    context$pipeline = append(context$pipeline, app_name);
    context$symbols  = symbolMap; 

    # update the global context symbol
    set(globalenv(), paste([ __global_ctx,ssid],sep="-"), context);

    invisible(NULL);
}