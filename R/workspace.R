const workspace = function(app) {
    const context = .get_context();
    const temp_root = context$temp_dir;
    const workdir = normalizePath(`${temp_root}/.works/${app$name}/`);

    if (![app$name in context$pipeline]) {
        warning(`The app(${app$name}) has not been registered in the analysis context yet.`);
    }

    workdir;
}