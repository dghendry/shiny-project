# filename: html_functions.R
#----------------------------------------------
# Functions for creating HTML
#----------------------------------------------

# install.packages("formatR")
library(knitr)
library(formatR)

#----------------------------------------------
# This gets the key source files and puts them
# together so they can be presented
# TODO:
# (1) Figure this out: code <- tidy_source(text=code)
#----------------------------------------------
get_code <- function() {
  # t <- c(" line1", "line2", "line3")
  t <- readLines("./app.R")
  t <- append(t, c("", ""))
  t <- append(t, readLines("./source/nytimes_api_functions.R"))
  t <- append(t, c("", ""))
  t <- append(t, readLines("./source/html_functions.R"))
  t <- append(t, c("", ""))
  t <- append(t, readLines("./source/debug_functions.R"))
  t <- lapply(t, paste0, "\n")
  t <- append(t, c("", ""))
  t <- unlist(t, use.names = FALSE)
  return(t)
}

#----------------------------------------------
# Create HTML by reading a Markdown file
#----------------------------------------------
get_text_from_md_file <- function(fn) {
  return(div(HTML(markdown::markdownToHTML(fn))))
}

#----------------------------------------------
# Create HTML from a Markdown text string
#----------------------------------------------
get_text_from_md_string <- function(md_txt) {
  return(div(HTML(markdown::markdownToHTML(text = md_txt))))
}

#----------------------------------------------
# Create HTML using tags. In general, this is
# probably the most effective way to create
# HTML documents and render them in Shiny
# applications.
#
# For list of all the tags, see:
# https://shiny.rstudio.com/articles/tag-glossary.html
#----------------------------------------------
get_comment_text_with_tags <- function() {
  doc <- tags$div(
    hr(), # horizontal rule
    h1("Hello"), # heading 1 (big)
    p("Calling: get_comment_text_with_tags()"), # a paragraph
    p("Once upon a time... "), # another
    p("The end."), # last paragraph
    hr() # horizontal rule
  )
  # Note: doc is a Shiny tag oobject
  return(doc)
}

#----------------------------------------------
# Create HTML using strings  - same as above but done
# with text. Note beginning and ending HTML tags.
#----------------------------------------------
get_comment_text_with_HTML <- function() {
  txt <- "<hr><h1>Hello</h1>"
  txt <- paste0(txt, "<p>Calling: get_comment_text_with_HTML()</p>")
  txt <- paste0(txt, "<p>Once upon a time... </p>")
  txt <- paste0(txt, "<p>The end.</p>")
  txt <- paste0(txt, "<hr></div>")
  # Note: This returns HTML that can be rendered correctly by renderUI
  return(div(HTML(txt)))
}

#----------------------------------------------
# Create HTML by reading a file
#----------------------------------------------
get_comment_text_from_HTML_file <- function(fn) {
  return(includeHTML(fn))
}

#----------------------------------------------
# Create HTML from markdown - note new lines ("\n")
#----------------------------------------------
get_comment_text_with_md1 <- function() {
  txt <- "# Hello\n"
  txt <- paste0(txt, "_Calling_: get_comment_text_with_md1()\n\n")
  txt <- paste0(txt, "Once upon a time... \n\n")
  txt <- paste0(txt, "The end.\n\n")
  # Note: This returns HTML that can be rendered correctly by renderUI
  return(get_text_from_md_string(txt))
}

#----------------------------------------------
# Same as above but with vectors. Notes:
#   (a) Vectors and append function
#   (b) new lines ("\n")
#----------------------------------------------
get_comment_text_with_md2 <- function() {
  txt <- c("# Hello\n")
  txt <- append(txt, "_Calling_: get_comment_text_with_md2()\n")
  txt <- append(txt, "Once upon a time... \n")
  txt <- append(txt, "The end.\n")
  # This returns HTML that can be rendered correctly by renderUI
  return(div(HTML(markdown::markdownToHTML(text = txt))))
}
