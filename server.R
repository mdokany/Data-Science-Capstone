## Server file for text prediction based on a corpus

library(shiny)
library(stringr)
library(tm)

## Load the text model
ngrams <- readRDS(file = "./ngrams.rds")

getPrediction <- function(x) {
  
  ## Phrase to get prediction
  corp <- ngrams$GetCorpus(x)
  phrase <- str_trim(as.character(corp[[1]]))
  
  ## Count the number of words in the given sentence
  words <- length(unlist(strsplit(x = phrase, split = " ")))
  
  ## Initialize predictedWord to "the"
  found <- FALSE
  prediction <- list(df = data.frame(0), predictedWord = "the")
  
  ## Check quadri-grams
  if (found == FALSE && words >= 3) {
    prediction$df <- head(ngrams$df4[
      ngrams$df4$w1 == word(string = phrase, start = -3) &
        ngrams$df4$w2 == word(string = phrase, start = -2) &
        ngrams$df4$w3 == word(string = phrase, start = -1), ],
      n = 5)
    if (nrow(prediction$df) > 0) {
      found <- TRUE
      prediction$predictedWord <- prediction$df[1, ]$w4
    }
  }
  
  ## Check tri-grams
  if (found == FALSE && words >= 2) {
    prediction$df <- head(ngrams$df3[
      ngrams$df3$w1 == word(string = phrase, start = -2) &
        ngrams$df3$w2 == word(string = phrase, start = -1), ],
      n = 5)
    if (nrow(prediction$df) > 0) {
      found <- TRUE
      prediction$predictedWord <- prediction$df[1, ]$w3
    }
  }
  
  ## Check bi-grams
  if (found == FALSE && words >= 1) {
    prediction$df <- head(ngrams$df2[
      ngrams$df2$w1 == word(string = phrase, start = -1), ],
      n = 5)
    if (nrow(prediction$df) > 0) {
      found <- TRUE
      prediction$predictedWord <- prediction$df[1, ]$w2
    }
  }
  
  ## Check uni-grams
  if (found == FALSE && words >= 0) {
    prediction$df <- head(x = ngrams$df1,
                          n = 5)
    if (nrow(prediction$df) > 0) {
      found <- TRUE
      prediction$predictedWord <- prediction$df[1, ]$w1
    }
  }
  
  ## Return the prediction results
  prediction
}

shinyServer(function(input, output) {
  prediction <- reactive({
    getPrediction(input$iText)
  })
  
  output$text <- renderText({"You have selected this"})
  output$oText <- renderPrint({input$iText})
  output$oWord <- renderPrint({prediction()$predictedWord})
  output$oTo5 <- renderTable({prediction()$df})
})