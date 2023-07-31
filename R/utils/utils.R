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

    msg <- unlist(msg);

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
    msg <- unlist(msg);

    print("workflow error:");
    print(msg);

    stop(msg);
}

const get_timestamp = function() {
    toString(now(), "yyyy-MM-dd hh-mm-ss");
}