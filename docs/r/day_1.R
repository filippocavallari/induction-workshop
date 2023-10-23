# Intro -  What is R?

#' R is open source, created by Ross Ihaka & Robert Gentleman at the University of Auckland, New Zealand. 
#' Developed with statistical computing and graphics in mind.
#' Popular choice, ranked 7th on the Popularity of Programming Language Index (PYPL) in 2023.
#' Has a few quirks, could trip up experienced programmers.


# Intro - What is R Studio?

#' R runs computations, R Studio is an Integrated Development Environment (IDE).
#' Provides interface with convenient features and tools for workflows and software development.
#' You can use R without it, but is the recommendation implementation, built from the ground up with R in mind, constantly supported and updated by the budding community. 


# 00 - Tweaking global settings ----

#' Let's use R's excellent global options and accessibility features!
#' GENERAL - Untick Workspace and History boxes.
#' CODE/EDITING - Tick native pipe operator, soft wrap source files.
#' CODE/DISPLAY - Tick scroll past end of doc, highlight R function calls, rainbow parentheses.
#' Appearance - Font size 14, help size 12, Vibrant Ink theme


# 01 - First operations with R ----

# 01a - Console Pane ----

#' Bottom left is the Console, where we can type code and get immediate response 
#' Use as calculator - 2 + 2
#' Complete - 2 + 2 + 
#' No way to save code, quick checking

# 01b - Code Editor Pane ----

#' Write majority of code here in scripts, text file with code and comments (.R)
#' CTRL + SHIFT + N to open new script "Untitled1".
#' Could write 2 + 2 but not saving anything to memory.

#' Storing something in a variable using the assignment operator ALT + -
a <- 1
b <- 2

# Note existence in Environment Pane - more on data types in course notes

# Print both
cat(a, b)

# Storing the result of an operation in a variable
sum <- a + b

# we don't need these variables, let's tidy our memory
rm(a, b, sum)



# 02 - load packages ----

#' R is capable out of the box (BASE) but packages transform it.
#' Packages are libraries of code adding new functionality and streamlining quirks in the source code. 
#' This has led to the development of some of the worlds most popular graphic, website, dashboarding and data science tools.


#' Install necessary packages in the console (don't do this in the script!)
#' install.packages("tidyverse")

#' Tidyverse is actually a meta-package: it contains many "proper" packages
#' designed to make data analysis easy. Each package is specialized on one topic.
#' The main job of tidyverse is to load all the 9 core packages all in one go.

# Load package into the session using library function
library(tidyverse)

# install.packages("janitor")
library(janitor)




# 03 - Read Data ----

#' Note that when done locally (with R Studio native) you should review Chapter 3 of the notes. Creating a project is always recommended to streamline filepaths.

#' If using posit cloud this must be done using the GUI from the files tab.
#' Create new folder "data", recommended to structure files this way
#' Upload data file to the server in the data folder
ames <- read_csv(file = "data/ames.csv")

#' Data dictionary can be found at
#' https://jse.amstat.org/v19n3/decock/DataDocumentation.txt




# 04 - First look at the data ----

# Number of rows and columns
# We use functions, which are like black boxes that take inputs, do something to them (such as calculate information about the data) and return an output.
nrow(ames)
ncol(ames)
dim(ames) 

# This has returned a vector of integers, a collection of values of all the same datatype. More on this in Chapter 2 of the notes. 


# First lines of the dataset (default is 6)
head(ames)
head(ames, 10) 

# We used an extra input (argument) here, to tweak the behaviour of the function and by extension the resulting output. 


# Last lines of the dataset (default is 6)
tail(ames)
tail(ames, 10)


# To see the whole dataset in a spreadsheet form use view()
view(ames)


# Useful overview of the dataset is provided by glimpse()
glimpse(ames)





# 05 - Using the pipe operator ----

#' The above functions can be used also with a somewhat different syntax:
#' f(x) is the same as x |> f()
#' f(x, y) is the same as x |> f(y)
#' the shortcut for the pipe operator is CTRL + SHIFT + M


# First lines of the dataset (default is 6)
ames |> head()
ames |> head(10)

# Last lines of the dataset (default is 6)
ames |> tail()
ames |> tail(10)

# To see the whole dataset in a spreadsheet form use view()
ames |> view()

