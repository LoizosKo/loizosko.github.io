################################################################################
################################################################################
#############                    Lecture 02                        #############
################################################################################
################################################################################

# I can write comments by using the pounds sign before the comment

# R has a lot of in-built functions, but even more functions that are 
# user-contributed. User-written commands can be loaded in this way

# In its basic form, R is a glorified calculator
2 + 2
2 - 2
2 * 2
2 / 2

# R will "complain" if you run certain calculations, but these are not R errors,
# just "complaints
2/0
0/0 #Not A Number

class(2) #asking what class number 2 is.

# In some cases R will complain using a "+" sign, this means it believe
# you haven't finished typing what it has to say

2/ #error
  
  # a + sign indicates that you started an operation and R expects additional 
  # input. If you think it's an error you can always press the "escape key" or
  # finish typing the statement.
  2


# Some evaluations in R will result in errors

2/two

2/"two"

# R Really doesn't like errors. All errors interrupt the flow of code.

# R allows you to store information inside objects
one <- "One"
two <- 2  # single value

2/two#now it works

three <- c(23, 45, 32, 76, 87) # vector. If you are working with datasets, and oneo of the datasets is "age", you can create an "age" vector that would contain all the ages of the participants

language <- c("Russian", "Mandarin", "Cantonese", "French")#vector that stores the languages spoken at home.

age <- c(1, 2, 3,34,23,43,34,3,1,13,41,45, 24,72,24,37,53, 13,52, 34, 26, 16,13,46,36,27,46)
age

four <- c("One", "Two", "Three")
five <- c(TRUE, FALSE, TRUE)

# Vectors can store as many values as you want, but only of the same type

(six <- c(1, 2, "three"))


(vector <- c (1+4, 3-2, 3+5))#vector wouldn't have worked if parenthesis was missing.
#vectors can only have one class in their data

# Everything in R is built upon vectors
# An excel table in R is conceptualized as a data.frame - a list of vectors.
data.frame(a = c(1,2,3),
           b = c("a", "b", "c"),
           c = c(TRUE, TRUE, FALSE))

# We will use tibbles in this course. They behave similarly, 
# but offer some advantages.

tibble(a = c(1,2,3),
       b = c("a", "b", "c"),
       c = c(TRUE, TRUE, FALSE))

language <- c("English", "Spanish", "Portugese", "English")#observations for person 1, person 2, person 3, person 4
english <- c(TRUE, FALSE, FALSE, TRUE)
spanish <- c(FALSE, TRUE, FALSE, FALSE)

#data.frame = a bunch of vectors
data.frame(id=c(1,2,3),
           name = c("Lelo", "Forest", "Ro"),
           color = c("beige", "olive", "bw"))
#there are three vectors in this dataframe

#"First name": spaces are not allowed
#"23s"

#Tibble is a user written function where we need to install it

# R is expandable by functions other users wrote, so we will use a few of those
# throughout the class

# If you are a first time user you might need to install them first.
# install.packages("tidyverse")
# install.packages("readr")

install.packages("tidyverse")
install.packages(readr)
install.packages(lubridate)
install.packages("broom")
install.packages("tibble")
library(tidyverse) #used for data handling
library(readr)
library(lubridate)
library(broom)
library(tibble)

#WEEK 2 6:50 PM
tibble(id=c(1,2,3,4),
       name=c("Lelo", "Forest", "Ro", "Lo"),
       color=c("beige", "olive", "bw", "orange"))
#the benefits of tibbles is that they allows to create datasets that are way messier. It could help us for qualtrics.


# Let's load some real data from Google Trends

#7.08PM
kardashians <- read_csv("multiTimeline.csv", skip = 1)

#we import the kim kardashian dataset.
library(readr)
multitime <- read_csv("~/Desktop/516 directory/multiTimeline.csv", 
                      skip = 1)
View(multitime)  


#we need to remove space in the title from kim_kardashian. We also need to remove the two dots, and the capital letters make them small.

str(multitime)
glimpse(multitime)


kardashians[1,]
kardashians[,1]
kardashians[,c(1,3,5)]

multitime %>%
  filter(Month == "2004-01")

multitime %>%
  select(Month,
         `Khloé Kardashian: (Worldwide)`, 
         `Kendall Jenner: (Worldwide)`)

# We can see a few problems and work on fixing them
#we create kard2 dataset in order to rename the titles of the multitime dataset.
kard2 <- multitime %>%
  rename(month = Month,
         kim = `Kim Kardashian: (Worldwide)`,
         khloe = `Khloé Kardashian: (Worldwide)`,
         kourtney = `Kourtney Kardashian: (Worldwide)`,
         kendall = `Kendall Jenner: (Worldwide)`,
         kylie = `Kylie Jenner: (Worldwide)`)

kard2

