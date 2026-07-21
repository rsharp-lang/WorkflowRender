#' Run the Composed Data Analysis Workflow
#'
#' @description
#' Launches execution of a modular data analysis workflow that has been
#' assembled from individual analysis application modules. The execution
#' order of the modules is determined by the pipeline vector stored inside
#' the workflow context, and each module is invoked sequentially by the
#' internal execution engine.
#'
#' @param registry an optional callable function used to register workflow
#'    modules into the runtime registry. This parameter can be omitted
#'    (i.e. left as \code{NULL}) when the workflow processor applications
#'    have already been hooked into the workflow via the \code{\link{hook}}
#'    function. When provided, the function is invoked with no arguments
#'    and is expected to call \code{\link{hook}} for each module that
#'    should participate in the workflow.
#' @param disables a named list object that contains the workflow module
#'    activation switches. The list element name should be the analysis
#'    application name and the corresponding slot value should be a logical
#'    value that indicates whether the workflow module is disabled or not:
#'    \code{TRUE} disables and skips the module, while \code{FALSE},
#'    \code{NULL} or a missing value enables the corresponding workflow
#'    module.
#' @param debug an optional character vector of module names that should
#'    be executed in this run. When non-empty, the pipeline sequence is
#'    replaced by this vector via \code{\link{definePipeline}}, which is
#'    convenient for debugging a specific subset of the workflow modules.
#'
#' @details
#' A workflow is composed of a set of analysis modules. The execution
#' sequence of the workflow is determined by the module name vector stored
#' in the \code{pipeline} slot of the workflow context. Each module is
#' constructed via the \code{\link{app}} function (or auto-built from a
#' tagged function via \code{\link{hook}}) and is invoked in turn by the
#' internal runner \code{\link{__runImpl}}.
#'
#' When the \code{registry} parameter is provided, it is invoked first so
#' that the analysis modules can be hooked into the workflow context. When
#' the \code{debug} parameter is non-empty, the pipeline is overridden to
#' run only the specified modules, which is useful for testing or
#' debugging individual stages of the workflow.
#'
#' Verbose diagnostic output (pipeline list, configuration values and
#' per-module execution logs) can be enabled by setting
#' \code{options(verbose = TRUE)} before calling this function.
#'
#' @return
#' This function invisibly returns \code{NULL}. The side effects of the
#' call are the execution of the workflow modules, the modification of the
#' workflow context in-place, and the production of analysis output files
#' inside the configured workspace.
#'
#' @examples
#' \dontrun{
#' # example for run workflow
#'
#' # 1. initialize of the workspace filesystem
#' WorkflowRender::init_context("/path/to/workdir/");
#'
#' # 2. setup the module runtime parameters
#' #    where arg1, arg2 are parameter names that can be accessed
#' #    at runtime via the `get_config` function
#' WorkflowRender::set_config(list(arg1 = "xxx", arg2 = "xxx"));
#'
#' # 3. hook of the workflow module
#' #    define an example workflow module, the workflow module name is
#' #    defined via the `@app` custom attribute of the module function
#' [@app "example1"]
#' let example1 = function(app, context) {
#'    # just echo the value of arg1 at here
#'    message(get_config("arg1"));
#' }
#' [@app "example2"]
#' let example2 = function(app, context) {
#'    # just echo the value of arg2 at here
#'    message(get_config("arg2"));
#' }
#'
#' # optional, then hook of the workflow function into runtime
#' # these could be hooked inside the registry function
#' WorkflowRender::hook(example1);
#' WorkflowRender::hook(example2);
#'
#' # 4. run the workflow: example1 -> example2
#' WorkflowRender::run();
#'
#' # if you want to run a specific workflow module, use the debug parameter
#' # WorkflowRender::run(debug = "example2");
#'
#' # hook the workflow modules via a registry function
#' # WorkflowRender::run(registry = function() {
#' #    WorkflowRender::hook(example1);
#' #    WorkflowRender::hook(example2);
#' # });
#'
#' # 5. release the memory data, close the logfile
#' WorkflowRender::finalize();
#' }
#'
#' @seealso
#' \code{\link{init_context}}, \code{\link{hook}}, \code{\link{definePipeline}},
#' \code{\link{finalize}}, \code{\link{__runImpl}}
#'
#' @author xieguigang
#'
const run = function(registry = NULL, disables = list(), debug = c()) {
    const verbose = as.logical(getOption("verbose"));

    if (!is.null(registry)) {
        do.call(registry, args = list());
    }
    if (length(debug) > 0) {
        # setup target workflow module to run
        WorkflowRender::definePipeline(debug);
    }

    if (verbose) {
        print("pipeline modules to run in current workflow:");
        print(.get_context()$pipeline);
        print("workflow parameters:");
        str(.get_context()$configs);
    }

    __runImpl(context = .get_context(), disables);
}
