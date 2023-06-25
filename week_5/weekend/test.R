library(shiny)
library(tidyverse)




game_sale <- CodeClanData::game_sales





ui <- fluidPage(
  theme = "style_guide.css",
  
  titlePanel(tags$h1("Test"))
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

