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
                h2("Select full year or range"),
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
                     h5("Value displayed on the odometer for the period specified."),
                     h5(paste("Start value (km): "), verbatimTextOutput("odoStart")),
                     h5(paste("End value (km) : "), verbatimTextOutput("odoEnd")),
                     h5(paste("Total distance (km) : "), verbatimTextOutput("odoTotal")),
                     plotlyOutput("odometer")),
            
            tabPanel(
                "Refills",
                h5("Average distance between refills (km) : ", textOutput("meanDistance")),
                plotlyOutput("distance"),
                plotlyOutput("fuel"),
                plotlyOutput("paid")
            ),
            
            tabPanel("Price history",
                     plotlyOutput("price")),
            
            tabPanel("Fuel Consumption",
                     plotlyOutput("cons"))
        ))
    )
)))
