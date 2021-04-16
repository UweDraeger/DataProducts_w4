library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)

# Load data and rename variables

AUTO2 <- tibble(read_delim(
    "AUTO2.csv",
    ";",
    escape_double = FALSE,
    col_types = cols(Datum = col_date(format = "%d/%m/%Y"),
                     X8 = col_skip()),
    trim_ws = TRUE
))
AUTO2 <- AUTO2 %>%
    rename(
        Date = Datum,
        odometer = Kilometerstand,
        distance = Gefahren,
        fuel = Getankt,
        paid = Bezahlt,
        ppl = Preis,
        cons = Verbrauch
    )


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    RadioChoice <- reactive({
        RadioChoice <- input$Radio
    })
    
    AUTO3 <- reactive({
        if (RadioChoice() == "Year")
            AUTO2 %>% filter(year(Date) == year(as_date(paste(
                as.character(input$SelectedYear), "-01-01"
            ))))
        else
            AUTO2 %>% filter(Date >= input$DateRange[1] &
                                 Date <= input$DateRange[2])
    })
    
    
    output$odometer <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = Date, y = odometer)) +
            geom_point() +
            geom_smooth() +
            labs(title = "Odometer",
                 x = "Date",
                 y = "Distance in km")
    })

    output$distance <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = distance)) +
            geom_histogram() +
            labs(title = "Distances between refills in kilometres",
                 x = "Distance",
                 y = "Count")
    })    

    output$fuel <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = fuel)) +
            geom_histogram() +
            labs(title = "Refill amounts in litres",
                 x = "Amount",
                 y = "Count")
    })    

    output$paid <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = paid)) +
            geom_histogram() +
            labs(title = "Amounts paid in Euro",
                 x = "Amount",
                 y = "Count")
    })    

    output$price <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = Date, y = ppl)) +
            geom_point() +
            geom_smooth() +
            labs(title = "Price in Euro per litre",
                 x = "Date",
                 y = "Price")
    })    

    output$cons <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = Date, y = cons)) +
            geom_point() +
            geom_smooth() +
            labs(title = "Fuel consumption in litres / 100 km",
                 x = "Date",
                 y = "Consumption")
    })    
    
})
