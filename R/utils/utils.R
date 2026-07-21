#' Print a Warning Message to the Screen and the Log File
#'
#' @description
#' Emits a warning message both to the standard R# warning stream and
#' to the warning log file located inside the workflow temporary
#' directory. The message is prefixed with the name of the application
#' module that produced it (when available) so that the source of the
#' warning can be easily identified when reviewing the log file.
#'
#' @param msg a character vector (or any object coercible to one) of
#'   the warning message text that the workflow produced. The elements
#'   of the vector are unlisted and concatenated before being written.
#' @param app the application object that produced this warning
#'   message. This parameter can be \code{NULL} when the warning is not
#'   associated with a specific application module. When non-null, the
#'   application name is resolved via \code{\link{get_app_name}} and
#'   used as a prefix for the message.
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the global
#'   session environment.
#'
#' @return
#' Invisibly returns \code{NULL}. The side effects of this function
#' are the emission of an immediate warning to the standard output and
#' the appending of the warning message to the warning log file.
#'
#' @details
#' The warning log file path is constructed as
#' \code{<temp_dir>/warning}, where \code{temp_dir} is the temporary
#' directory of the current workflow context. The file is opened in
#' append mode so that successive warnings accumulate across the entire
#' workflow run, and is closed before the function returns to ensure
#' that the data is flushed to disk.
#'
#' @examples
#' \dontrun{
#' echo_warning("value of arg1 is missing, using default.");
#' }
#'
#' @seealso \code{\link{throw_err}}, \code{\link{get_app_name}},
#'   \code{\link{.get_context}}
#'
#' @author xieguigang
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

#' Echo an Error Message and Crash the Workflow
#'
#' @description
#' Prints an error message to the standard output, writes the same
#' message to the error log file located inside the workflow temporary
#' directory, and then terminates the workflow by raising a stop
#' condition. This function is the canonical way to report fatal
#' errors from inside workflow modules.
#'
#' @param msg a character vector (or any object coercible to one) of
#'   the error message text. The elements of the vector are unlisted
#'   and concatenated before being displayed and written.
#' @param app reserved for future use; the application object that
#'   produced this error message. Currently not used by the
#'   implementation but accepted for API symmetry with
#'   \code{\link{echo_warning}}.
#' @param ssid the session identifier used for the multi-user
#'   environment. The default value of \code{NULL} refers to the global
#'   session environment.
#'
#' @return
#' This function does not return; it terminates the workflow via
#' \code{.Internal::stop()}.
#'
#' @details
#' This function is a thin wrapper around the \code{stop} function
#' that additionally writes the error message to the error log file
#' located at \code{<temp_dir>/error}. The error log is overwritten on
#' each invocation, which means that only the most recent fatal error
#' is preserved in the log file at the end of a failed workflow run.
#'
#' @examples
#' \dontrun{
#' throw_err("required input file is missing!");
#' }
#'
#' @seealso \code{\link{echo_warning}}, \code{\link{.get_context}}
#'
#' @author xieguigang
#'
const throw_err = function(msg, app = NULL, ssid = NULL) {
    let error_log = `${.get_context(ssid)$temp_dir}/error`;

    msg <- unlist(msg);

    print("workflow error:");
    print(msg);
    writeLines(msg, con = error_log);

    .Internal::stop(msg);
}

#' Get a Character Vector of the Current Timestamp
#'
#' @description
#' Returns the current date and time as a character vector formatted
#' in a way that is safe to use inside a file path. The default format
#' \code{yyyy-MM-dd hh-mm-ss} avoids characters such as colons that
#' are not allowed in file names on some operating systems.
#'
#' @return
#' A character vector of the current timestamp in the format
#' \code{yyyy-MM-dd hh-mm-ss}.
#'
#' @details
#' This character vector of the current timestamp can be used safely
#' inside a file path, for example to generate unique log file names
#' for successive workflow runs. The function delegates to
#' \code{toString(now(), "yyyy-MM-dd hh-mm-ss")}.
#'
#' @examples
#' \dontrun{
#' logfile <- paste0("run-", get_timestamp(), ".log");
#' }
#'
#' @seealso \code{\link{init_context}}
#'
#' @author xieguigang
#'
const get_timestamp = function() {
    toString(now(), "yyyy-MM-dd hh-mm-ss");
}
