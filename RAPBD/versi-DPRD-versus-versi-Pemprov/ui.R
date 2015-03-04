library(shiny)
load("DPRD.Pemprov.RData")

shinyUI(
  fluidPage(
    tags$head(includeScript("google-analytics.js")),
    titlePanel("Tabel Perbandingan Mata Anggaran Belanja Daerah RAPBD 2015 versi DPRD versus versi Pemprov DKI Jakarta"),

    fluidRow(
      column(4, 
             selectInput("Komisi.DPRD", 
                         "Komisi DPRD:", 
                         c("All", 
                           unique(as.character(DPRD.Pemprov$Komisi.DPRD))))
      ),
      column(4, 
             selectInput("SKPD.DPRD", 
                         "SKPD DPRD:", 
                         c("All", 
                           unique(as.character(DPRD.Pemprov$SKPD.DPRD))))
      ),
      column(4, 
             selectInput("MataAnggaran", 
                         "Mata Anggaran:", 
                         c("All", 
                           unique(as.character(DPRD.Pemprov$MataAnggaran))))
      )        
    ),

    fluidRow(
      column(4, 
             selectInput("UrusanPemerintahan.Pemprov", 
                         "Urusan Pemerintahan:", 
                         c("All", 
                           unique(as.character(DPRD.Pemprov$UrusanPemerintahan.Pemprov))))
      ),
      column(4, 
             selectInput("SKPD.Pemprov", 
                         "SKPD Pemprov:", 
                         c("All", 
                           unique(as.character(DPRD.Pemprov$SKPD.Pemprov))))
      ),
      column(4, 
             downloadButton('downloadData', 'Download')
      )        
    ),
    
    fluidRow(
      dataTableOutput(outputId="table")
    )    
  )  
)