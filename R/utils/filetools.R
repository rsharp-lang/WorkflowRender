#' Create the file path safely
#' 
#' @details this function will make a safe file path, by 
#'    processing the file name string in process: 
#' 
#'    1. removes the unsafe character for windows filesystem
#'    2. make the file name short if the file name string len exccede the max chars
#' 
#' @return this function generates a new character vector based on the
#'    input dir and the filename for save a file safely.
#' 
const filepath_safe = function(dir, filename, maxchars = 48) {
    filename = filename |> normalizeFileName(
        alphabetOnly = FALSE, 
        shrink = TRUE,
        maxchars = maxchars
    );

    file.path(dir, filename);
}