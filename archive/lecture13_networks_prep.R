library(readxl)
library(tidyverse)

friendship_data <- read_excel("network_deanonymized.xlsx", skip = 1)


fridata_long <- friendship_data %>% pivot_longer(cols = `1`:`50`,
                                 names_to = "name_num",
                                 values_to = "tietype")

#CHANGES ON THE RECORDING
roster <- friendship_data %>%
  select(`Response ID`, `What is your name?`) %>%
  drop_na() %>% rename(name_num = `What is your name?`) %>%
  mutate(name_num = as.character(name_num))

fridata_long2 <- fridata_long %>%
  inner_join(roster, by = "name_num") %>% 
  select(-name_num, -`What is your name?`) %>% 
  filter(!is.na(tietype)) %>% 
  separate(tietype, into = c("one", "two", "three", "four", "five"), sep = ",") %>% #seperate the column using commas as separators
  pivot_longer(cols = one:five,
               names_to = "col",
               values_to = "tie_type") %>% 
  filter(!is.na(tie_type)) %>% 
  select(-col) %>% 
  rename(Out_tie = `Response ID.x`,
         In_tie = `Response ID.y`,
         introvert = `Are you introverted or extraverted?`)

write_csv(fridata_long2, "edge_data.csv")




  