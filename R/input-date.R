#' Create date input
#'
#' Creates a text input which, when clicked on, brings up a calendar that
#' the user can click on to select dates.
#'
#' The date \code{format} string specifies how the date will be displayed in
#' the browser. It allows the following values:
#'
#' \itemize{
#'   \item \code{yy} Year without century (12)
#'   \item \code{yyyy} Year with century (2012)
#'   \item \code{mm} Month number, with leading zero (01-12)
#'   \item \code{m} Month number, without leading zero (1-12)
#'   \item \code{M} Abbreviated month name
#'   \item \code{MM} Full month name
#'   \item \code{dd} Day of month with leading zero
#'   \item \code{d} Day of month without leading zero
#'   \item \code{D} Abbreviated weekday name
#'   \item \code{DD} Full weekday name
#' }
#'
#' @inheritParams textInput
#' @param value The starting date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format. If NULL (the default), will use the current date
#'   in the client's time zone.
#' @param min The minimum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param max The maximum allowed date. Either a Date object, or a string in
#'   \code{yyyy-mm-dd} format.
#' @param format The format of the date to display in the browser. Defaults to
#'   \code{"yyyy-mm-dd"}.
#' @param startview The date range shown when the input object is first clicked.
#'   Can be "month" (the default), "year", or "decade".
#' @param weekstart Which day is the start of the week. Should be an integer
#'   from 0 (Sunday) to 6 (Saturday).
#' @param language The language used for month and day names. Default is "en".
#'   Other valid values include "ar", "az", "bg", "bs", "ca", "cs", "cy", "da",
#'   "de", "el", "en-AU", "en-GB", "eo", "es", "et", "eu", "fa", "fi", "fo",
#'   "fr-CH", "fr", "gl", "he", "hr", "hu", "hy", "id", "is", "it-CH", "it",
#'   "ja", "ka", "kh", "kk", "ko", "kr", "lt", "lv", "me", "mk", "mn", "ms",
#'   "nb", "nl-BE", "nl", "no", "pl", "pt-BR", "pt", "ro", "rs-latin", "rs",
#'   "ru", "sk", "sl", "sq", "sr-latin", "sr", "sv", "sw", "th", "tr", "uk",
#'   "vi", "zh-CN", and "zh-TW".
#' @param autoclose Whether or not to close the datepicker immediately when a
#'   date is selected.
#'
#' @family input elements
#' @seealso \code{\link{dateRangeInput}}, \code{\link{updateDateInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   dateInput("date1", "Date:", value = "2012-02-29"),
#'
#'   # Default value is the date in client's time zone
#'   dateInput("date2", "Date:"),
#'
#'   # value is always yyyy-mm-dd, even if the display format is different
#'   dateInput("date3", "Date:", value = "2012-02-29", format = "mm/dd/yy"),
#'
#'   # Pass in a Date object
#'   dateInput("date4", "Date:", value = Sys.Date()-10),
#'
#'   # Use different language and different first day of week
#'   dateInput("date5", "Date:",
#'           language = "ru",
#'           weekstart = 1),
#'
#'   # Start with decade view instead of default month view
#'   dateInput("date6", "Date:",
#'             startview = "decade")
#' )
#'
#' shinyApp(ui, server = function(input, output) { })
#' }
#' @export
dateInput <- function(inputId, label, value = NULL, min = NULL, max = NULL,
  format = "yyyy-mm-dd", startview = "month", weekstart = 0, language = "en",
  width = NULL, autoclose = TRUE) {

  # If value is a date object, convert it to a string with yyyy-mm-dd format
  # Same for min and max
  if (inherits(value, "Date"))  value <- format(value, "%Y-%m-%d")
  if (inherits(min,   "Date"))  min   <- format(min,   "%Y-%m-%d")
  if (inherits(max,   "Date"))  max   <- format(max,   "%Y-%m-%d")

  value <- restoreInput(id = inputId, default = value)

  tags$div(id = inputId,
    class = "shiny-date-input form-group shiny-input-container",
    style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),

    controlLabel(inputId, label),
    tags$input(type = "text",
               class = "form-control",
               `data-date-language` = language,
               `data-date-week-start` = weekstart,
               `data-date-format` = format,
               `data-date-start-view` = startview,
               `data-min-date` = min,
               `data-max-date` = max,
               `data-initial-date` = value,
               `data-date-autoclose` = if (autoclose) "true" else "false"
    ),
    datePickerDependency
  )
}

datePickerDependency <- htmlDependency(
  "bootstrap-datepicker", "1.6.4", c(href = "shared/datepicker"),
  script = "js/bootstrap-datepicker.min.js",
  stylesheet = "css/bootstrap-datepicker3.min.css",
  # Need to enable noConflict mode. See #1346.
  head = "<script>
(function() {
  var datepicker = $.fn.datepicker.noConflict();
  $.fn.bsDatepicker = datepicker;
})();
</script>"
)
