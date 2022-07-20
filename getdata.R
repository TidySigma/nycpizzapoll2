## for Submission to RStudio Shiny contest
## data from: https://www.jaredlander.com/data/PizzaPollData.php


library(tidyverse)
library(jsonlite)
library(lubridate)
library(ggrepel)

data_source <- "https://www.jaredlander.com/data/PizzaPollData.php"

pizza_0 <- jsonlite::fromJSON(data_source)
pizza_0

pizza_frame <- pizza_0 %>% 
  mutate(Answer_Numeric = case_when(Answer == "Excellent"    ~ 5,
                                    Answer == "Good"         ~ 4,
                                    Answer == "Average"      ~ 3,
                                    Answer == "Poor"         ~ 2,
                                    Answer == "Never Again"  ~ 1,
                                    TRUE                     ~ NA_real_)) %>% 
  mutate(Answer_Numeric_Weighted = Answer_Numeric * Votes) %>% 
  add_count(Place, name="Number_of_Orders") %>% 
  mutate(Count_Orders = Number_of_Orders/5) %>% 
  mutate(Time = as_datetime(Time, origin="1970-01-01")) %>% 
  group_by(Place) %>% 
  mutate(TotalVotes_by_Place = sum(TotalVotes)/5) %>% 
  mutate(Pizza_Poll_Score = sum(Answer_Numeric_Weighted)/TotalVotes_by_Place) %>% 
  mutate(Pizza_Poll_Score = round(Pizza_Poll_Score, 1)) %>% 
  ungroup() %>% 
  arrange(desc(Pizza_Poll_Score)) 
head(pizza_frame)

pizza_frame_small <- pizza_frame %>% 
  select(Time, Place, Count_Orders, TotalVotes_by_Place,
         Pizza_Poll_Score) %>% 
  ungroup() %>% 
  group_by(Place) %>% 
  slice(1) %>% 
  ungroup() %>% 
  arrange(desc(Pizza_Poll_Score)) %>% 
  mutate(`Order Count` = case_when(Count_Orders > 1 ~ "More than once",
                                TRUE            ~  "Once")) %>% 
  na.omit()
head(pizza_frame_small)