# We can also use the following shortcut
colnames(multitime) <- c("month", "kim", "khloe", "kourtney", "kendall", "kylie")


kard3 <- kard2 %>%
  mutate(khloe = str_replace(khloe, "<", ""),
         kourtney = str_replace(kourtney, "<", ""),
         kendall = str_replace(kendall, "<", ""),
         kylie = str_replace(kylie, "<", "")) %>% 
  mutate(khloe = as.numeric(khloe),
         kourtney = as.numeric(kourtney),
         kendall = as.numeric(kendall),
         kylie = as.numeric(kylie))

kard3 

# Here is a shortcut
#I am replacing "<" with an empty string. Which means that whenever there is a symbol, it is replaced with a blank space.
#7.30PM
kard2 %>% 
  mutate_if(is.character, str_replace, pattern = "<", replacement = "") %>% 
  mutate_at(c("khloe", "kourtney", "kendall", "kylie"), as.numeric)

#7.45PM
kard2 %>% 
  mutate_if(is.character, str_replace, pattern = "<1", replacement = "0.5") %>% 
  mutate_at(c("khloe", "kourtney", "kendall", "kylie"), as.numeric)

#7.50
#I am making sure that the results are no longer characters...
kard2 %>% 
  separate(month, into = c("year", "month"), 
           sep = "-", 
           convert = TRUE) %>% 
#Who was the most popular in 2017?
  #----- we filter for the year. And then we use summarise to calculate the average of each one
filter(year==2017) %>% 
  summarise(kim= mean(kim),
            khloe= mean(khloe),
            kourtney= mean(kourtney),
            kendall= mean(kendall),
            kylie= mean(kylie))

#if our variable is a character variable, then make that replacement.
multitime %>% 
  mutate_if(is.character, str_replace, pattern = "<1", replacement = "0.5") %>% 
  mutate_if(is.character, as.numeric)

# Now we need to fix the month column

kard4 <- kard3 %>% 
  separate(month, into = c("year", "month"), sep = "-", convert = TRUE) %>%
  mutate(day = 15, .after = month) %>%
  mutate(date = ymd(paste(year, month, day, sep="-")))

kard4

# We can now filter data

kard4 %>%
  filter(year == 2020)

# We can also calculate the averages for the year

kard4 %>%
  filter(year == 2020) %>% 
  summarize(kim = mean(kim),
            khloe = mean(khloe),
            kourtney = mean(kourtney),
            kendall = mean(kendall),
            kylie = mean(kylie))



# Or using the following shortcut 
kard4 %>%
  filter(year == 2020) %>% 
  summarize_at(c("kim", "khloe", "kourtney", "kendall", "kylie"), mean)

#  We can repear the process for another year
kard4 %>%
  filter(year == 2018) %>% 
  summarize_at(c("kim", "khloe", "kourtney", "kendall", "kylie"), mean)

# it might be tedious to repeat it for all the years so we can apply 
# a shortcut one more time

#purpose of group_by is to calculate all years in one table. GroupBy treats our tables as a bunch of separate tables
#group_by groups rows.
kard5 <- kard4 %>% 
  group_by(year) %>% 
  summarize_at(c("kim", "khloe", "kourtney", "kendall", "kylie"), mean)

kard5

# When was Kim the most popular?

kard5 %>% arrange(kim)
kard5 %>% arrange(-kim)
kard5 %>% top_n(1, kim)

# When was Kylie the most popular?
kard5 %>% top_n(1, kylie)


# Who is more popular? The Kardashians or the Jenners?
#transmute always keeps what is inside transmute and nothing else
kard5 %>% 
  transmute(year,
            kardashians = (kim + khloe + kourtney)/3,
            jenners = (kendall + kylie)/2)

# We will learn this later on, but let's make a quick graph

ggplot(kard5,
       aes(x = year,
           y = kim)) +
  geom_line()

plot(kard5$year, kard5$kim, type = "l")

# What if we want to visualize all 5 of them?
# The data are in the wrong format

kard6 <- kard5 %>%
  pivot_longer(cols = -year,
               names_to = "name",
               values_to = "score")

kard6

ggplot(kard6,
       aes(x = year,
           y = score,
           color = name)) +
  geom_line()


# What can explain the rise of Kylie to popularity?
# As a very raw model let's look at the following

kard4 %>%
  mutate(business = date >= as_date("2015-12-01")) %>% 
  lm(kylie ~ business, data = .) %>%
  summary()

kard4 %>%
  mutate(business = date >= as_date("2015-12-01")) %>% 
  lm(kylie ~ business, data = .) %>%
  tidy()

kard4 %>%
  mutate(business = date >= as_date("2015-12-01")) %>% 
  lm(kylie ~ business, data = .) %>%
  glance()

kard4 %>%
  mutate(business = date >= as_date("2015-12-01")) %>% 
  lm(kim ~ business, data = .) %>%
  summary()

