#filter(TotalVotes_by_Place > input$Min_Vote_Filter) %>%

Pizza_Score_Multiple_Orders <- pizza %>% 
  group_by(Place, pollq_id) %>% 
  mutate(TotalVotes_by_Place = sum(TotalVotes)/5) %>% 
  mutate(Pizza_Poll_Score = sum(Answer_Numeric_Weighted)/TotalVotes_by_Place) %>% 
  select(Place, pollq_id, Count_Place, TotalVotes_by_Place,
         Pizza_Poll_Score) %>%
  ungroup() %>% 
  unique() %>% 
  arrange(desc(Pizza_Poll_Score)) %>% 
  na.omit()
head(Pizza_Score_Multiple_Orders)



ggsave(plot = pizza_plot_top10, height = 2, width = 5,
       units = "in", filename = "pizzapoll.jpg", dpi=400)


# end