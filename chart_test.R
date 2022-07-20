pizza_plot_top10 <- pizza_frame_small %>% 
  ungroup() %>% 
  slice(1:10) %>% 
  filter(`Order Count` %in% c("Once", "More than once")) %>% 
  ggplot(aes(x=reorder(Place, Pizza_Poll_Score), 
             y=Pizza_Poll_Score,
             fill=`Order Count`,
             label = Pizza_Poll_Score)) +
  geom_bar(stat='identity') +
  scale_fill_manual(values = c("#e12301", "#dba24a")) +
  coord_flip() +
  labs(title="Top 10 Pizzas at NYhackr Meetups",
       x = "",
       y = "Score",
       caption = "Data from www.jaredlander.com") +
  theme_minimal() +
  geom_text(size=3) +
  theme(plot.caption = element_text(size=8, hjust=1))
pizza_plot_top10


pizza_plot_1 <- pizza_frame_small %>% 
  ungroup() %>% 
  slice(1:10) %>% 
  filter(`Order Count` %in% c("Once", "More than once")) %>% 
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
