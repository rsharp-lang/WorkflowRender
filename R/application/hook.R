#' Add workflow app component into the registry
#'
#' @param app the app object which is generated via the ``app`` function
#' 
const hook = function(app) {
    const context   = .get_context();
    const pool      = context$workflow;
    const symbolMap = context$symbols;

    if (!app_check.signature(app)) {
        throw_err([
            "invalid app object signature", 
            "you sould construct the app module via the 'app' function!"
        ]);
    } else {
        pool[[app$name]] = app;
        symbolMap[[get_functionName(app$call)]] = app$name;
    }

    # turn on/activate current analysis app by default
    context$pipeline = append(context$pipeline, app$name);
    context$symbols  = symbolMap; 

    # update the global context symbol
    set(globalenv(), __global_ctx, context);

    invisible(NULL);
}