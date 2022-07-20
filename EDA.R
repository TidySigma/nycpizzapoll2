# Q: are there any pizza places with zero votes?
check_data_0 <- pizza_0 %>% 
  filter(TotalVotes == 0)
check_data_0
# A: Only Bravo Pizza has zero votes

# histogram of votes
hist(pizza_0$TotalVotes)

# summary stats of votes
summary(pizza_0$TotalVotes)

# One pizza place has 67 votes!
check_data_1 <- pizza_0 %>% 
  filter(TotalVotes == 67)
check_data_1

unique(pizza_0$Answer)


# create numeric version of poll answers
check_data_2 <- pizza %>% 
  filter(Place == "Pizza Mercato" & pollq_id == 2)
check_data_2


# Q: What is the difference between the variables "polla_qid" and "pollq_id"
length(unique(pizza_0$polla_qid))
length(unique(pizza_0$pollq_id))
setequal(unique(pizza_0$polla_qid), unique(pizza_0$pollq_id))
# A: unknown

# Q: Why is are length of polla_qid and number of unique pizza places different?
length(unique(pizza_0$Place))
# A: a few pizza Places have multiple entries (polls in different times) 

# Look trough Places with repeat orders
check_data_3 <- pizza %>% 
  filter(Count_Place > 1)
check_data_3

check_data_3a <- pizza %>% 
  filter(Place == "Fiore's") %>% 
  select(Place, Time, TotalVotes, Percent, pollq_id)
check_data_3a

length(unique(check_data_3a$Time))
# Fiore's is quite popular!

# histogram of numeric answers
hist(pizza$Answer_Numeric)


# What is the Time variable. Messing around with as.Date and origin to see if I can make sense of it
check_data_4 <- pizza %>%
  filter(Place == "Fiore's") %>% 
  select(Place, Time, TotalVotes, Percent, pollq_id) %>% 
  #mutate(Time = as.Date(Time, origin="1970-01-01"))     # as.Date gives garbage info
  mutate(Time = as_datetime(Time, origin="1970-01-01"))  # as_datetime makes sense!
check_data_4

times <- pizza %>% 
  select(Time) %>% 
  arrange(Time)
times

check_data_4a <- pizza %>% 
  filter(TotalVotes > 30) %>% 
  select(Place, Answer, Time, pollq_id, Votes, TotalVotes, 
         Answer_Numeric, Answer_Numeric_Weighted, Count_Place,
         Percent)
check_data_4a


# the Time value for the event with the highest TotalVotes was on 2016-09-13 15:10:08
# Looking through the nyhackr website, the event on 2016-09-13

check_data_4b <- pizza %>% 
  select(Place, Answer, Time, pollq_id, Votes, TotalVotes, 
         Answer_Numeric, Answer_Numeric_Weighted, Count_Place,
         Percent) %>% 
  mutate(Date = as.Date(Time)) %>% 
  filter(Date %in% as.Date(c("2016-09-13", "2015-09-18", "2013-04-25")))
check_data_4b

# other dates featuring Hadley also have somewhat high TotalVote counts, so I think the 
# as_datetime transformation of the Time variable is correct


# examine the Percent variable with my Pizza_Poll_Score variable
check_data_5 <- Pizza_Score_by_Place %>% 
  select(Place, pollq_id, Answer, Votes, 
         Answer_Numeric, Count_Place, TotalVotes,
         Percent, Pizza_Poll_Score) %>% 
  # filter(Pizza_Poll_Score > 4.0) %>% 
  filter(Pizza_Poll_Score < 3.0)
head(check_data_5)
# looks reasonable

# keep local copies of data
write.csv(pizza_0, "pizza_0.csv")
write.csv(pizza, "pizza.csv")
write.csv(Pizza_Score_by_Place, "Pizza_Score_by_Place.csv")
# keep local copies of data



#Preview of pizza_plot_1


pizza_plot_1 <- ggplot(Pizza_Score_by_Place, 
                       aes(x=reorder(Place, Pizza_Poll_Score), y=Pizza_Poll_Score,
                           fill=Order_Type)) +
  geom_bar(stat='identity', color="#e1d800") +
  scale_fill_manual(values = c("#e12301", "#dba24a")) +
  coord_flip() +
  labs(title="Best Pizzas at nyhackr Meetups")
pizza_plot_1 



# end
