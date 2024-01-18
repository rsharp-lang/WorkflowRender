#' Generate the error message for missing context symbols
#'
const dependency.context_env_missing = function(context) {
    if (is.null(context) || length(context) == 0) {
        "there is no runtime environment required context symbol is missing.";
    } else {
        paste([
            `there are ${length(context)} required context symbol is missing or data type is mis-matched in the workflow:`,
            JSON::json_encode(context)
        ], sep = " ");
    }
}

#' Generate the error message for the missing required work files
#'
const dependency.workfiles_missing = function(file) {
    if (is.null(file) || length(file) == 0) {
        "there is no required workspace tempfile is missing in current workflow.";
    } else {
        file = file
        |> names
        |> sapply(app -> `${app}: ${paste(file[[app]], sep = " and ")}`)
        |> paste(sep = "; ")
        ;

        paste([`there are ${length(file)} required workspace tempfile is missing in the work directory:`, file], sep = " ");
    }
}