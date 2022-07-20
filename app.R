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
      selectizeInput("select_order_count", "Did NYhackr order from this place more than once?", 
                     choices  = unique(pizza_frame_small$`Order Count`),
                     selected = unique(pizza_frame_small$`Order Count`),
                     multiple = TRUE),
      sliderInput("Min_Vote_Filter", "Minimum Number of Total Votes", 
                  min=min(pizza_frame_small$TotalVotes_by_Place),
                  max=max(pizza_frame_small$TotalVotes_by_Place),
                  value=c(min(pizza_frame_small$TotalVotes_by_Place))),
      plotOutput("pizza_plot_1", height=600),
      width = 12
    )
  )
)

server <- function(input, output) {
  
  output$pizza_plot_1 <- renderPlot({
    pizza_plot_1 <- pizza_frame_small %>% 
      ungroup() %>% 
      slice(1:50) %>% 
      filter(`Order Count` %in% input$select_order_count) %>% 
      filter(TotalVotes_by_Place > input$Min_Vote_Filter) %>% 
      ggplot(aes(x=reorder(Place, Pizza_Poll_Score), 
                 y=Pizza_Poll_Score,
                 fill=`Order Count`,
                 label = Pizza_Poll_Score)) +
      geom_bar(stat='identity') +
      scale_fill_manual(values = c("#e12301", "#dba24a")) +
      coord_flip() +
      labs(title="Best Pizzas at NYhackr Meetups",
           x = "",
           y = "Score",
           caption = "Data from www.jaredlander.com") +
      theme_minimal() +
      geom_text(size=3) +
      theme(plot.caption = element_text(size=8, hjust=1))
    pizza_plot_1
  })
}

shinyApp(ui=ui, server=server)