# Useful overview of the dataset is provided by glimpse()
ames |> glimpse()

#' This doesn't look an advantage at the moment but we will see that is very
#' convenient when we compose many functions together!





# 06 - Rename columns ----

#' Generally, we want columns to be "tidy", i.e. contain no spaces (underscores instead) and all lowercase. We can utilise dplyr's manipulation tools for this. 
#' From here, all functions are from the dplyr package, our data manipulation library in the tidyverse. 
ames |> 
  rename(sale_price = SalePrice)

# We can use glimpse after rename, to check whether rename() made a change
ames |> 
  rename(sale_price = SalePrice) |> 
  glimpse()

# What would this look like without the pipe operator?

glimpse(rename(ames, sale_price = SalePrice))

# Keeping track of brackets can become unmanageable as more functions are composed together.

# we can rename more than one column
ames |> 
  rename(ground_living_area = `Gr Liv Area`,
         sale_price         = SalePrice) |> 
  glimpse()

#' Observe that we haven't saved our changes to the names of the columns
#' (we will address this problem later)

#' We can use clean_name() from janitor package to avoid manually renaming
#' all the columns
ames |> 
  clean_names() |> 
  glimpse()

# Finally we may want to save our changes by overwriting our ames variable (CAREFUL!)
ames <- ames |> clean_names()





# 07 - Select specific variable (subset by columns) ----

# Here we introduce dplyr verb's, the grammar of data manipulation in the tidyverse.

# Select a single column
ames |> 
  select(sale_price)

# Select multiple columns
ames |> 
  select(gr_liv_area, year_built, sale_price)

# Select all columns but one
ames |> 
  select(-sale_price) |> 
  glimpse() # to see better what happened

# Selection helpers - allow for more detailed searching. 

# starts_with()
ames |> 
    select(starts_with("garage"))

# ends_with()
ames |> 
    select(ends_with("qual"))

# contains()
ames |> 
  select(contains("condition"))





# 08 - Subsetting by row (based on index) ----

# Select one specific row
ames |> 
  slice(653)

# Select many specific rows
ames |> 
  slice(12, 653, 1201)

# Select many consecutive rows
ames |> 
  slice(116:123)





# 09 - Subsetting by row (based on conditions) ----

# One condition
ames |> 
  filter(yr_sold == 2010)

# Two conditions
ames |> 
  filter(yr_sold == 2010 & sale_price < 1e5)

# Numerical variables can be upper and lower bounded at the same time
ames |> 
  filter(between(sale_price, 1.5e5, 3e5))

# Categorical variables can assume more values
ames |> 
  filter(neighborhood %in% c("Greens", "GrnHill", "Landmrk"))





# 10 - Sorting ----

# Sorting by one column
ames |> 
  arrange(sale_price) |> 
  select(order, sale_price) # to focus the output just on one column

# Descending sort
ames |> 
  arrange(desc(sale_price)) |> 
  select(order, sale_price)

# Sort by more columns
ames |> 
  arrange(neighborhood, sale_price) |> 
  select(order, neighborhood, sale_price)





# 11 - Add new columns

ames |> 
  select(gr_liv_area, sale_price) |> 
  mutate(price_over_sqft = sale_price / gr_liv_area)





# 12 - List unique values for a categorical variable ----
ames |> 
  distinct(neighborhood)





# 13 - Count values for a categorical variable ----
ames |> 
  count(neighborhood)

# By default the column containing the count is named n, however we can change it if we want
ames |> 
  count(neighborhood, name = "count")

# There are two ways to view the full list
# a) In the console (need to know how many lines to print in advance)
ames |> 
  count(neighborhood, name = "count") |> 
  print(n = 28)

# b) In a new tab using a spreadsheet form
ames |> 
  count(neighborhood, name = "count") |> 
  view()




# 14 - Quick Visualisations with ggplot2

#' You will learn about the grammar of graphics with ggplot2 in the Data Visualisation module, as such we will keep it at a high level for now. 

# 14(a) - Observations by neighbourhood (bar plot) ----
ames |> 
  ggplot(mapping = aes(y = neighborhood)) +
  geom_bar()


# 14(b) - Sale_price by ground_living_area (scatter plot) ----
ames |> 
  ggplot(mapping = aes(x = gr_liv_area, y = sale_price)) +
  geom_point()
