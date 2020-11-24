output$movie_rating01 <- renderUI({
  
  if(length(input$categories_selection) > 0){

    fluidRow(
      column(
        shinyBS::popify(
          el = sliderInput(inputId = input$categories_selection[1],
                           label = input$categories_selection[1],
                           max = 10,
                           min = 1,
                           step = .25,
                           value = 5.5),
          title = "",
          placement = "right"
        ),
        width = 10
      )
    )
    
  }
})

output$movie_rating02 <- renderUI({
  
  if(length(input$categories_selection) > 1){

    fluidRow(
      column(
        shinyBS::popify(
          el = sliderInput(inputId = input$categories_selection[2],
                           label = input$categories_selection[2],
                           max = 10,
                           min = 1,
                           step = .25,
                           value = 5.5),
          title = "",
          placement = "right"
        ),
        width = 10
      )
    )
    
  }
})

output$movie_rating03 <- renderUI({
  
  if(length(input$categories_selection) > 2){
    
    fluidRow(
      column(
        shinyBS::popify(
          el = sliderInput(inputId = input$categories_selection[3],
                           label = input$categories_selection[3],
                           max = 10,
                           min = 1,
                           step = .25,
                           value = 5.5),
          title = "",
          placement = "right"
        ),
        width = 10
      )
    )
    
  }
})