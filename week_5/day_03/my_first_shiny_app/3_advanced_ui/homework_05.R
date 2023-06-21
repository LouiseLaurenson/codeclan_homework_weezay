library(tidyverse)
library(shiny)
library(bslib)
library(CodeClanData)
library(DT)


beer <- beer %>%
  mutate(calories = as.double(calories))


brewer_names <- beer %>%
  distinct(brewer) %>%
  pull()

best_beer <- 
  beer %>% 
  group_by(brand, calories) %>% 
  summarise(calories) %>% 
  arrange((calories)) %>% 
  head(5)


ui <- fluidPage(theme = bs_theme(bootswatch = "lux"),
                
                titlePanel(tags$h1("Beer 🍻")),
                
                mainPanel(
                  p("Have you ever wondered how bad beer is for you?")
                  
                ),
                
                tabsetPanel(
                  tabPanel("How Many Cal?",
                           
                           fluidRow(plotOutput("beer_plot")),
                           
                           fluidRow(column(
                             width = 6,
                             selectInput(
                               "brewer",
                               tags$b("Which Brewer?"),
                               choices = unique(brewer_names),
                               selected = "Budweiser"
                             )
                           ))),
                  tabPanel("How Many Carbs?",
                           fluidRow(plotOutput("carbs_plot")),
                           
                           fluidRow(column(
                             width = 6,
                             selectInput(
                               "brewer_carbs",
                               tags$b("Which Brewer?"),
                               choices = unique(brewer_names),
                               selected = "Budweiser"
                             )
                           ))),
                  tabPanel("Data",
                           fluidRow(dataTableOutput("data")))
                  
                  
                ))



server <- function(input, output) {
  output$beer_plot <- renderPlot(
    beer %>%
      filter(brewer == input$brewer) %>%
      ggplot() +
      aes(
        x = reorder(brand, percent),
        y = calories,
        fill = percent
      ) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "gray75", high = "gray25") +
      labs(x = "Beer Name",
           y = "Calories") +
      theme(text = element_text(size = 18,
                                family = "Nunito Sans")) +
      theme_classic()
  )
  
  output$carbs_plot <- renderPlot(
    beer %>%
      filter(brewer == input$brewer_carbs) %>%
      ggplot() +
      aes(
        x = reorder(brand, percent),
        y = carbohydrates,
        fill = percent
      ) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "gray75", high = "gray25") +
      labs(x = "Beer Name",
           y = "Carbohydrates") +
      theme(text = element_text(size = 18,
                                family = "Nunito Sans")) +
      theme_classic()
  )
  
  output$data <- renderDataTable(
    beer,
    options = list(pageLenght = 10,
                   initComplete = I('function(setting, json) { alert("done"); }'))
  )
  
}


shinyApp(ui = ui, server = server)
