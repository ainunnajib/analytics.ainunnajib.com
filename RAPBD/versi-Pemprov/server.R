Sys.setlocale('LC_CTYPE', 'en_US.UTF-8')
library(shiny)
library(data.table)
load("mata.anggaran.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- mata.anggaran
    data[ , BELANJABARANGDANJASA := format(BELANJABARANGDANJASA, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , BELANJAMODAL := format(BELANJAMODAL, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , BELANJAPEGAWAI := format(BELANJAPEGAWAI, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , TOTAL := format(TOTAL, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]

    if (input$UrusanPemerintahan != "All"){
      data <- data[data$UrusanPemerintahan == input$UrusanPemerintahan,]
    }
    if (input$Organisasi != "All"){
      data <- data[data$Organisasi == input$Organisasi,]
    }
    if (input$KodeRekening != "All"){
      data <- data[data$KodeRekening == input$KodeRekening,]
    }
    save(data, file = "test.RData")
    write.table(data, "test.dat")
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
  
#  output$debug <- renderText({
#    data <- mata.anggaran
#    data[ , BELANJABARANGDANJASA := format(BELANJABARANGDANJASA, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
#    data[ , BELANJAMODAL := format(BELANJAMODAL, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
#    data[ , BELANJAPEGAWAI := format(BELANJAPEGAWAI, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
#    data[ , TOTAL := format(TOTAL, scientific = FALSE, width = 15, trim = FALSE, big.mark = ".", justify = "right")]
#    as.character(str(data))
#  })
})