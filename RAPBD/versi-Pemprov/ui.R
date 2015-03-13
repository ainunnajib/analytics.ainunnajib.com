Sys.setlocale('LC_CTYPE', 'en_US.UTF-8')
library(shiny)
load("mata.anggaran.RData")

shinyUI(
  fluidPage(
    tags$head(includeScript("google-analytics.js")),
    titlePanel("Tabel Mata Anggaran Belanja Daerah RAPBD 2015 Pemprov DKI Jakarta"),

    fluidRow(
      column(4, 
             selectInput("UrusanPemerintahan", 
                         "Urusan Pemerintahan:", 
                         c("All", 
                           unique(as.character(mata.anggaran$UrusanPemerintahan))))
      ),
      column(4, 
             selectInput("Organisasi", 
                         "SKPD:", 
                         c("All", 
                           unique(as.character(mata.anggaran$Organisasi))))
      ),
      column(4, 
             selectInput("KodeRekening", 
                         "Kode Rekening:", 
                         c("All", 
                           unique(as.character(mata.anggaran$KodeRekening))))
      )        
    ),
    
    fluidRow( downloadButton('downloadData', 'Download') ),

    fluidRow(
      dataTableOutput(outputId="table")
    ),
    
    fluidRow(
      textOutput(outputId = "debug")
    )
  )  
)