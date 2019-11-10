# filename: nytimes.R
#----------------------------------------------
# This is a Shiny web application that calls the
# NYTimes Books API to present information about 
# best-selling books.
#
# You can get a user ID here by signing up 
# (and follow instructions) 
#        https://www.shinyapps.io/
# 
# Application is deployed at: 
#        https://dghendry-info201-autumn-19.shinyapps.io/nytimes/
#
# To deploy this app: 
#       library(rsconnect)
#       rsconnect::deployApp(getwd())
#
# See:   http://shiny.rstudio.com/
#
# For tutorial on Shiny, see: 
#        https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/
#
# For documentation on tabsets and other layouts
#        https://shiny.rstudio.com/articles/layout-guide.html
#
# For wideget gallary, see
#        https://shiny.rstudio.com/gallery/widget-gallery.html
#
# For documentation on output types, see
#        https://shiny.rstudio.com/tutorial/written-tutorial/lesson4/
#
# For documentation on use of HTML tags, see: 
#        https://shiny.rstudio.com/articles/html-tags.html
#        https://shiny.rstudio.com/articles/tag-glossary.html
#----------------------------------------------
library(shiny)
library(htmltools)

source("./source/debug_functions.R")
source("./source/html_functions.R")
source("./source/nytimes_api_functions.R")

#----------------------------------------------
# This code creates a data frame of the list
# of book categories and it creates a named
# vector of the categories for a selectInput
# shiny widget.  
# 
# Since we only need to do this once, we put 
# this code at the top outside of the front-end
# and the back-end
#----------------------------------------------
book_list <- make_book_list_names_query()
book_list_df <- data.frame(query = book_list, stringsAsFactors = FALSE)
book_list_df$id <- seq(1, length(book_list))
book_list_df$title <- lapply(book_list_df$query, book_list_query_to_title)

select_input_list <- book_list_df$query
names(select_input_list) <- book_list_df$title

#----------------------------------------------
# Front-end: Define variable "ui" for a tabs-based UI
#----------------------------------------------
ui <- fluidPage(

  titlePanel("New York Times Book Lists"),

  tabsetPanel(
    type = "tabs", id = "nav_bar",

    tabPanel(
      "Introduction",
      htmlOutput("intro")
    ),

    tabPanel(
      "Categories",
      HTML("<h3>The Book Lists</h3>"),
      htmlOutput("cats")
    ),

    tabPanel("Random Book List",
      value = "random_tab",
      htmlOutput("random_list")
    ),

    tabPanel(
      "Select Book List",
      sidebarLayout(
        sidebarPanel(
          selectInput("book_cat_select",
            label = h3("Select Book Category"),
            choices = select_input_list,
            selected = "hardcover-nonfiction"
          )
        ),

        mainPanel(
          htmlOutput("book_list")
        )
      )
    ),

    tabPanel("About",
             h3("Purpose"),
             tags$div(
                "This Shiny application demonstrates the use of tabsetPanel() and 
                tabPanel(). In addition, several different functions related to the",
                tags$a(href="https://developer.nytimes.com/docs/books-product/1/overview","New
             York Times Books API"), 
             "are demonstrated.",
             tags$b("Note:"),
             "This application is limited to 10 searches per minute and 4,000 searches per day."
             ),
             h3("Contact"),
             tags$div( 
                 "David Hendry",
                 tags$br(),
                 "INFO-201A: Technical Foundations for Informatics (Autumn, 2019)",
                 tags$br(),
                 "The Information School",
                 tags$br(),
                 "University of Washington",
                 tags$br(),
                 tags$i("November 12, 2019")
                 ),
             h3("The R Source Code"),
             verbatimTextOutput("about_code")
             )
  )
)

#----------------------------------------------
# Back-end: The Server
#----------------------------------------------
server <- function(input, output) {
  # Introduction tab - read the content of this tab from a markdown file 
  output$intro <- renderUI({
    get_text_from_md_file("./docs/intro.md")
  })

  # The categories tab - we call a NYTimes API function
  output$cats <- renderUI({
    get_text_from_md_string(get_markdown_book_list())
  })

  # The random book list tab: Set up an observer so that the list changes
  # every time the tab is clicked
  observe({
    if (req(input$nav_bar) == "random_tab") {
      book_list_name <- get_random_book_list_query()
      book_list_title <- book_list_query_to_title(book_list_name)
      t1 <- paste0(
        "### ", book_list_title, "\n",
        get_nytimes_top_x_book_list(10, book_list_name)
      )
      t2 <- get_text_from_md_string(t1)
      output$random_list <- renderUI({
        t2
      })
    }
  })

  # Select book list tab: When a new selection is made. 
  # TODO: Note the simularity of this code and the previous tab.
  # Need to factor out the common pieces
  output$book_list <- renderUI({
    book_list_name <- input$book_cat_select
    book_list_title <- book_list_query_to_title(book_list_name)
    get_nytimes_top_x_book_list(10, book_list_name)
    t1 <- paste0(
      "### ", book_list_title, "\n",
      get_nytimes_top_x_book_list(10, book_list_name)
    )
    t2 <- get_text_from_md_string(t1)
    t2
  })

  # About tag: This fills the about_code output field with the R code for the application
  output$about_code <- renderText({
      get_code()
  })
  
}

#----------------------------------------------
# Run the application
#----------------------------------------------
shinyApp(ui = ui, server = server)
