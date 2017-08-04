library(shiny)
library(httr)
library(jsonlite)
library(lubridate)
library(leaflet)
library(leaflet.extras)

function(input, output) {
  
  output$map <- renderLeaflet({
    
    options(stringsAsFactors = FALSE)
    
    if (input$county == "Skåne") {
      path <- "/api/events/?area=Skåne län"
    }
    if (input$county == "Stockholm") {
      path <- "/api/events/?area=Stockholms län"
    }
    if (input$county == "Västra Götaland") {
      path <- "/api/events/?area=Västra Götalands län"
    }
    if (input$county == "Kronoberg") {
      path <- "/api/events/?area=Kronobergs län"
    }
    
    url  <- "http://brottsplatskartan.se"
    finalPath <- paste(path, "&limit=", input$events)
    
    raw.data <- GET(url = url, path = finalPath) # get URL
    raw.data <- rawToChar(raw.data$content)      # convert to character
    raw.data <- fromJSON(raw.data)               # convert from JSON to R data
    data <- raw.data$data                        # store as 'data
    
    data <- data[-c(1, 3, 5, 8:9, 11, 14:22)]    # remove columns we don't want
    
    # extracting date, timestamp out of a single string
    data$date <- gsub("T.*", "", data$pubdate_iso8601)
    data$pubdate_iso8601 <- gsub(".*T", "", data$pubdate_iso8601)
    data$pubdate_iso8601 <- gsub("\\+.*", "", data$pubdate_iso8601)
    
    # create popup windows
    popup <- paste0("<br><b>Ärende: </b>", data$title_type,
                    "<br><b>Plats: </b>", data$location_string,
                    "<br><b>Datum: </b>", data$date,
                    "<br><b>Tid: </b>", data$pubdate_iso8601,
                    "<br><b>Sammanfattning: </b>", data$description,
                    "<br><b>Detaljerad beskrivning: </b><br>", data$content)
    
    # add popup lables
    label <- data$title_type
  
    # create map
    leaflet() %>%
      
      # map overlays go here, with OSM as default
      addTiles(group = "OSM (default)") %>%
      addProviderTiles("Esri.WorldGrayCanvas", group = "ESRI Gray Canvas") %>%
      addProviderTiles("CartoDB.DarkMatterNoLabels", group = "CartoDB DarkMatterNL") %>%
    
      # each event is printed on the map as a circular marker
      addCircleMarkers(data = data,
                       lng =~ lng,
                       lat =~ lat,
                       popup = popup,
                       label = label,
                       labelOptions = labelOptions(noHide = F),
                       radius = 6,
                       color = "#D24B19",
                       stroke = FALSE,
                       fillOpacity = 0.8) %>%
      
      # make overlay options clickable but hidden
      addLayersControl(baseGroups = c("OSM (default)",
                                      "ESRI Gray Canvas",
                                      "CartoDB DarkMatterNL"),
                       options = layersControlOptions(collapsed = TRUE))
  })
}