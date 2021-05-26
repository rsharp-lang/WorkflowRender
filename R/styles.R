let map_colors as function(values, colors = ["blue", "gray", "red"], levels = 25) {
    const index = as.integer((levels - 1) * (values - min(values)) / (max(values) - min(values))) + 1;
    
    colors = colors(colors, levels);
    colors = colors[index];
    colors;    
}

let map_classColors as function(values, colors, missing = "gray") {
    if (is.list(colors)) {
        sapply(values, function(class) {
            if (class in names(values)) {
                values[[class]];
            } else {
                missing;
            }
        });
    } else {
        const uniqvl = unique(values);
        const len_cl = length(colors);
        const len_vl = length(uniqvl);

        if (len_cl < len_vl) {
            colors = append(colors, rep(missing, times = len_vl - len_cl));
        }

        colors[sapply(values, cl -> which(cl == uniqvl))];
    }
}

let map_size as function(values, min = 1, max = 10) {
    const levels = (values - min(values)) / (max(values) - min(values));
    const size   = min + levels * (max - min);

    print(size);

    # returns the size mapping result
    size;
}

let mapStyleColors as function(table, values = "weight", colors = ["blue", "gray", "red"], levels = 25) {
    table[, "color"] = table[, values] 
                       |> map_colors(colors, levels)
                       ;
    table;
}

let mapStyleWidth as function(table, values = "weight", min = 1, max = 10) {
    table[, "width"] = table[, values]
                       |> map_size(min, max)
                       ;
    table;
}

let mapStyleSize as function(table, values = "weight", min = 10, max = 80) {
    table[, "size"] = table[, values]
                      |> map_size(min, max)
                      ;
    table;
}