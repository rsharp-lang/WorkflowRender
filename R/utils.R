#' print warning message on the screen and the log file
#' 
#' @param app the app object where this warning message is produced.
#' @param msg a character vector of the warning message that this
#'    workflow produced.
#'
const echo_warning = function(msg, app = NULL) {
    const warning_log = `${.get_context()$temp_dir}/warning`;
    const link = file(warning_log, "append");
    const app_name = get_app_name(app);

    if (!is.null(app_name)) {
        msg = `[${app_name}] ${msg}`;
    }

    print(msg);
    warning(msg);
    writeLines(msg, con = link);
    close(link);
}

#' echo error message on the screen and then crash the workflow
#'
const throw_err = function(msg) {
    print("workflow error:");
    print(msg);

    stop(msg);
}

#' Helper function for get app name
#'
#' @param app the app object list itself or the character
#'    vector of the name value
#'
#' @return this function always returns the app name
#'    character vector
#'
const get_app_name = function(app) {
    if (is.list(app)) {
        app$name;
    } else if(is.function(app)) {
        # test app signature
        let fname = get_functionName(app);
        let ctx   = .get_context()$symbols;

        if (app_check.delegate(app)) {
            if (fname in ctx) {
                ctx[[fname]];
            } else {
                throw_err("Target app function is not registered in the workflow yet!");
            }
        } else {
            throw_err("we can not get the workflow app name for the given function object!");
        }
    } else {
        app;
    }
}

const get_functionName = function(f) {
    list = as.list(args(f));
    func = list[[""]];
    func$symbol;
}

const get_timestamp = function() {
    toString(now(), "yyyy-MM-dd hh-mm-ss");
}