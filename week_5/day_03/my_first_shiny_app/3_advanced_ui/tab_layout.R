library(shiny)
library(tidyverse)
library(bslib)

olympics_overall_medals <-
  read_csv("data/olympics_overall_medals.csv")
all_teams <- olympics_overall_medals %>%
  distinct(team) %>%
  pull()

ui <- fluidPage(
  theme = bs_theme(bootswatch = "yeti"),
  
  titlePanel(tags$h1("Olympic Medals")),
  
  tabsetPanel(
    tabPanel("Plot",
             br(),
             fluidRow(plotOutput("medal_plot"))),
    
    tabPanel(
      "Which Season ?",
      radioButtons(
        "season_input",
        tags$i("Summer or Winter Olympics?"),
        choices = c("Summer", "Winter")
        
        
      )
    ),
    tabPanel(
      "Which team?",
      selectInput("team_input",
                  tags$b("Which Team?"),
                  choices = all_teams)
      
    ),
    tabPanel(
      "Olympic Website",
      br(),
      tags$a("The Olympics website",
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
      geom_col() +
      scale_fill_manual(values = c("brown", "gold", "gray40"))
  })
  
}

shinyApp(ui = ui, server = server)
