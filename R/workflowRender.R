#' Call this function to start run workflow
#' 
#' @param registry a callable function for create the workflow registry, 
#'    this parameter could be nothing if this workflow processor apps has
#'    been registered into the workflow as the processor components via 
#'    the ``hook`` function.
#' @param disables a tuple list object that contains the workflow module
#'    activate swtches. the list tuple key name should be the analysis app
#'    name and the corresponding slot value should be a logical value for
#'    indicates that the workflow module is disable or not: true for disable 
#'    and skip, and false or null and missing for enable the corresponding
#'    workflow module
#' 
#' @details A workflow is consist with a set of the analysis modules in side,
#'    the executative sequence define in workflow is based on the module name
#'    vector in the pipeline data slot
#' 
#' @examples
#' \dontrun{
#' # example for run workflow
#' 
#' # 1. initialize of the workspace filesystem
#' WorkflowRender::init_context( "/path/to/workdir/" );
#' # 2. setup the module runtime parameters
#' #    where the arg1,arg2 is the parameter name which could be get from
#' #    runtime environment via `get_config` function
#' WorkflowRender::set_config(list(arg1 = "xxx", arg2 = "xxx"));
#' # 3. hook of the workflow module
#' #    define an example workflow module, workflow module name is defined via `@app` custom attribute of the module function 
#' [@app "example1"]
#' let example1 = function() {
#'    # just echo the value of arg1 at here
#'    message(get_config("arg1"));
#' }
#' [@app "example2"]
#' let example2 = function() {
#'    # just echo the value of arg2 at here
#'    message(get_config("arg2"));
#' }
#' # optional, then hook of the workflow function into runtime
#' # these could be hook inside the registry function
#' WorkflowRender::hook(example1); 
#' WorkflowRender::hook(example2); 
#' # 4. run the workflow: example1 -> example2
#' WorkflowRender::run();
#' # if want to run a specific workflow module, use the debug parameter
#' # WorkflowRender::run(debug = "example2");
#' # # hook the workflow modules via registry function
#' # WorkflowRender::run(registry = function() {
#' #    WorkflowRender::hook(example1); 
#' #    WorkflowRender::hook(example2); 
#' # });
#' # 5. release the memory data, close the logfile
#' WorkflowRender::finalize();
#' }
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
