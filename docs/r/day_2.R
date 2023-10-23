library(tidyverse)
library(janitor)

ames <- read_csv(file = "data/ames.csv") |> clean_names()

# let's have a look at some numerical summaries for the sale price
ames |> 
  summarise(price_min    = min(sale_price),
            price_Q1     = quantile(sale_price, probs = 0.25),
            price_mean   = mean(sale_price),
            price_median = median(sale_price),
            price_Q3     = quantile(sale_price, probs = 0.75),
            price_max    = max(sale_price),
            price_std    = sd(sale_price),
            price_IQR    = IQR(sale_price))

glimpse(ames)

ames |> 
  summarise(min    = min(garage_area, na.rm = TRUE),
            Q1     = quantile(garage_area, probs = 0.25, na.rm = TRUE),
            mean   = mean(garage_area, na.rm = TRUE),
            median = median(garage_area, na.rm = TRUE),
            Q3     = quantile(garage_area, probs = 0.75, na.rm = TRUE),
            max    = max(garage_area, na.rm = TRUE),
            std    = sd(garage_area, na.rm = TRUE),
            IQR    = IQR(garage_area, na.rm = TRUE))

mean(c(11, NA, 24, 55), na.rm = TRUE)

test <- c(11, NA, 24, 55, NA)

is.na(test)

sum(is.na(test))

ames |> 
  summarise(NAs = sum(is.na(garage_area))) # one missing value!

ames |> 
  count(garage_cars)

ames |> 
  count(garage_finish)

# check whether missing values happen where there is no garage
# the intuition is the no garage means no cars
ames |> 
  filter(garage_cars == 0 | is.na(garage_cars)) |> 
  select(contains("garage"))


ames |> 
  filter(is.na(garage_cars)) |> 
  select(contains("garage"))


ames |> 
  filter(garage_cars > 0 & is.na(garage_finish)) |> 
  select(contains("garage"))

# let's say that i want to count the missing values for each variable
is.na(ames) |> view()

colSums(is.na(ames))

ames |> 
  summarise(
    sum(is.na(order)),
    sum(is.na(ms_sub_class)),
    sum(is.na(ms_zoning))
  )

ames |> map_int(~sum(is.na(.))) # using functional programming


# recoding and imputing variables
ames |> 
  count(garage_finish)

# Fin	Finished
# RFn	Rough Finished	
# Unf	Unfinished
# NA	No Garage

# impute NAs
ames |> 
  mutate(garage_finish = replace_na(garage_finish, "No Garage")) |> 
  count(garage_finish)

# refactor variables
ames |> 
  mutate(garage_finish = case_match(garage_finish,
                                    "Fin" ~	"Finished",
                                    "RFn" ~	"Rough Finished",
                                    "Unf" ~	"Unfinished",
                                    NA    ~ "No Garage")) |> 
  count(garage_finish)


# last thing for today
# plot the mean price by neighbourhood
ames |> 
  group_by(neighborhood) |> 
  summarise(mean_price = mean(sale_price)) |> 
  ggplot(mapping = aes(x = mean_price, y = neighborhood)) +
  geom_bar(stat = "identity")
