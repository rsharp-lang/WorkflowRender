
const dependency_analysis = function(app) {
    list(
        id = app$name,
        label = app$desc,
        pars = names(app$dependency$contex_env),
        input_files = app$dependency$tempfiles
    );
}