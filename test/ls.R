require(WorkflowRender);

init_context(@dir);

hook(app("test1", function(app, context) {
    # str(app);
    # str(context);
    print("abc");
    print(workspace(app));

    set_config(configs = list(
        ttttt = 1
    ));

    writeLines("zzzzzzzz", con = workfile(app, "/aa/bb.txt"));
}));

hook(app("test2", function(app, context) {
    print(workspace(app));
    print(get_config("ttttt"));
},
, dependency = set_dependency(
    context_env = ["ttttt"],
    workfiles = list(
        "test1" = "/aa/bb.txt"
    )
)

));

hook(app("test3", function(app, context) {

    print("run app test 3");

}));


WorkflowRender::summary();
WorkflowRender::run();

finalize();