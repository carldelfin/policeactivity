library(shiny)
library(leaflet)

shinyUI(pageWithSidebar(
  headerPanel("Polishändelser"),
  
  sidebarPanel(
    selectInput("county", "Välj län:",
                choices = c("Skåne",
                            "Stockholm",
                            "Västra Götaland",
                            "Kronoberg"),
                selected = "Skåne"),
    
    sliderInput("events", "Antal händelser att visa:",
                min = 1, max = 50, value = 20, step = 1),
    
    submitButton("Uppdatera", icon("refresh"))),
  
  mainPanel(
      leafletOutput("map")
    )
  )
)
