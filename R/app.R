
#' Analysis app constructor
#' 
#' @param analysis a callable function for run the data analysis 
#'   content.
#' 
const app = function(name, analysis, desc = "no description") {
    list(
        name = name,
        call = analysis
    );
}