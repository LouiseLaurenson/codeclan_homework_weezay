library(shiny)
library(tidyverse)
library(bslib)
library(CodeClanData)
library(shinydashboard)




games_sales <- CodeClanData::game_sales

games_sales_top <- games_sales %>%
  filter(developer == "EA" |
           developer ==  "Nintendo")
games_sales_ea <- games_sales_top %>%
  filter(developer == "EA") %>%
  filter(publisher == "Electronic Arts") %>%
  distinct(name, .keep_all = TRUE)

games_sales_nin <- games_sales_top %>%
  filter(developer == "Nintendo") %>%
  filter(publisher == "Nintendo") %>%
  distinct(name, .keep_all = TRUE)


both_sales <- games_sales %>%
  filter(developer == "Nintendo" | developer == "EA") %>%
  filter(publisher == "Nintendo" |
           publisher == "Electronic Arts") %>%
  distinct(name, .keep_all = TRUE)

d_names <- both_sales %>% 
  distinct(developer) %>% 
  pull()


ui <- fluidPage(
  #theme = "style_guide1.css",
 theme = bs_theme(bootswatch = "darkly"),
  
  titlePanel(tags$h1("EA vs. Nintendo 🎮")),
  
  
  tabsetPanel(
    tabPanel(
      "EA",
      
      p(
        "EA Games is a prominent video game publisher and developer known for creating and distributing a wide range of popular games across various genres. The company, Electronic Arts Inc. (EA), has been active in the gaming industry since 1982 and has released numerous successful titles."
      ),
      
      fluidRow(column(
        width = 8,
        plotOutput("ea_sales_plot"),
        
        br(),
        
      )),
      fluidRow(column(width = 8,
                      plotOutput("top_critic_ea")),),
      
      br(),
      
      fluidRow(column(width = 8,
                      plotOutput("genre")))
    ),
    
    
    
    
    tabPanel(
      "Nintendo",
      
      p(
        "Nintendo is a renowned video game hardware and software company that has been influential in the gaming industry for decades. The company was founded in 1889 in Kyoto, Japan, initially as a playing card company, and later ventured into toys and electronic games. Nintendo is known for its innovative and unique approach to gaming, creating iconic franchises and gaming devices loved by millions worldwide."
      ),
      
      fluidRow(column(
        width = 8,
        plotOutput("nin_sales_plot"),
        
        br(),
        
      )),
      fluidRow(column(width = 8,
                      plotOutput("top_critic_nin"))),
      
      
      br(),
      
      
      fluidRow(column(width = 8,
                      plotOutput("genre_nin")))
    ),
    
    tabPanel("Compare",
             
             fluidRow(column(width = 5,
                             
                             valueBoxOutput("eaTotalbox",
                                            width = 4)),
                      column(width = 6,
                             valueBoxOutput("ninTotalbox",
                                            width = 8))
                             
                             ),
             
             
             fluidRow(column(
               width = 8,
               radioButtons("developer_choice",
                            "Which Developer?",
                            choices = d_names)
             )),
             fluidRow(column(
               width = 8,
               plotOutput("both_sales_plot")
             )),
             
             br(),
             
             fluidRow(column(
               width = 8,
               plotOutput("top_plot")
             )
               
             ),),
    
    tabPanel("Data",
             
             fluidRow(column(
               width = 5,
               radioButtons(
                 "developer_input",
                 "Which Developer?",
                 choices = c("EA", "Nintendo"),
                 inline = TRUE
               )
             )),
             
             
             DT::dataTableOutput("data"))
    
  )
)






