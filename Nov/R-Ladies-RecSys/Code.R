## ------------------------------------- ##
## # R-Ladies -- Reccomandation System # ##
## ------------------------------------- ##

# Set Working Directory
setwd("C:/R-Ladies-RecSys/")

## --------------------------- ##
#### -- 0. Packages Setup -- ####
## --------------------------- ##

# Installazione dei pacchetti necessari

## DataExplorer
# ## Di seguito utilizzeremo diverse librerie per effettuare analisi esplorative sui dati di input.
# ## Una delle librerie importate è DataExplorer, che risulta archiviata nel repository CRAN 
# ## (https://cran.r-project.org/web/packages/DataExplorer/index.html).
# ## E' necessario installarla scaricando una delle versioni presenti in archivio.
# 
# # Download package file from CRAN archive
# url <- "https://cran.r-project.org/src/contrib/Archive/DataExplorer/DataExplorer_0.8.1.tar.gz"
# pkgFile <- "DataExplorer_0.8.1.tar.gz"
# download.file(url = url, destfile = pkgFile)
# # Install dependencies
# install.packages(c("xfun", "farver", "evaluate", "tinytex", "igraph", "scales", "data.table", "rmarkdown", "networkD3", "gridExtra", "htmlwidgets"))
# # Install package
# install.packages(pkgs=pkgFile, type="source", repos=NULL)
# # Delete downloaded file
# unlink(pkgFile)

## Other packages
# list.of.packages <- c("readr", "dplyr", "skimr", "Hmisc", "reshape2", "recommenderlab", "shiny", "shinyWidgets", "DT", "shinyBS")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)


# read packages
library(readr)
library(dplyr)
library(data.table)

## ------------------------- ##
#### -- 1. Analisi Dati -- ####
## ------------------------- ##

# l'Analisi dei dati e' molto importante, in qualsiasi scenario e' fondamentale 
# conoscere i propri dati, qui vi mostriamo alcuni semplici strumenti, 
# alcuni poco conosciuti per avere un'esplorazione efficace
# (https://www.littlemissdata.com/blog/simple-eda)

# Read Raw Data
Input_Utenti <- read_delim("Dati - Input Utenti.csv",delim = ",")

# Base Package
summary(Input_Utenti)
table(Input_Utenti$Category)


library(dplyr)
glimpse(Input_Utenti)


library(skimr)
skim(Input_Utenti)


library(Hmisc)
describe(Input_Utenti)

options(grType='plotly')
d <- describe(Input_Utenti)
p <- plot(d)   # create plots for both types of variables
p[[1]]; p[[2]] # or p$Categorical; p$Continuous


library(DataExplorer)
DataExplorer::create_report(Input_Utenti)





## -------------------------- ##
#### -- 2. Creazione KPI -- ####
## -------------------------- ##

# I dati hanno anche dei valori informativi intrinseci, 
# questi possono essere estratti o derivati da intuito, intelligenze e alcune formule 

# Rating KPI Creation
Input_Utenti1 <- Input_Utenti %>%
  group_by(Category) %>%
  mutate(RatingSd = (Spending - mean(Spending))/sd(Spending),
         RatingSd = ifelse(is.na(RatingSd), 0, RatingSd),
         RatingSd = ifelse(RatingSd < -3, -3, RatingSd),
         RatingSd = ifelse(RatingSd > 3, 3, RatingSd)) %>%
  select(UserId, Category, RatingSd) %>% 
  ungroup()

MIN = min(Input_Utenti1$RatingSd)
MAX = max(Input_Utenti1$RatingSd)

# hist(Input_Utenti$Spending)
# hist(Input_Utenti1$RatingSd)

Input_Utenti1 = Input_Utenti1 %>%
  mutate(Rating = 1 + ((RatingSd - MIN)*9/(MAX - MIN))) %>%            
  select(UserId, Category, Rating)

# hist(Input_Utenti1$Rating)



## --------------------------------- ##
#### -- 3. Reccomandation Model -- ####
## --------------------------------- ##

# How to build a reccomandation system
library(reshape2)
rating_mat <- dcast(Input_Utenti1, UserId ~ Category, value.var = "Rating", 
                    na.rm=FALSE)
rating_mat <- as.matrix(rating_mat[,-1]) 

head(Input_Utenti1)
head(rating_mat)

library(recommenderlab)
rating_mat <- as(rating_mat, "realRatingMatrix")
rating_mat
rating_mat <- rating_mat[rowCounts(rating_mat) >3,] # utenti che hanno espresso almeno 4 rating
rating_mat

## Select Training Set
train <- rating_mat[1:900]
# getRatingMatrix(train) 

## Model Training 
rec <- Recommender(train, method = "ALS")

## Save Serialized model
# saveRDS(rec,file="ShinyApp/Reccomender System.rds")

## Predictions ##
# Select Test User
user_test<-903
head(as(rating_mat[user_test,], "list")[[1]])

## Predict top N categories
pre <- predict(rec, rating_mat[user_test], n = 5)
as(pre, "list")

## Predict ratings for all available categories
pre <- predict(rec, rating_mat[user_test], type="ratings")
pre
as(pre, "matrix")[,1:10]



## ---------------------- ##
#### -- 4. Shiny App -- ####
## ---------------------- ##

# Interazione attraverso interfaccia grafico 

library(shiny)
runApp("ShinyApp/App.R")
