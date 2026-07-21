#' pull all configuration value from workflow registry
#' 
const pull_configs = function() {
    let ctx = .get_context();

    if (!("configs" in ctx)) {
        list();
    } else {
        ctx$configs;
    }
}