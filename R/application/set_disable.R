#' Set workflow application disable flag 
#'
#' @param app the app name or the app object itself
#'
const set_disable = function(app, flag = TRUE) {
    const app_name = get_app_name(app);
    const ctx      = .get_context();

    if (app_name in ctx$workflow) {
        app = ctx$workflow[[app_name]];
        app$disable = flag;
    }

    invisible(NULL);
}