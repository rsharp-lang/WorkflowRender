require(JSON);

const summary = function() {
    const context = .get_context();
    const pool    = context$workflow;
    const names   = pool@name;
    const description = pool@desc;
    const dependency  = pool@dependency;
    const deps.env    = dependency@context_env;
    const deps.workfiles = dependency@tempfiles;
    const disable     = pool@disable;
    const seq = context$pipeline;

    # str(pool);
    str(seq);

    print(data.frame(
        appName = names, 
        description = description, 
        "dependency.env" = sapply(deps.env, i -> JSON::json_encode(i)),
        "dependency.workfiles" = sapply(deps.workfiles, i -> JSON::json_encode(i)), 
        disable = disable,
        row.names = `#${1:length(pool)}`
    ));

    invisible(NULL);
}