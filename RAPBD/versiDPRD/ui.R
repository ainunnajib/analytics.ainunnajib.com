library(shiny)
load("rapbd.dprd.RData")

shinyUI(
  fluidPage(
    tags$head(includeScript("google-analytics.js")),
    titlePanel("Tabel Mata Anggaran Belanja Daerah RAPBD 2015 versi DPRD DKI Jakarta"),

    fluidRow(
      column(4, 
             selectInput("KomisiDPRD", 
                         "Komisi DPRD:", 
                         c("All", 
                           unique(as.character(rapbd.dprd$KomisiDPRD))))
      ),
      column(4, 
             selectInput("SKPD", 
                         "SKPD:", 
                         c("All", 
                           unique(as.character(rapbd.dprd$SKPD))))
      ),
      column(4, 
             selectInput("KodeRekening", 
                         "Kode Rekening:", 
                         c("All", 
                           unique(as.character(rapbd.dprd$KodeRekening))))
      )        
    ),
    
    fluidRow( downloadButton('downloadData', 'Download') ),

    fluidRow(
      dataTableOutput(outputId="table")
    )    
  )  
)