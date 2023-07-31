require(WorkflowRender);

init_context(@dir);

hook(app("test1", function(app, context) {
    # str(app);
    # str(context);
    print("abc");
    print(workspace(app));
}));

hook(app("test2", function(app, context) {
    print(workspace(app));
}));

WorkflowRender::summary();
WorkflowRender::run();

saveRDS(.get_context(), file = `${@dir}/workflow.rds`);

finalize();