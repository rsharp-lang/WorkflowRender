require(WorkflowRender);

init_context(@dir);
app1 = app("test1", function(app, context) {
    # str(app);
    # str(context);
    print("abc");
});

hook(app1);

hook(app("echo", function(app, context) {
    print(context$pipeline);
}));

print(workspace(app1));

run();

saveRDS(.get_context(), file = `${@dir}/workflow.rds`);

finalize();