server <- function(input, output) {
  output$data <- DT::renderDataTable({
    games_sales_top %>%
      filter(developer == input$developer_input)
  })
  output$ea_sales_plot <- renderPlot({
    games_sales_ea %>%
      select(year_of_release, sales, critic_score) %>%
      group_by(year_of_release) %>%
      summarise(sales_cout_by = sum(sales)) %>%
      ggplot() +
      aes(x = year_of_release, y = sales_cout_by) +
      geom_line(colour = "#ffa2a2") +
      geom_point(colour = "#ffa2a2") +
      labs(title = "Total Sales By Year",
           y = "Sales by millions",
           x = "Release Year") +
      scale_x_continuous(limits = c(1999, 2016)) +
      scale_y_continuous(limits = c(0, 200)) +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(plot.title = element_text(size = 22)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
  })
  
  
  
  output$top_critic_ea <- renderPlot({
    games_sales_ea %>%
      arrange(desc(critic_score)) %>%
      head(5) %>%
      ggplot() +
      aes(x =  reorder(name, critic_score),
          y = critic_score,
          fill = user_score) +
      geom_col() +
      scale_fill_gradient(low = "#ffa2a2",
                           high = "red",
                           space = "Lab") +
      coord_flip() +
      scale_y_continuous(limits = c(0, 100)) +
      labs(x = "Game Name",
           y = "Critic Score",
           title = "Top 5 Critic Acclaimed Games") +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(plot.title = element_text(size = 24)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
    
  })
  
  
  output$genre <- renderPlot({
    games_sales_ea %>%
      select(genre, sales) %>%
      group_by(genre) %>%
      summarise(sales_by_g = sum(sales)) %>%
      ggplot() +
      aes(x = genre, y = sales_by_g, fill = genre) +
      geom_col(show.legend = FALSE) +
      labs(x = "Genre",
           y = "Total Sales",
           title = "Total Sales By Genre") +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      theme(plot.title = element_text(size = 24)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
    
    
  })
  
  #nintendo
  
  output$nin_sales_plot <- renderPlot({
    games_sales_nin %>%
      select(year_of_release, sales, critic_score) %>%
      group_by(year_of_release) %>%
      summarise(sales_cout_by = sum(sales)) %>%
      ggplot() +
      aes(x = year_of_release, y = sales_cout_by) +
      geom_line(colour = "#e70009") +
      geom_point(colour = "#e70009") +
      labs(title = "Total Sales By Year",
           y = "Sales by millions",
           x = "Release Year") +
      scale_x_continuous(limits = c(1999, 2016)) +
      scale_y_continuous(limits = c(0, 200)) +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(plot.title = element_text(size = 24)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
  })
  
  
  
  output$top_critic_nin <- renderPlot({
    games_sales_nin %>%
      arrange(desc(critic_score)) %>%
      head(5) %>%
      ggplot() +
      aes(x =  reorder(name, critic_score),
          y = critic_score,
          fill = user_score) +
      geom_col() +
      coord_flip() +
      scale_fill_gradient(low = "#e70009",
                          high = "darkred",
                          space = "Lab") +
      scale_y_continuous(limits = c(0, 200)) +
      labs(x = "Game Name",
           y = "Critic Score",
           title = "Top 5 Critic Acclaimed Games") +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(plot.title = element_text(size = 24)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
    
  })
  
  
  output$genre_nin <- renderPlot({
    games_sales_nin %>%
      select(genre, sales) %>%
      group_by(genre) %>%
      summarise(sales_by_g = sum(sales)) %>%
      ggplot() +
      aes(x = genre, y = sales_by_g, fill = genre) +
      geom_col(show.legend = FALSE) +
      labs(x = "Genre",
           y = "Total Sales",
           title = "Total Sales By Genre") +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      theme(plot.title = element_text(size = 24)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
    
    
    
  })
  
  output$both_sales_plot <- renderPlot({
    both_sales %>%
      select(year_of_release, sales, critic_score, developer) %>%
      filter(developer == input$developer_choice) %>%
      group_by(year_of_release) %>%
      summarise(sales_cout_by = sum(sales)) %>%
      ggplot() +
      aes(x = year_of_release, y = sales_cout_by) +
      geom_line() +
      geom_point() +
      labs(title = "Total Sales By Year",
           y = "Sales by millions",
           x = "Release Year") +
      scale_x_continuous(limits = c(1999, 2016)) +
      scale_y_continuous(limits = c(0, 200)) +
      theme_minimal() +
      theme(axis.text = element_text(size = 16)) +
      theme(plot.title = element_text(size = 22)) +
      theme(axis.title = element_text(size = 20, face = "bold"))
    
  })
  
  output$top_plot <- renderPlot({
  both_sales %>%
    arrange(desc(sales)) %>% 
    #filter(developer == input$d_choice) %>% 
    head(20) %>%
    ggplot() +
    aes(x =  reorder(name, sales),
        y = sales,
        fill = developer) +
    geom_col() +
    coord_flip() +
    scale_y_continuous(limits = c(0, 100)) +
    labs(x = "Game Name",
         y = "Sales by million",
         title = "Top 20 Best Selling Games by sales") +
    theme_minimal() +
    theme(axis.text = element_text(size = 10)) +
    theme(plot.title = element_text(size = 24)) +
    theme(axis.title = element_text(size = 20, face = "bold")) +
    scale_fill_manual(values = c("#ffa2a2", "#e70009"
    ))
  
  })
  
  
  output$eaTotalbox <- renderValueBox({
    valueBox(
       "EA Total Sales:", paste0(359.32, "$"), color = "fuchsia"
    )
  })
    
    output$ninTotalbox <- renderValueBox({
      valueBox(
        "Nintendo Total Sales:", paste0(528.31, "$"), color = "fuchsia"
      )  
    
  })
  
  
}

shinyApp(ui, server)
