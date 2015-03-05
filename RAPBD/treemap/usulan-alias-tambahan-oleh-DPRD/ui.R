library(shiny)

shinyUI(
  fluidPage(
    tags$head(includeScript("google-analytics.js")),
    titlePanel("Interactive Treemap - Usulan/Tambahan oleh DPRD"),
    h5("Data yang dipakai adalah yang ada di versi DPRD namun tidak ada di versi Pemprov dan DPRD.Pagu = 0."),
    h6("Pagu adalah pembulatan ke atas dari nilai anggaran yang diusulkan Pemprov."),
    h6("Pagu = 0 bermakna Pemprov tidak mengusulkan mata anggaran tersebut."),
    h5("klik kiri untuk drill-down masuk, klik kanan untuk drill-up keluar/mundur"),
    htmlOutput('plot')
  )  
)