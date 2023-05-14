require(WorkflowRender);

a = function(x) {

}

b = function(y) {

}

str(as.list(args(a)));
str(as.list(args(b)));

l = list();
l[[WorkflowRender::get_functionName(a)]] = a;
l[[WorkflowRender::get_functionName(b)]] = b;
l[[WorkflowRender::get_functionName(WorkflowRender::get_functionName)]] = WorkflowRender::get_functionName;

str(l);

if (WorkflowRender::get_functionName(l[[WorkflowRender::get_functionName(a)]]) == WorkflowRender::get_functionName(a)) {
    print("test success!");
} else {
    stop("function reference test error!!!");
}