library(shinyWidgets)
library(DT)
library(tidyverse)
library(dplyr)
library(reshape2)
library(recommenderlab)

source("load_data.R", local = TRUE)$value
print(recmod)
print(head(Input_Utenti))
print(Categories)

ui <- fluidPage(
  sidebarPanel(
    h2("Recommendation System"),
    h5("To use this recommender, select up to 3 categories from the dropdown menu and rate them from 1 = bad to 10 = good. 
       When you press the run button a category recommendation based on your rating will be displayed."),
    h2("Select and rate category"),
    pickerInput(inputId = "categories_selection",
                label = "",
                choices = Categories,
                selected = Categories[1:3],
                options = pickerOptions(
                  actionsBox = FALSE,
                  maxOptions = 10 # maximum of options
                ), 
                multiple = TRUE)),sidebarPanel(
    h4(" "),
    uiOutput("movie_rating01"),
    uiOutput("movie_rating02"),
    uiOutput("movie_rating03"),
    actionButton("run", "Run")
  ),
  mainPanel(
    tableOutput("recomm")
  )
)


server <- function(input, output, session) {
  source("ui_server.R", local = TRUE)$value
  source("data_server.R", local = TRUE)$value
}

shinyApp(ui = ui, server = server)