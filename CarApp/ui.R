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
                h2("Select period: Single year or a specific period."),
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
            ),
            
            br(),
            h3("Tabs for more information"),
            br(),
            h4("Odometer - Total kilometres"),
            h4("Refills - Information on refills"),
            h4("Prices - Fuel price at refill"),
            h4("Fuel - Fuel consumption"),
            h4("Data - Raw data"),
            br()
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
                plotlyOutput("paid")),
            
            tabPanel("Fuel price history",
                     h4("Fuel price per litre over time"),
                     plotlyOutput("price")),
            
            tabPanel("Fuel consumption",
                     h4("Fuel consumption in l / 100 km"),
                     h5(tableOutput("consSummary")),
                     plotlyOutput("cons")),
        
            tabPanel("Data",
                     h4("Data"),
                     h5(tableOutput("dataSummary"))
        ))
    ))
)))
