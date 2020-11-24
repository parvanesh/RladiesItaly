#setwd("C:/R-Ladies-RecSys/")
recmod <- readRDS("C:/R-Ladies-RecSys/ShinyApp/Reccomender System.rds")
Input_Utenti <- read_delim("C:/R-Ladies-RecSys/Dati - Input Utenti.csv",delim = ",")
Categories <- unique(Input_Utenti$Category)
