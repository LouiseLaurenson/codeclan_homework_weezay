library(shiny)
library(tidyverse)

olympics_overall_media <- read_csv("2_basic_shiny_apps/data/olympics_overall_medals.csv")

all_teams <- olympics_overall_media %>% 
  distinct(team) %>% 
  pull()


ui <- fluidPage(#define the user interface (determines the layout and appearance of the app, you can use other but this will do)
  
  titlePanel("Title"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "season_input",
                   label = "Summer or Winter Olympics?",
                   choices = c("Summer", "Winter")
      ),
      
      selectInput(inputId = "country_input",
                  label = "Country",
                  choices = all_teams,
                  selected = "Great Britain" #makes the deffalt start
      )
    ), 
    mainPanel(
      plotOutput("medal_plot")
    )
  )
  
  
)
server <- function(input, output) {
  #define the server, this defines the logic of our app
  
  output$medal_plot <- renderPlot({
    
    olympics_overall_media %>% 
      filter(team == input$country_input) %>% 
      filter(season == input$season_input) %>% 
      ggplot() +
      aes(x = medal, y = count, fill = medal)+
      geom_col(show.legend = FALSE)
  })
  
  
}

shinyApp(ui = ui, server = server) #run function with ui and server as inputs