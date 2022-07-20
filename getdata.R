## for Submission to RStudio Shiny contest
## data from: https://www.jaredlander.com/data/PizzaPollData.php


library(tidyverse)
library(jsonlite)
library(lubridate)

data_source <- "https://www.jaredlander.com/data/PizzaPollData.php"


pizza_0 <- jsonlite::fromJSON(data_source)
pizza_0



pizza <- pizza_0 %>% 
  mutate(Answer_Numeric = case_when(Answer == "Excellent"    ~ 5,
                                    Answer == "Good"         ~ 4,
                                    Answer == "Average"      ~ 3,
                                    Answer == "Poor"         ~ 2,
                                    Answer == "Never Again"  ~ 1,
                                    TRUE                     ~ NA_real_)) %>% 
  mutate(Answer_Numeric_Weighted = Answer_Numeric * Votes) %>% 
  add_count(Place, name="Count_Place") %>% 
  mutate(Count_Place = Count_Place/5) %>% 
  mutate(Time = as_datetime(Time, origin="1970-01-01"))
head(pizza)


Pizza_Score_by_Place <- pizza %>% 
  group_by(Place) %>% 
  mutate(TotalVotes_by_Place = sum(TotalVotes)/5) %>% 
  mutate(Pizza_Poll_Score = sum(Answer_Numeric_Weighted)/TotalVotes_by_Place) %>% 
  select(Place, Count_Place, TotalVotes_by_Place,
         Pizza_Poll_Score) %>%
  ungroup() %>% 
  unique() %>% 
  arrange(desc(Pizza_Poll_Score)) %>% 
  na.omit() %>% 
  mutate(Order_Type = case_when(Count_Place > 1 ~ "More than once",
                                TRUE            ~  "Once"))
head(Pizza_Score_by_Place)

#Pizza_Score_by_Place_plt <- ggplotly()


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





# end