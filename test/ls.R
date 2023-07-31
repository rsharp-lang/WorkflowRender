require(WorkflowRender);

init_context(@dir);

hook(app("test1", function(app, context) {
    # str(app);
    # str(context);
    print("abc");
    print(workspace(app));
}));

WorkflowRender::run();

saveRDS(.get_context(), file = `${@dir}/workflow.rds`);

finalize();