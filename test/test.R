require(WorkflowRender);

fx = function(app, context) {

}

init_context();
hook(app("aaaa", fx));

# returns the string 'fx' directly
print(get_app_name("fx"));
# get the app name which is associated with the function fx
# aaaa
print(get_app_name(fx));