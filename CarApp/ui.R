library(shiny)
library(plotly )


# Define UI
shinyUI(fluidPage(fluidRow(
    # Application title
    titlePanel(h1("Monitoring fuel consumption")),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            radioButtons(
                "Radio",
                h2("Select a year or specify a period"),
                choices = list("Year" = "Year", "Period" = "Range")
            ),
            
            selectInput("SelectedYear",
                        h3("Year"),
                        choices = c(2013:2021)),
            
            dateRangeInput(
                "DateRange",
                h3("Period"),
                start = "2013-01-01",
                end = "2021-05-31",
                format = "yyyy-mm-dd",
                separator = "-"
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(tabsetPanel(
            tabPanel("Odometer",
                     h4("Value displayed on the odometer for the period specified."),
                     h5(tableOutput("odoSummary")),
                     plotlyOutput("odometer")),
            
            tabPanel(
                "Refills",
                h4("Distances between refills in kilometres"),
                h5(tableOutput("distSummary")),
                plotlyOutput("distance"),
                
                h4("Fuel refilled in litres"),
                h5(tableOutput("litreSummary")),
                plotlyOutput("fuel"),
                
                h4("Money paid in Euro"),
                h5(tableOutput("euroSummary")),
                plotlyOutput("paid")
            ),
            
            tabPanel("Price history",
                     plotlyOutput("price")),
            
            tabPanel("Fuel Consumption",
                     plotlyOutput("cons"))
        ))
    )
)))
