const workspace = function(app) {
    const context = .get_context();
    const temp_root = context$temp_dir;
    const workdir = normalizePath(`${temp_root}/.works/${app$name}/`);

    workdir;
}