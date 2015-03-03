library(shiny)
library(data.table)
load("mata.anggaran.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- mata.anggaran
    data[ , BELANJABARANGDANJASA := format(BELANJABARANGDANJASA, scientific = FALSE, trim = TRUE, big.mark = ".")]
    data[ , BELANJAMODAL := format(BELANJAMODAL, scientific = FALSE, trim = TRUE, big.mark = ".")]
    data[ , BELANJAPEGAWAI := format(BELANJAPEGAWAI, scientific = FALSE, trim = TRUE, big.mark = ".")]
    data[ , TOTAL := format(TOTAL, scientific = FALSE, trim = TRUE, big.mark = ".")]
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
      paste('RAPBD', input$UrusanPemerintahan, input$Organisasi, paste0(input$KodeRekening, '.csv'), sep='-') 
    },
    content = function(file) {
      write.table(format(datasetInput(), scientific = FALSE, trim = TRUE, big.mark = "."), 
                  file = file, sep = "|", quote = FALSE)
    }
  )
  
})