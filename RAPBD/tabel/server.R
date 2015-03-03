library(shiny)
load("mata.anggaran.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- mata.anggaran
    if (input$UrusanPemerintahan != "All"){
      data <- data[data$UrusanPemerintahan == input$UrusanPemerintahan,]
    }
    if (input$Organisasi != "All"){
      data <- data[data$Organisasi == input$Organisasi,]
    }
    if (input$KodeRekening != "All"){
      data <- data[data$KodeRekening == input$KodeRekening,]
    }
    data
  })
})