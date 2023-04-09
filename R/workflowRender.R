const run = function(registry = NULL) {
    if (!is.null(registry)) {
        do.call(registry, args = list());
    }

    __runImpl(context = .get_context());
}

const __runImpl = function(context) {
    let app_pool = context$workflow;
    let t0 = NULL;
    let argv = NULL;
    
    for(app in context$pipeline) {
        t0 = now();
        app = app_pool[[app]];
        argv = {
            app: app, 
            context: context
        };

        # run current data analysis node
        do.call(app$call, args = argv);
        
        app$profiler = {
            time: time_span(now() - t0)
        };
    }
}