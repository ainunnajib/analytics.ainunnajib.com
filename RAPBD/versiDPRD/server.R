library(shiny)
library(data.table)
load("rapbd.dprd.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- rapbd.dprd
    data[ , Pagu := format(Pagu, scientific = FALSE, width = 15, big.mark = ".")]
    data[ , Tambah := format(Tambah, scientific = FALSE, width = 15, big.mark = ".")]
    data[ , Kurang := format(Kurang, scientific = FALSE, width = 15, big.mark = ".")]
    data[ , HasilPembahasan := format(HasilPembahasan, scientific = FALSE, width = 15, big.mark = ".")]
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
  }, options = list(
    columnDefs = list(list(targets = c(4, 5, 6, 7), type = "num-fmt"))
  ))
  
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
                  file = file, sep = ",", row.names = FALSE, quote = TRUE)
    }
  )
  
})