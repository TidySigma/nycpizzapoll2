library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(jsonlite)
library(lubridate)
library(ggrepel)

source("getdata.R")


ui = dashboardPage(
  
  header = dashboardHeader(
    disable = TRUE
  ),
  sidebar = dashboardSidebar(
    disable = TRUE
  ),
  title = "PizzaFrame",
  
  body = dashboardBody(
    tags$head(tags$link(rel = "shortcut icon",
                        href = "images/favicon.ico")),
    box(
      title = "1. Introduction",
      closable = FALSE,
      width = 12,
      status = "primary",
      solidHeader = FALSE,
      collapsible = TRUE,
      HTML("I have attended New York Open Statistical Programming <a href='https://nyhackr.org/'>meetups</a>
            for a few years. I love <a href = 'https://www.jaredlander.com'>Jared Lander's</a>
            enthusiasm for pizza. Jared, the organizer, has been polling the attendees for many years.
            This Shiny Web App analyzes some of the trends in the Pizza Poll data.
               <br/>
               <br/>
             App developed by <a href='https://arhamchoudhury.com/'>Arham Choudhury</a>")
    ), # closes box 1
    box(
      title = "2. Interactive Chart",
      closable = FALSE,
      width = 12,
      status = "primary",
      solidHeader = FALSE,
      collapsible = TRUE,
      checkboxGroupInput(inputId = "select_order_count",
                         label = "Did NYhackr order from this place more than once?",
                         choices  = unique(pizza_frame_small$`Order Count`),
                         selected = unique(pizza_frame_small$`Order Count`)),
      sliderInput("Min_Vote_Filter", "Minimum Number of Total Votes",
                  min=min(pizza_frame_small$TotalVotes_by_Place),
                  max=40,
                  value=c(min(pizza_frame_small$TotalVotes_by_Place))),
      plotOutput("pizza_plot_1"),
      HTML("<b>Notes:</b> <br/>
           Interactive chart shows top 25 pizza places. There are 61 unique pizza places in the data.<br/>
           There are 15 places that have received multiple orders from NYhackr.
           Filter by <b>Order Count</b> to separate these two groups. 
           <br/>
           The median number of votes is 16. Due to large group events, 2 places have more than 40 votes. 
           Use to <b>slider</b> to filter by <b>vote count</b>.")
      
    ) # closes box 2
  ) # closes dashboardBody
) # dashboardPage ui

server = function(input, output) {
  pizza_frame_subset <- reactive({
    validate(
      need(input$Cylinder != "", 'Please choose at least one filter')
    )
    pizza_frame_small %>%
      filter(`Order Count` %in% input$select_order_count) %>%
      filter(TotalVotes_by_Place > input$Min_Vote_Filter)
  })

  output$pizza_plot_1 <- renderPlot({
    pizza_plot_1 <- pizza_frame_subset() %>%
      ungroup() %>%
      slice(1:25) %>%
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



shinyApp(ui = ui, server = server)
