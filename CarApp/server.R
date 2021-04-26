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
        price = Preis,
        cons = Verbrauch
    )


# Shiny server 
shinyServer(function(input, output) {

    # return selection from radio button
    RadioChoice <- reactive({
        RadioChoice <- input$Radio
    })
    
    # filter initial data to selection from radio button
    AUTO3 <- reactive({
        if (RadioChoice() == "Year")
            AUTO2 %>% filter(year(Date) == year(as_date(paste(
                as.character(input$SelectedYear), "-01-01"
            ))))
        else
            AUTO2 %>% filter(Date >= input$DateRange[1] &
                                 Date <= input$DateRange[2])
    })
    
    # create summary tables 
    nrefills <- reactive({
        nrow(AUTO3())
    })
    
    odoSummTable <- reactive({
        tribble(
            ~StartDate, ~StartValue, ~EndDate, ~EndValue, ~Total,
            as.character(min(AUTO3()$Date)), 
            min(AUTO3()$odometer), 
            as.character(max(AUTO3()$Date)),
            max(AUTO3()$odometer), 
            max(AUTO3()$odometer) - min(AUTO3()$odometer)
            )
        })

    distSummTable <- reactive({
        tribble(
            ~Count, ~Minimum, ~Maximum, ~Average,
            nrow(AUTO3()), min(AUTO3()$distance), max(AUTO3()$distance), mean(AUTO3()$distance)
            )
        })

    litreSummTable <- reactive({
        tribble(
            ~Count, ~Minimum, ~Maximum, ~Average,
            nrow(AUTO3()), min(AUTO3()$fuel, na.rm = TRUE), max(AUTO3()$fuel, na.rm = TRUE), mean(AUTO3()$fuel, na.rm = TRUE)
        )
    })
 
    paidSummTable <- reactive({
        tribble(
            ~Count, ~Minimum, ~Maximum, ~Average,
            nrow(AUTO3()),min(AUTO3()$paid), max(AUTO3()$paid), mean(AUTO3()$paid)
        )
    })
    
    consSummTable <- reactive({
        tribble(
            ~Count, ~Minimum, ~Maximum, ~Average,
            nrow(AUTO3()), min(AUTO3()$cons, na.rm = TRUE), max(AUTO3()$cons, na.rm = TRUE), mean(AUTO3()$cons, na.rm = TRUE)
        )
    })
    
    dataSummTable <- reactive({
        AUTO3() %>%
            mutate(Date = as.character(AUTO3()$Date))
    })
        
    output$nrefills <- renderText(nrefills())
    
    # Tables
    output$odoSummary <- renderTable(odoSummTable())
    output$distSummary <- renderTable(distSummTable())
    output$litreSummary <- renderTable(litreSummTable())
    output$euroSummary <- renderTable(paidSummTable())
    output$consSummary <- renderTable(consSummTable())
    output$dataSummary <- renderDataTable(dataSummTable())
    
    # Charts
    output$odometer <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = Date, y = odometer)) +
            geom_point(color = "#dd4814") +
            geom_smooth() +
            geom_smooth(color = "black", se = FALSE) +
            labs(title = "Odometer",
                 x = "Date",
                 y = "Distance in km")
    })
    output$distance <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = distance)) +
            geom_histogram(binwidth = 50) +
            labs(title = "",
                 x = "Distance",
                 y = "Count")
    })    
    output$fuel <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = fuel)) +
            geom_histogram(binwidth = 5) +
            labs(title = "",
                 x = "Amount",
                 y = "Count")
    })    
    output$paid <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = paid)) +
            geom_histogram(binwidth = 5) +
            labs(title = "",
                 x = "Amount",
                 y = "Count")
    })    
    output$price <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = Date, y = price)) +
            geom_point(color = "#dd4814") +
            geom_smooth() +
            geom_smooth(color = "black", se = FALSE) +
            labs(title = "",
                 x = "Date",
                 y = "Price")
    })    
    output$cons <- renderPlotly({
        ggplot(
            data = AUTO3(),
            aes(x = Date, y = cons)) +
            geom_point(color = "#dd4814") +
            geom_smooth(method = "lm") +
            geom_smooth(method = "lm", color = "black", se = FALSE) +
            labs(title = "",
                 x = "Date",
                 y = "Consumption")
    })
   
})
