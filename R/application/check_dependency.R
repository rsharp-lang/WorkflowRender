#' Check of the analysis app dependency
#' 
#' @param app the analysis app object list which is construct
#'    via the ``app`` function.
#'
#' @return this function returns a data list that contains the
#'    dependency check result. there are some data symbol inside
#'    this result object list: 
#'
#'    1. check: logical, for indicate the dependency check success or not;
#'    2. context: a tuple list object that contains of context symbol names 
#'                which are not check success, and the reason of failure;
#'    3. file: character vector of dependency of local workspace file 
#'             check not success
#'
const check_dependency = function(app, context = .get_context()) {
    const SUCCESS = list(check = TRUE);

    if (is.null(app$dependency)) {
        # this application has no dependency
        return(SUCCESS);
    } else {
        const dependency  = app$dependency;
        const check_env   = check_dependency.context_env(requires = dependency$context_env, context); 
        const check_files = check_dependency.localfiles(requires = dependency$tempfiles, context);
        const pass1 = is.null(check_env);
        const pass2 = is.null(check_files);

        if (pass1 && pass2) {
            return(SUCCESS);
        } else {
            return(list(
                check = FALSE,
                context = check_env,
                file = check_files
            ));
        }
    }
}

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
    const err = list();

    for(name in names(requires)) {
        const mark  = requires[[name]];
        const missing = ![name in env];

        if (missing) {
            err[[name]] = "missing";
        } else if (mark != "any") {
            if (map[[mark]] != typeof(env[[name]])) {
                err[[name]] = "mis-matched";
            }
        }
    }

    if (length(err) == 0) {
        NULL;
    } else {
        return(err);
    }
}

const check_dependency.localfiles = function(requires, context) {
    const err = list();

    for(appName in names(requires)) {
        const workdir   = WorkflowRender::workspace(appName);
        const file_rels = requires[[appName]];
        const checks    = `${workdir}/${file_rels}` |> which(filename -> !file.exists(filename));

        if (length(checks) > 0) {
            err[[appName]] = checks;
        }
    }

    if (length(err) == 0) {
        NULL;
    } else {
        return(err);
    }
}