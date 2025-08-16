#' print warning message on the screen and the log file
#' 
#' @param app the app object where this warning message is produced.
#' @param msg a character vector of the warning message that this
#'    workflow produced.
#'
const echo_warning = function(msg, app = NULL, ssid = NULL) {
    const warning_log = `${.get_context(ssid)$temp_dir}/warning`;
    const link = file(warning_log, "append");
    const app_name = get_app_name(app);

    msg <- unlist(msg);

    if (!is.null(app_name)) {
        msg = `[${app_name}] ${msg}`;
    }

    warning(msg, immediate.=TRUE);
    writeLines(msg, con = link);
    close(link);
}

#' echo error message on the screen and then crash the workflow
#'
#' @details a wrapper of the ``stop`` function.
#' 
const throw_err = function(msg, app = NULL, ssid = NULL) {
    let error_log = `${.get_context(ssid)$temp_dir}/error`;

    msg <- unlist(msg);

    print("workflow error:");
    print(msg);
    writeLines(msg, con = error_log);

    .Internal::stop(msg);
}

#' get a character vector of current timespan
#' 
#' @details this character vector of the current timespan 
#'    could be used inside a file path safely.
#' 
const get_timestamp = function() {
    toString(now(), "yyyy-MM-dd hh-mm-ss");
}