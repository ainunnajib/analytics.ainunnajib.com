library(shiny)
library(data.table)
load("DPRD.Pemprov.RData")

shinyServer(function(input, output) {
  output$table <- renderDataTable({
    data <- DPRD.Pemprov
    data[ , DPRD.Pagu := format(DPRD.Pagu, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , DPRD.Tambah := format(DPRD.Tambah, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , DPRD.Kurang := format(DPRD.Kurang, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , DPRD.HasilPembahasan := format(DPRD.HasilPembahasan, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]

    data[ , Pemprov.BelanjaBarangDanJasa := format(Pemprov.BelanjaBarangDanJasa, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , Pemprov.BelanjaModal := format(Pemprov.BelanjaModal, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , Pemprov.BelanjaPegawai := format(Pemprov.BelanjaPegawai, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    data[ , Pemprov.Total := format(Pemprov.Total, scientific = FALSE, trim = FALSE, big.mark = ".", justify = "right")]
    
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
  }, options = list(
    columnDefs = list(list(targets = c(5, 6, 7, 8, 9, 10, 11, 12), type = "num-fmt"))
  ))
  
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