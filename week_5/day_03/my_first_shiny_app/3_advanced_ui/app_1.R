library(shiny)
library(tidyverse)
library(bslib)

olympics_overall_medals <- read_ecsv("data/olympics_overall_medals.csv")
all_teams <- olympics_overall_medals %>% 
  distinct(team) %>% 
  pull()

ui <- fluidPage(
  theme = bs_theme(bootswatch = "quartz"),
  
  titlePanel(tags$h1("Olympic Medals")),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("season_input",
                   tags$i("Summer or Winter Olympics?"),
                   choices = c("Summer", "Winter")
      ),
      
      selectInput("team_input",
                  tags$b("Which Team?"),
                  choices = all_teams
      )
    ),
    
    mainPanel(
      plotOutput("medal_plot"),
      
      br(),
      
      HTML("<br><br><br>"),
      
      tags$a("The Olympics website",
             href = "https://www.Olympic.org")
    )
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


