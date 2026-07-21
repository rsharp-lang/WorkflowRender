#' Add a Workflow Application Component into the Registry
#'
#' @description
#' Registers an analysis application module into the workflow context
#' so that it can be invoked by the workflow execution engine. The
#' supplied application object is appended to the \code{workflow}
#' tuple list of the context and its name is appended to the
#' \code{pipeline} execution sequence.
#'
#' @param app the application object to be registered. This parameter
#'   can be supplied in two forms:
#'   \enumerate{
#'     \item An application list object produced by the
#'       \code{\link{app}} function.
#'     \item A bare function object that has been tagged with the
#'       \code{@app} custom attribute (and optionally \code{@desc},
#'       \code{@context_env} and \code{@workfiles}). In this case the
#'       function is automatically converted into an application
#'       object via \code{\link{__build_app}} before being registered.
#'   }
#'
#' @return
#' Invisibly returns \code{NULL}. The side effect of this function is
#' the modification of the \code{workflow}, \code{pipeline} and
#' \code{symbols} slots of the workflow context stored in the global
#' environment.
#'
#' @details
#' The application module is added to the \code{context$workflow}
#' tuple list, keyed by its name. In addition, the function name of
#' the analysis callable is recorded in the \code{symbols} map of the
#' context so that the application name can later be resolved from a
#' bare function reference via
#' \code{\link{get_appName.func_reference}}.
#'
#' Before registering the module, the function performs two
#' validation checks:
#' \itemize{
#'   \item The application name must be a non-empty string. When the
#'     name is empty, the workflow is aborted via
#'     \code{\link{throw_err}}.
#'   \item The application object must pass the signature check
#'     performed by \code{\link{app_check.signature}}. When the check
#'     fails, the workflow is aborted with an explanatory error
#'     message.
#' }
#'
#' Finally, the application name is appended to the \code{pipeline}
#' slot of the context so that the module is activated by default in
#' subsequent workflow runs.
#'
#' @examples
#' \dontrun{
#' # register an application object
#' hook(app("demo", function(app, context) { print("hi"); }));
#'
#' # register a tagged function
#' [@app "demo"]
#' let demo = function(app, context) { print("hi"); };
#' hook(demo);
#' }
#'
#' @seealso \code{\link{app}}, \code{\link{__build_app}},
#'   \code{\link{app_check.signature}}, \code{\link{get_functionName}}
#'
#' @author xieguigang
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
