#' display the content of DESCRIPTION file of current package
const .onLoad = function() {
    str(description("WorkflowRender"));
}