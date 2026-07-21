
#' get function name
#' 
#' @detail the evaluation result of ``args`` function, 
#'     slot with name empty string "" is the function 
#'     name. Other slot value is the function parameter
#'     values.
#' 
const get_functionName = function(f) {
    let list = as.list(args(f));
    let func = list[[""]];

    return(func$symbol);
}