library(shiny)
library(plotly )

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel(h1("Car Data")),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            
            radioButtons(
                "Radio",
                h2("Select full year or range"),
                choices = list("Year" = "Year", "Period" = "Range")
            ),
            
            selectInput(
                "SelectedYear",
                h3("Year"),
                choices = c(2013:2021)
            ),
            
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
