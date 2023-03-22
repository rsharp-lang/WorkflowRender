require(WorkflowRender);

init_context(@dir);
app1 = app("test1", function(app, context) {
    str(app);
    str(context);
});

hook(app1);

print(workspace(app1));

run();

saveRDS(.get_context(), file = `${@dir}/workflow.rds`);

finalize();