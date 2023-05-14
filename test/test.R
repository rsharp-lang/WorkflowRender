require(WorkflowRender);

fx = function(app, context) {

}

init_context();
hook(app("aaaa", fx));

print(get_app_name("fx"));
print(get_app_name(fx));