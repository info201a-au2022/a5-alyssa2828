library(shiny)
library(ggplot2)
library(tidyverse)

climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)
climate_data[climate_data==""] <- NA

country_total <- unique(climate_data$iso_code) %>% 
  na.omit(climate_data$iso_code) %>% 
  length()

country_highest <- climate_data %>%
  summarize(country, iso_code, year, co2) %>%
  na.omit(climate_data$iso_code) %>%
  arrange(desc(co2)) %>%
  filter(co2 == max(co2)) %>%
  pull(country)

highest_co2 <- climate_data %>%
  summarize(country, iso_code, year, co2) %>%
  na.omit(climate_data$iso_code) %>%
  arrange(desc(co2)) %>%
  filter(co2 == max(co2)) %>%
  pull(co2)

server <- function(input, output) {
  
  output$value1 <- renderText({
    paste0("They categorized the data according to ", country_total, " countries, and the country with the most Carbon Dioxide (CO2) is
    ", country_highest, " with ", highest_co2, " million tonnes. Their approaches displays the total yearly production-based carbon dioxide (CO2) emissions 
    in million tonnes without taking into account changes in land use. The methodology employed here is based on territorial emissions, 
    which exclude emissions present in traded commodities. In this project, I'm analyzing the Carbon Dioxide (CO2) pattern from 1750 to 2021. 
    While some countries may not have their data available since the 1750, we can see a prominent pattern that 
    Greenhouse Gas Emissions significantly rise from year to year.")
  })
  
  output$pickCountry <- renderUI({
    selectInput("country", 
                "Select Country:", 
                choices = unique(climate_data$country))
  })
  
  output$yearRange <- renderUI({
    sliderInput("year", 
                "Select Year Range:", 
                min = min(climate_data$year, na.rm = TRUE), 
                max = max(climate_data$year, na.rm = TRUE),
                value = c(1750, 2021),
                sep = "",
                step = 1)
  })
  
  output$graphType <- renderUI({
    radioButtons("graph",
                 "Select Type of Graph:",
                 choices = list("Scatter Plot" = "Scatter Plot",
                                "Bar Graph" = "Bar Graph"),
                                selected = "Scatter Plot")
  })
  
  scatterPlot <- reactive({
    require(scales)
    climate_data %>% 
      filter(year <= input$year[2] & year >= input$year[1]) %>% 
      filter(country %in% input$country) %>% 
        ggplot(aes(year, co2)) +
        geom_point() +
        labs(x = "Year",
             y = "Carbon Dioxide Levels (CO2 in million tonnes)", 
             title = "Carbon Dioxide Levels in Selected Country (1750-2021)")
  })
  
  barGraph <- reactive({
    require(scales)
    climate_data %>% 
      filter(year <= input$year[2] & year >= input$year[1]) %>% 
      filter(country %in% input$country) %>% 
      ggplot(aes(year, co2)) +
      geom_col() +
      labs(x = "Year",
           y = "Carbon Dioxide Levels (CO2)", 
           title = "Carbon Dioxide Levels in Selected Country (1750-2021)") +
      xlim(input$year[1], input$year[2])
  })
  
  pickGraph <- reactive({
    switch(input$graph, "Scatter Plot" = scatterPlot(), "Bar Graph" = barGraph())
  })
  
  output$showPlot <- renderPlot({
    pickGraph()
  })
  
}