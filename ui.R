library(shiny)
library(leaflet)

# fluidPage layout
shinyUI(fluidPage(
  
  # create a single row
  fluidRow(
      
      # set row width to 12 (i.e. maximum as per Bootstrap)  
      column(width = 12,
             
             # app title
             h3("Polishändelser"),
             
             # app description
             p("Här syns en karta över de senast inrapporterade polishändelserna i valt län.
               Du kan klicka på varje händelse (röda punkter) och se en beskrivning över vad som har inträffat.
               Du kan också välja antal händelser att visa på kartan, och välja en annan layout på kartan
               via knappen uppe till höger.",
               br(), br(),
               "Data kommer från ", a("Brottsplatskartan", href = "https://brottsplatskartan.se/"),
               " sidan är skapad med ", a("Shiny", href = "https://shiny.rstudio.com/"),
               "och all kod finns ", a("här.", href = "https://github.com/carldelfin/policeactivity")),
             
             # add another row
             fluidRow(
               
               # left column, define width 4 (out of 12)
               column(width = 4,
                      
                      # sidebarPanel should be maximum width (100%)
                      sidebarPanel(width = 100,
                                   
                                   # input is 'county' variable
                                   selectInput("county", "Välj län:",
                                               choices = c("Skåne",
                                                           "Stockholm",
                                                           "Västra Götaland",
                                                           "Kronoberg"),
                                               
                                               # Skåne selected by default
                                               selected = "Skåne"),
                                   
                                   # input is 'events' variable
                                   sliderInput("events", "Antal händelser att visa:",
                                               min = 1, max = 50, value = 20, step = 1),
                                   
                                   # add a submit button
                                   submitButton("Uppdatera", icon("refresh")))),
               
               # right column, width 8 out of 12
               column(width = 8,
                      
                      # leaflet map goes here
                      leafletOutput("map"))
               )
             )
      )
  )
)