library(shiny)
load("mata.anggaran.RData")

shinyUI(
  fluidPage(
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

    fluidRow(
      dataTableOutput(outputId="table")
    )    
  )  
)