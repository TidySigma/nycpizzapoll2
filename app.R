## data from: https://www.jaredlander.com/data/PizzaPollData.php

## global ------------------
library(shiny)
library(shinydashboard)
library(plotly)
source("getdata.R")
## global ------------------

## app.R ----------
ui <- dashboardPage(
  dashboardHeader(title = "Pizza Polls"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Charts", tabName = "Charts", icon = icon("dashboard")),
      menuItem("About",  tabName = "About",  icon = icon("th"))
    )
  ),
  dashboardBody(
    
    fluidRow(
      
      
      title = "Best Pizzas",
      selectizeInput("select_order_type", "Did NYhackr order from this place more than once?", 
                     choices  = unique(Pizza_Score_by_Place$Order_Type),
                     selected = unique(Pizza_Score_by_Place$Order_Type),
                     multiple = TRUE),
      sliderInput("Min_Vote_Filter", "Min Number of Total Votes", 
                  min=min(Pizza_Score_by_Place$TotalVotes_by_Place),
                  max=max(Pizza_Score_by_Place$TotalVotes_by_Place),
                  value=2),
      plotlyOutput("pizza_plot_1", height=600),
      width = 12
    )
  )
)

server <- function(input, output) {
  
  output$pizza_plot_1 <- renderPlotly({
    pizza_plot_1 <- Pizza_Score_by_Place %>% 
      filter(Order_Type %in% input$select_order_type) %>% 
      filter(TotalVotes_by_Place > input$Min_Vote_Filter) %>% 
      ggplot(aes(x=reorder(Place, Pizza_Poll_Score), y=Pizza_Poll_Score,
                 fill=Order_Type)) +
      geom_bar(stat='identity') +
      scale_fill_manual(values = c("#e12301", "#dba24a")) +
      coord_flip() +
      labs(title="Best Pizzas at NYhackr Meetups",
           x = "Pizza Place",
           y = "Pizza Poll Score") +
      theme_bw() 
    pizza_plot_1
  })
}

shinyApp(ui=ui, server=server)
