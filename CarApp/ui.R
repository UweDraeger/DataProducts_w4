library(shiny)
library(plotly )

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("Car Data"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            dateRangeInput(
                "DateRange",
                "Date range: ",
                start = "2013-01-01",
                end = "2021-05-31",
                format = "yyyy-mm-dd",
                separator = "-"
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Odometer", 
                         plotlyOutput("odometer")),
                
                tabPanel("Histograms", 
                         plotlyOutput("distance"),
                         plotlyOutput("fuel"),
                         plotlyOutput("paid")),
                
                tabPanel("Price history",
                         plotlyOutput("price")),
                
                tabPanel("Fuel Consumption",
                         plotlyOutput("cons"))
            )
        )
    )
))
