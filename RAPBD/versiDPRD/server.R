library(shiny)
library(data.table)
load("rapbd.dprd.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- rapbd.dprd
    data[ , Pagu := format(Pagu, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , Tambah := format(Tambah, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , Kurang := format(Kurang, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , HasilPembahasan := format(HasilPembahasan, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    if (input$KomisiDPRD != "All"){
      data <- data[data$KomisiDPRD == input$KomisiDPRD,]
    }
    if (input$SKPD != "All"){
      data <- data[data$SKPD == input$SKPD,]
    }
    if (input$KodeRekening != "All"){
      data <- data[data$KodeRekening == input$KodeRekening,]
    }
    data
  })
  
  datasetInput <- reactive({
    data <- rapbd.dprd
    if (input$KomisiDPRD != "All"){
      data <- data[data$KomisiDPRD == input$KomisiDPRD,]
    }
    if (input$SKPD != "All"){
      data <- data[data$SKPD == input$SKPD,]
    }
    if (input$KodeRekening != "All"){
      data <- data[data$KodeRekening == input$KodeRekening,]
    }
    data
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste('RAPBD', input$KomisiDPRD, input$SKPD, paste0(input$KodeRekening, '.csv'), sep='-') 
    },
    content = function(file) {
      write.table(format(datasetInput(), scientific = FALSE, trim = TRUE, big.mark = "."), 
                  file = file, sep = "|", quote = FALSE)
    }
  )
  
})