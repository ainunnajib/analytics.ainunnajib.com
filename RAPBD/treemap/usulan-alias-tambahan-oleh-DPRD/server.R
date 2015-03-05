library(shiny)
library(data.table)
library(googleVis)
load("treemapUsulan.RData")

shinyServer(function(input, output) {
  output$plot <- renderGvis({ treemapUsulan })
})