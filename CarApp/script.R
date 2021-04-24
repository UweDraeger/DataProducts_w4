library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)

setwd("~/Coursera/Scripts and Data/Developing Data Products/DataProducts_w4/CarApp")
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


litreSummTable <- tribble(
    ~Count, ~Minimum, ~Maximum, ~Average,
    nrow(AUTO2), min(AUTO2$fuel, na.rm = TRUE), max(AUTO2$fuel, na.rm = TRUE), mean(AUTO2$fuel, na.rm = TRUE)
  )


MakeTable <- function(tblName, colName) {
  print(paste0(tblName,"$",colName))
#  tribble(
#    ~Count, ~Minimum,
#    nrow(tblName), min(paste0(tblName,"$",colName))
#  )
}

ggplot(data = AUTO2, aes(x = I(decimal_date(Date) - year(Date)), y = cons)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "", y = "l / 100 km") +
  scale_x_continuous(breaks = c(0.25, .5, .75, 1),
                     labels = c("Mar", "Jun", "Sep", "Dec")) +
  facet_wrap(vars(year(Date)))


ggplot(data = AUTO2, aes(x = I(decimal_date(Date) - year(Date)), y = distance)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(vars(year(Date)))
