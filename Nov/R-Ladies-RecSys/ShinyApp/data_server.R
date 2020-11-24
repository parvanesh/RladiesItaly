recomdata <- reactive({
  
  selected_categories <- data.frame(Categories=Categories[Categories %in% input$categories_selection])
  
  for(i in 1:nrow(selected_categories)){
    selected_categories$ratingvec[i] <- input[[as.character(selected_categories$Categories[i])]]
  }
  
  rating_vec <- data.frame(Categories=Categories) %>% left_join(., selected_categories, by = "Categories") %>% 
    pull(ratingvec)
  print(rating_vec)
  
  rating_vec <- as.matrix(t(rating_vec))
  rating_vec <- as(rating_vec, "realRatingMatrix")
  rating_vec@data@Dimnames[[2]]<-Categories
  top_5_prediction <- predict(recmod, rating_vec, n = 5)
  top_5_list <- as(top_5_prediction, "list")
  top_5_df <- data.frame(top_5_list)
  colnames(top_5_df) <- "Category"
  top_5_df

})


observeEvent(input$run, {
  
  recomdata <- recomdata()
  
  if(length(input$categories_selection) < 2){
    sendSweetAlert(
      session = session,
      title = "Please select more categories.",
      text = "Rate at least two categories.",
      type = "info")
  } else if(nrow(recomdata) < 1){
    sendSweetAlert(
      session = session,
      title = "Please vary in your ratings.",
      text = "Do not give the same rating for all categories.",
      type = "info")
    
  } else{
    output$recomm <- renderTable(recomdata) 
  }
  
})