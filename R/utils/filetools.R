#' Create a File Path Safely
#'
#' @description
#' Constructs a file path by combining a directory and a file name,
#' applying a normalization step to the file name so that the resulting
#' path is safe to use on any operating system. This is particularly
#' useful when the file name is derived from user input or from
#' analysis metadata that may contain characters that are not allowed
#' in file names.
#'
#' @param dir a character vector of the directory path that should
#'   contain the target file.
#' @param filename a character vector of the file name that should be
#'   normalized and combined with the directory path.
#' @param maxchars an integer value that specifies the maximum number
#'   of characters allowed in the normalized file name. The default
#'   value of \code{48} is chosen to stay well below the typical file
#'   name length limit of most operating systems. File names that
#'   exceed this limit will be shrunk.
#'
#' @return
#' A character vector of the safe file path, constructed by combining
#' the input directory and the normalized file name via
#' \code{\link{file.path}}.
#'
#' @details
#' This function generates a new character vector based on the input
#' directory and file name for saving a file safely. The file name is
#' processed in two steps:
#' \enumerate{
#'   \item Removes the unsafe characters for the Windows filesystem
#'     (such as \code{:}, \code{*}, \code{?}, \code{"}, \code{<},
#'     \code{>}, \code{|} and a number of control characters).
#'   \item Shrinks the file name if its string length exceeds the
#'     \code{maxchars} limit, preserving as much of the original name
#'     as possible while staying within the limit.
#' }
#'
#' @examples
#' \dontrun{
#' filepath_safe("/tmp/workdir", "results:file?.txt");
#' }
#'
#' @seealso \code{\link{normalizeFileName}}, \code{\link{file.path}}
#'
#' @author xieguigang
#'
const filepath_safe = function(dir, filename, maxchars = 48) {
    filename = filename |> normalizeFileName(
        alphabetOnly = FALSE,
        shrink = TRUE,
        maxchars = maxchars
    );

    file.path(dir, filename);
}
