let map_colors as function(values, colors = ["blue", "gray", "red"], levels = 25) {
    const index = as.integer((levels - 1) * (values - min(values)) / (max(values) - min(values))) + 1;
    
    colors = colors(colors, levels);
    colors = colors[index];
    colors;    
}

let map_width as function(values, min = 1, max = 10) {
    const levels = (values - min(values)) / (max(values) - min(values));
    const width  = min + levels * (max - min);

    print(width);

    width;
}