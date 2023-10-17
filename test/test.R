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

[@context_env "a"]
[@context_env "b"]
[@context_env "c"]
[@workfiles "aaaa://file/path/to/file.txt"]
[@desc "test analysis app module"]
[@app "app2"]
const app2 = function(app, context) {

}


str(__build_app(app2));

hook(app2);