# imports attributes = .Internal::attributes;

#' Build workflow app object
#' 
#' @details Build a new workflow app module object based on the
#'    custom attribute values that tagged on the target function
#' 
#' @param f the target function f which tagged the required
#'    attribute data inside: app, desc, context_env, workfiles
#' 
const __build_app = function(f) {
    let attrs = .Internal::attributes(f);
    let app_name = attrs$app || "";
    let desc = attrs$desc;
    let context_env = attrs$context_env;
    let workfiles = attrs$workfiles;
    
    if (str_empty(desc, test_empty_factor=TRUE)) {
        # get description text from the function comment docs
        let json_str = attr(f, which = "r-sharp-help");

        if (!is.null(json_str)) {
            json_str = JSON::json_decode(json_str);
            json_str = (json_str$description) || (json_str$title);

            desc <- json_str; 
        }
    }

    if (nchar(app_name) == 0) {
        echo_warning([
            "invalid application function configuration was found:", 
            JSON::json_encode(attrs), 
            JSON::json_encode(f)
        ]);
        
        return(NULL);
    } else {
        app(app_name, analysis = f, 
                    desc = desc, 
                    dependency = set_dependency(
                        context_env = context_env, 
                        workfiles = __workfiles(files_uri = workfiles)
                    ));
    }
}

