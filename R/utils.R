const echo_warning = function(msg) {
    const warning_log = `${.get_context()$temp_dir}/warning`;
    const link = file(warning_log, "append");

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