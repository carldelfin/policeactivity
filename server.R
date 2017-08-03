library(shiny)
library(httr)
library(jsonlite)
library(lubridate)
library(raster)       # geodata functions
library(leaflet)      # interactive map
library(htmlwidgets)  # saving widgets

options(stringsAsFactors = FALSE)

function(input, output) {
  
  url  <- "http://brottsplatskartan.se"
  path <- "/api/events/?area=skåne län"
  
  raw.result <- GET(url = url, path = path)
  this.raw.content <- rawToChar(raw.result$content)
  this.content <- fromJSON(this.raw.content)
  data <- this.content$data
  data <- data[-c(1, 3, 5:6, 8:9, 11, 14:22)]
  
  data$pubdate_iso8601 <- gsub(".*T", "", data$pubdate_iso8601)
  data$pubdate_iso8601 <- gsub("\\+.*", "", data$pubdate_iso8601)
  data$content <- gsub("Polisen Skåne.*", "", data$content)

  popup <- paste0("<br><b>Ärende: </b>", data$title_type,
                  "<br><b>Plats: </b>", data$location_string,
                  "<br><b>Tid: </b>", data$pubdate_iso8601,
                  "<br><b>Beskrivning: </b><br>", data$content)
  
  output$map = renderLeaflet({
  
    leaflet() %>%
      
      # map overlays go here, with OSM as defualt
      addTiles(group="OSM (default)") %>%
      addProviderTiles("Esri.WorldGrayCanvas", group = "ESRI Gray Canvas") %>%
      addProviderTiles("CartoDB.DarkMatterNoLabels", group = "CartoDB DarkMatterNL") %>%
      
      # each prison is printed on the map as a circular marker
      addCircleMarkers(data=data, lng=~lng, lat=~lat, popup = popup,
                       radius = 6,
                       color = "#D24B19",
                       stroke = FALSE,
                       fillOpacity = 0.8) %>%
      
      # make options clickable
      addLayersControl(baseGroups = c("OSM (default)",
                                      "ESRI Gray Canvas",
                                      "CartoDB DarkMatterNL"),
                       options = layersControlOptions(collapsed = TRUE))
  })
}