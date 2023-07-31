const summary = function() {
    const context = .get_context();
    const pool    = context$workflow;
    const names   = pool@name;
    const description = pool@desc;
    const dependency  = pool@dependency;
    const disable     = pool@disable;

    # str(pool);

    print(data.frame(
        appName = names, 
        description = description, 
        dependency = dependency, 
        disable = disable
    ));

    invisible(NULL);
}