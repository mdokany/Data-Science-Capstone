## User Interface file for text prediction based on a corpus

library(shiny)

shinyUI(fluidPage(
  titlePanel("Next Word Prediction"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "iText", label = h3("Type a Text"),
                value = "Enter text..."),
      submitButton("Submit")
    ),
    mainPanel(
      h3("Results"),
      h4("You entered the following text"),
      verbatimTextOutput("oText"),
      h4("Guessed word"),
      verbatimTextOutput("oWord"),
      h4("Top 5 results"),
      tableOutput("oTo5")
    )
  )
))