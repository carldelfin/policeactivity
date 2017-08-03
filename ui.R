library(shiny)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Tio senaste polishändelserna i Skåne län"),
  mainPanel(
      leafletOutput("map")
    )
  )
)
