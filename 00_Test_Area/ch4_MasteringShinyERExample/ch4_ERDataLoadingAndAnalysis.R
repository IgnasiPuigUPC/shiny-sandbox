#
# Mastering Shiny book
# Chapter 4
# ER Example
#

# libraries

library(shiny)
library(vroom)
library(tidyverse)

# loading data

dir.create("00_Test_Area/ch4_MasteringShinyERExample/neiss")
#> Warning in dir.create("neiss"): 'neiss' already exists
download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/neiss/"
  download.file(paste0(url, name), paste0("00_Test_Area/ch4_MasteringShinyERExample/neiss/", name), 
                quiet = FALSE)
}
download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")

# reading data

injuries <- vroom::vroom("00_Test_Area/ch4_MasteringShinyERExample/neiss/injuries.tsv.gz")
injuries

products <- vroom::vroom("00_Test_Area/ch4_MasteringShinyERExample/neiss/products.tsv")
products

population <- vroom::vroom("00_Test_Area/ch4_MasteringShinyERExample/neiss/population.tsv")
population

# exploratory data analysis

# assess no. of accidents involving toilets
selected <- injuries %>% filter(prod_code == 649)
nrow(selected)

# identify type of accidents
selected %>% count(location, wt = weight, sort = TRUE)
selected %>% count(body_part, wt = weight, sort = TRUE)
selected %>% count(diag, wt = weight, sort = TRUE)

# plot by age and gender
summary <- selected %>% 
  count(age, sex, wt = weight)
summary
summary %>% 
  ggplot(aes(age, n, colour = sex)) + 
  geom_line() + 
  labs(y = "Estimated number of injuries")

# normalize by no. of people at a given gendre + age
summary <- selected %>% 
  count(age, sex, wt = weight) %>% 
  left_join(population, by = c("age", "sex")) %>% 
  mutate(rate = n / population * 1e4)
summary
summary %>% 
  ggplot(aes(age, rate, colour = sex)) + 
  geom_line(na.rm = TRUE) + 
  labs(y = "Injuries per 10,000 people")

# see some random narratives
selected %>% 
  sample_n(10) %>% 
  pull(narrative)

prod_codes <- setNames(products$prod_code, products$title)
prod_codes

# function to show top 5 events and the remaining in others

top <- selected %>% count(diag, wt = weight, sort = TRUE)
numGrup <- 5
top <- rbind(top[1:numGrup,],
             c('Others', sum(top$n[(numGrup+1):nrow(top)])))
top

topSumm <- function(data2cut, numGrup = 5) {
  return(rbind(data2cut[1:numGrup,],
               c('Others', sum(data2cut$n[(numGrup+1):nrow(data2cut)]))))
}
topSumm(selected %>% count(diag, wt = weight, sort = TRUE))
