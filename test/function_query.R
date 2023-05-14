a = function(x) {

}

b = function(y) {

}

str(as.list(args(a)));
str(as.list(args(b)));

get_name = function(f) {
    list = as.list(args(f));
    func = list[[""]];
    func$symbol;
}

l = as.list();
l[[get_name(a)]] = a;
l[[get_name(b)]] = b;
l[[get_name(get_name)]] = get_name;

str(l);

if (get_name(l[[get_name(a)]]) == get_name(a)) {
    print("test success!");
} else {
    stop("function reference test error!!!");
}