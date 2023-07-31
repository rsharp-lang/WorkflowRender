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

# app object could be reference by the app object itself
# or the app name
print(workspace(app1));
print(workspace("helo_world"));

run();

saveRDS(.get_context(), file = `${@dir}/workflow.rds`);

finalize();