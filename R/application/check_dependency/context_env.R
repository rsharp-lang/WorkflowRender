#' Check of the required environment symbols
#'
#' @details the environment symbols from the analysis context should be 
#'    set via the ``set_config`` function.
#' 
const check_dependency.context_env = function(requires, context) {
    const env = context$configs;
    const map = {
              'any': "any", 
          'numeric': "num", 
          'integer': "int", 
        'character': "chr", 
          'logical': "logi", 
         'function': "function"
    };
    const env_symbols = names(env);
    const err = list(
        "environment_symbols(all)" = `[${paste(env_symbols, sep = ", ")}]`
    );

    for(name in names(requires)) {
        const mark  = requires[[name]];
        const missing = !(name in env);

        if (missing) {
            err[[name]] = "missing";
        } else if (mark != "any") {
            if (map[[mark]] != typeof(env[[name]])) {
                err[[name]] = "mis-matched";
            }
        }
    }

    if (length(err) <= 1) {
        NULL;
    } else {
        return(err);
    }
}