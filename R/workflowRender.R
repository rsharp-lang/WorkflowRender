const run = function() {
    let context = .get_context();
    let app_pool = context$workflow;
    let argv = NULL;
    let t0 = NULL;

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