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
  
  datasetInput <- reactive({
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
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste('RAPBD', input$UrusanPemerintahan, input$Organisasi, input$KodeRekening, '.csv', sep='-') 
    },
    content = function(file) {
      write.table(format(datasetInput(), scientific = FALSE, trim = TRUE), 
                  file = "mata.anggaran.csv", sep = "|", quote = FALSE)
    }
  )
  
})