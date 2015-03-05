library(shiny)
library(data.table)
load("mata.anggaran.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- mata.anggaran
<<<<<<< HEAD
    data[ , BELANJABARANGDANJASA := format(BELANJABARANGDANJASA, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , BELANJAMODAL := format(BELANJAMODAL, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , BELANJAPEGAWAI := format(BELANJAPEGAWAI, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , TOTAL := format(TOTAL, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
=======
    data[ , BELANJABARANGDANJASA := paste("Rp.", format(BELANJABARANGDANJASA, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , BELANJAMODAL := paste("Rp.", format(BELANJAMODAL, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , BELANJAPEGAWAI := paste("Rp.", format(BELANJAPEGAWAI, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , TOTAL := paste("Rp.", format(TOTAL, scientific = FALSE, width = 15, big.mark = "."))]
>>>>>>> origin/master
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
  }
  #, options = list(
  #  columnDefs = list(list(targets = c(5, 6, 7, 8), type = "num-fmt"))
  #)
  )
  
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
                  file = file, sep = ",", row.names = FALSE, quote = TRUE)
    }
  )
  
})