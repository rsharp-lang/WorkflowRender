require(WorkflowRender);

init_context(@dir);
app1 = app("test1");
hook(app1);

print(workspace(app1));

str(.get_context());

finalize();