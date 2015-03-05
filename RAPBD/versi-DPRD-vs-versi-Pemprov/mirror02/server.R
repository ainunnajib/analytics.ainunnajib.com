library(shiny)
library(data.table)
load("DPRD.Pemprov.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- DPRD.Pemprov
    data[ , DPRD.Pagu := paste("Rp.", format(DPRD.Pagu, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , DPRD.Tambah := paste("Rp.", format(DPRD.Tambah, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , DPRD.Kurang := paste("Rp.", format(DPRD.Kurang, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , DPRD.HasilPembahasan := paste("Rp.", format(DPRD.HasilPembahasan, scientific = FALSE, width = 15, big.mark = "."))]

    data[ , Pemprov.BelanjaBarangDanJasa := paste("Rp.", format(Pemprov.BelanjaBarangDanJasa, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , Pemprov.BelanjaModal := paste("Rp.", format(Pemprov.BelanjaModal, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , Pemprov.BelanjaPegawai := paste("Rp.", format(Pemprov.BelanjaPegawai, scientific = FALSE, width = 15, big.mark = "."))]
    data[ , Pemprov.Total := paste("Rp.", format(Pemprov.Total, scientific = FALSE, width = 15, big.mark = "."))]
    
    if (input$Komisi.DPRD != "All"){
      data <- data[data$Komisi.DPRD == input$Komisi.DPRD,]
    }
    if (input$SKPD.DPRD != "All"){
      data <- data[data$SKPD.DPRD == input$SKPD.DPRD,]
    }
    if (input$MataAnggaran != "All"){
      data <- data[data$MataAnggaran == input$MataAnggaran,]
    }
    
    if (input$UrusanPemerintahan.Pemprov != "All"){
      data <- data[data$UrusanPemerintahan.Pemprov == input$UrusanPemerintahan.Pemprov,]
    }
    if (input$SKPD.Pemprov != "All"){
      data <- data[data$SKPD.Pemprov == input$SKPD.Pemprov,]
    }
    
    data
  }
  #, options = list(
  #  columnDefs = list(list(targets = c(5, 6, 7, 8, 9, 10, 11, 12), type = "num-fmt"))
  #)
  )
  
  datasetInput <- reactive({
    data <- DPRD.Pemprov
    if (input$Komisi.DPRD != "All"){
      data <- data[data$Komisi.DPRD == input$Komisi.DPRD,]
    }
    if (input$SKPD.DPRD != "All"){
      data <- data[data$SKPD.DPRD == input$SKPD.DPRD,]
    }
    if (input$MataAnggaran != "All"){
      data <- data[data$MataAnggaran == input$MataAnggaran,]
    }

    if (input$UrusanPemerintahan.Pemprov != "All"){
      data <- data[data$UrusanPemerintahan.Pemprov == input$UrusanPemerintahan.Pemprov,]
    }
    if (input$SKPD.Pemprov != "All"){
      data <- data[data$SKPD.Pemprov == input$SKPD.Pemprov,]
    }

    data
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste('RAPBD', input$Komisi.DPRD, input$SKPD.DPRD, input$SKPD.Pemprov, paste0(input$MataAnggaran, '.csv'), sep='-') 
    },
    content = function(file) {
      write.table(format(datasetInput(), scientific = FALSE, trim = TRUE, big.mark = "."),
                  file = file, sep = ",", row.names = FALSE, quote = TRUE)
    }
  )
  
})