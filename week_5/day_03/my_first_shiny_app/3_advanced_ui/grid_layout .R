library(shiny)
library(tidyverse)
library(bslib)

olympics_overall_medals <-
  read_csv("data/olympics_overall_medals.csv")
all_teams <- olympics_overall_medals %>%
  distinct(team) %>%
  pull()

ui <- fluidPage(
  theme = bs_theme(bootswatch = "quartz"),
  
  titlePanel(tags$h1("Olympic Medals")),
  
  fluidRow(plotOutput("medal_plot")),
  
  fluidRow(column(
    width = 4,
    radioButtons(
      "season_input",
      tags$i("Summer or Winter Olympics?"),
      choices = c("Summer", "Winter")
    )
  ),
  
  column(
    width = 4,
    selectInput("team_input",
                tags$b("Which Team?"),
                choices = all_teams)),
  column(
      width = 4,
      tags$a("The Olympics Website", 
             href = "https://www.Olympic.org"))
    
  )
  
 
  )
  



server <- function(input, output) {
  output$medal_plot <- renderPlot({
    olympics_overall_medals %>%
      filter(team == input$team_input) %>%
      filter(season == input$season_input) %>%
      ggplot() +
      aes(x = medal, y = count, fill = medal) +
      geom_col()
  })
  
}

shinyApp(ui = ui, server = server)
