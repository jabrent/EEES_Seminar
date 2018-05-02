#### Data Manipulatin ####
# Created by JAB March 2018 for EEES Seminar
# Available on github class respository: https://github.com/jabrent/EEES_Seminar

# Load Libraries ####
install.packages("tidyverse") #Only need to install packages once but need to load the library every time you start a new R session
library(tidyverse)
tidyverse_packages()

library(lubridate)
library(hms)

# Basic functions ####
str()
head()
tail()
length()
seq() #make a sequence
c() #concatenate
summary()
sum()
mean()
na.rm()
?par #old possible base plot commands

# option/alt + shift + K = View all keyboard shortcuts
# key board shorcut for assignment ( <- ) =  option/alt & - (minus sign) 
# key board shortcut for pipe ( %>% ) = command & shift & m

# Data Import - tibble & readr ####
#Tibbles
as_tibble(iris) #Iris is dataset that loads with tidyverse
class(iris)
str(iris) #see structure of data frame to see how it is read in and how data are treated
head(iris) #First 6 rows of data
tail(iris) #Last 6 rows of data

#Create your own tibble
(df <- tibble(x = 1:5,
              y = 1,
              z = x^2 + y))
str(df)

#choose variables in df
df$y
df[["x"]]

#Tribble = transposed tibble
ex_tribble <- tribble( ~x, ~y, ~z,
                       #--/--/----
                       "a", 2, 3.6,
                       "b", 1, 8.5
)


str(ex_tribble)

#Old way to create data frame
df2 <- data.frame(x = c("a","b"), y = c(2, NA), z = c(3.6, 8.5))

df1 <- data.frame("Species"=c("bird","fish","mammal"), "Weight" = c(25,35,105),            "Height"=c(12,24,56))
str(df2)

# Reading in data - readr package ####

#read_csv() #comma delimited
#read_tsv() #tab delimited
#read_delim() #any type of delimter

#Useful commands when reading in data:
skip #useful for skipping lines if first few lines in spreadsheet are not data
col_names #specify if columns already have header or specific names
col_types #set specific type of data for columns when reading in data
parse_*() #take character vector and return more specialized vector - i.e. logical, integer, date, used after data already read in
problems(dataframe) #check for issues when reading in data

# Load example dataset
#If working in a R Project the working directory will automatically be set to the folder you make and you can specify other folders within that folder for instance the folder Data in this example.

# Read in data from Data folder in R project
Crystal <- read_csv("Data/Crystal_2014_wtrtemp.csv") 

str(Crystal)
class(Crystal)
as.tibble(Crystal)

# comapre to old method with read.csv to compare how datetime read in
Crystal_old <- read.csv("Data/Crystal_2014_wtrtemp.csv") #old method
str(Crystal_old) #look at how datetime is read in

#Specifications in read_csv
#skip # of lines, comment = #, col_names = F or vector c("x","y"), na = "."
Crystal_test <- read_csv("Data/Crystal_2014_wtrtemp.csv", skip=2, col_names = F)

# Example of NA specification
read_csv("a,b,c\n 1,2,.", na = ".") # the \n stands for a new line

# Example of reading in data with issues - readr uses 1st 1000 rows to guess format of data but can change that with command guess_max if format will be clear after 1000 row
challenge <- read_csv(readr_example("challenge.csv"))
str(challenge)
problems(challenge)

# This wil read data in the same way but specifies columns so can change
challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(
                              x = col_integer(),
                              y = col_character()
                      ))

# X column has integers and missing values so change to double and Y column has missing data and data as a date so specify here
challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(
                              x = col_double(),
                              y = col_date()
                      ))

# or with changing guess_max
challenge <- read_csv(readr_example("challenge.csv"),
                      guess_max = 1001)

# Parsing Examples - takes character vector & returns more specialized vector (i.e. logical, integer, date)

parse_integer(c(222,222.2)) #will fail because only one number is an integer
parse_double(c(222,222.2)) #correct format

#Parse number command could be used to remove dollar signs or percent symbols so it wouldn't read it in as a character
parse_number(c("$100", "30%")) #flexible numeric

#Example of parse factor if spelling issues in dataset
#Set the correct factor levels

fruit <- c("apple", "banana")

parse_factor(c("apple","banana","bananna"), levels = fruit) # will show problem for misspelled banana

# Example of parsing date time - specify format datetime in for original file when reading in and will convert to ISO standard yyyy-mmm-dd hh:mm:ss which translates to "%Y-%m-%d %H:%M:%S"
parse_datetime("01/02/03 23:10:02", "%m/%d/%y %H:%M:%S") #specify format date in not what you want it to be

# Old way
datetime <-as.POSIXct(strptime("2003-01-02 23:10:02", "%Y-%m-%d %H:%M:%S", tz = "EST")) 

# Date & Time - lubridate & hms package ####

#Example of lubridate functions
now() #shows current system date and time
ymd_hms() # shows type of data
ymd(20180323) # converts to ISO standard date format, again specify format data currently in and will convert to ISO standard
mdy("1/1/16")
make_datetime()
as_date() #sets variable to date in ISO standard format

# Rounding date functions
floor_date #round down
ceiling_date #round up
round_date

# specify time formats using hms package (lubridate doesn't have a function to keep the time components together - can separate hours, minutes, and seconds but not time from datetime)
as.hms("3:14")
parse_time("3:14:30 pm") #if have characters like am or or pm, use parse instead and will c convert to military time

#See all time zones - 589 total
OlsonNames()

#Separate date and time
Crystal$date <- as_date(Crystal$datetime) #Adds column with just date to crystal dataset
Crystal$time <- as.hms(Crystal$datetime,tz="UTC") #use UTC for GMT Time zone
head(Crystal)

# Example of separating datetime into components with dplyr function mutate and lubridate and hms - will introduce the pipe later
Crystal <- read_csv("Data/Crystal_2014_wtrtemp.csv") # read in dataset without added columns from above

Crystal_separte_datetime <- Crystal %>%
        mutate(hour = hour(datetime)) %>% #creates new column with just hour from datetime
        mutate(time = as.hms(datetime,tz="UTC")) %>% #creates time column
        mutate(year = year(datetime)) %>% #creates new column with just year
        mutate(week = week(datetime)) %>% #creates new column with number for week
        mutate(weekday = weekdays(datetime,abbreviate = T)) #creates new column for day of week with the name abbreviated (can change to False for full name)

# Time spans
duration() #always uses seconds - useful for doing math with date time (add, subtract, multiply more easily)
dhours(c(12,24))

periods #human units - weeks, months
years(2) #better for leap years and day light savings time

intervals #useful for starting and end points

# Data Transformation - dplyr package ####

# Use Crystal dataset and nyc flights example dataset
install.packages("nycflights13") # flights departed from NYC (JFK, LGA, or EWR) in 2013
library(nycflights13) #contains multiple dataset but mostly using flights data

View(flights) #way to view data as separate tab in R Script window

#Typical format for dplyr functions:
# new_dataset <- FUNCTION(old_dataset, columns or rows applying function to)

# Select - chose specific variables interested in and keeps only variables named in new dataset
subset_flights <- select(flights, year,day,arr_time)

# Commands to use with select: : = inclusive between column names, - = everything but, starts_with, contains, matches, num_range
select(Crystal, starts_with("wtr"))
select(Crystal, datetime:wtr_10) #select columns from datetime to water temp at 10 m
select(Crystal, -datetime) #everything but datetime

select(flights,contains("TIME")) #not case specific

?select #help documentation for select is good

# Rename - change name of column headings
#Format for rename: rename(flights,NEW_NAME = OLD_NAME) #keeps all variables

flights_new_name <- rename(flights, airline = carrier) #new name = airline, old name = carrier

#Filter function
#operations for filter == Equal, & AND, | OR, ! NOT
#excludes NA values and False, ask for NA values explicitly with is.na
filter(flights, month==1, day==16)

jan_feb_flights <- filter(flights, month==1|month==2)
#NOT month==1|2

many_months <- filter(flights, month %in% c(11,12,4,6)) 
# x %in% y = select every row where x is one of the values in y

#is.na for missing values otherwise filter will exclude NA values
filter(df, is.na(x)|x > 1)

#between x >= left & x <= right
jan_june_flights <- filter(flights, between(month,1,6))


#Arrange
#changes order, breaks ties with additional columns and set can how decision made, missing values always sortedat end
#use desc() to put in descending order with highest number first
arrange(flights,desc(arr_delay))

na_sort <- flights %>%
        arrange(desc(is.na(dep_time)))

#Mutate 
#always adds new columns at end of dataset
mutate(flights, gain = arr_delay - dep_delay, speed = distance/air_time * 60) #arithmetric operators are recycled

# Example with creating a new column with character parsed as factor, make sure to set levels for factors
flights_factor <- flights %>% 
        mutate(origin_factor = parse_factor(origin, levels = c("EWR", "JFK", "LGA"))) %>% 
        select(-origin)

?everything #moves variables to front of data frame
test_everything <- select(flights, time_hour, air_time, everything())

#transmute will only keep new variables

#Mutate if - transform variables from one type to another
iris %>% 
        as_tibble() %>% 
        mutate_if(is.factor, as.character)
iris %>% 
        as_tibble() %>% 
        mutate_if(is.double, as.integer)

# comman calculations with mutate
x <- 1:10
(x <- c(seq(1,10, by=2)))
x/sum(x) #proportion of total
x - mean(x) #difference

cummean(x)
min_rank(x)
?min_rank
?rank

#Summarize - drops variables, Group Summaries with group_by
#summary functions - mean, sd, median, IQR, mad (median absolute deviation), min, max, quantile, first, last

summarize(flights, delay = mean(dep_delay, na.rm = T)) #creates new column called delay with mean of dep_daly, use na.rm to calculate mean and remove NA values will drop all other variables in data
summarize(flights, delay = median(arr_delay, na.rm = T))

#group by example - useful for calculating summaries on certain groups
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = T))

#Find the relationship between flight distance and avg delay by airport
# Example long way without pipe ( %>% ), requires extra naming of intermediate steps so harder to keep track
by_dest <- group_by(flights, dest)

delay <- summarise(by_dest,
                   count = n(), #n() = number of observations in current group
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)

delay <- filter(delay, count > 20, dest != "HNL") #filter out airports with destinations < 20 and exclude Honolulu

#With pipe = %>% translates to "then"
delays <- flights %>% 
        group_by(dest) %>% 
        summarise(count = n(), 
                  dist = mean(distance, na.rm = TRUE),
                  delay = mean(arr_delay, na.rm = TRUE)) %>% 
        filter(count > 20, dest != "HNL")

#Example with summarize all to calculate multiple summaries at once
Crystal_daily <- Crystal %>%
        select(datetime,wtr_1:wtr_5) %>%
        mutate(date = as_date(datetime)) %>%
        group_by(date) %>%
        summarize_all(funs(mean, min, max (.,na.rm=T))) 
#summarize_at(vars(wtr_1:wtr_5),funs(mean, min, max (.,na.rm=T)))

#Count = shorthand for group_by + tally, need to use with group_by, returns size of current group, n() = number of observations in current group, similar to length
delays <- flights %>% 
        group_by(dest) %>% 
        summarize(count = n())

airport_dest <- flights %>%
        count(dest)

sum(!is.na(flights$dep_time)) #count number of non-missing values
n_distinct(flights$dep_time) #count number of unique values


# dplyr Practice - Flights Dataset Questions & Answers ####
#1a. What are the most popular airport destinations on a year-round basis? 
pop_airport_dest <- flights %>%
        count(dest) %>%
        arrange(desc(n))

filter(airports,faa=="ORD")

#1b. What are the popular destinations in winter vs. summer?
pop_airport_dest_winter <- flights %>%
        filter(month %in% c(1,2,12)) %>%
        count(dest) %>%
        arrange(desc(n))

pop_airport_dest_summer <- flights %>%
        filter(month==6|month==7|month==8) %>%
        group_by(dest) %>% 
        summarize(n = n()) %>% 
        arrange(desc(n))


#2. What percent of flights are delayed by more than 1 hour but make up 30 min?
not_cancelled <- flights %>%
        filter(!is.na(dep_delay) & !is.na(arr_delay)) #or can use , instead of &

delay_flights <- not_cancelled %>%
        filter(dep_delay >= 60 & dep_delay - arr_delay > 30) %>% 
        summarize(n = n()) %>%
        summarize(perc_delay = n/count(not_cancelled)*100)


perc_delay <- delay_flights %>% 
        summarize(perc_delay = count(delay_flights)/count(not_cancelled)*100)

(perct <- (1844/327346)*100)


#3. What is the best time of day to fly to avoid delays?
best_time <- flights %>%
        group_by(hour) %>%
        summarize(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
        arrange(arr_delay)

#4. Airline carrier with most delays on arrival - 

# Carrier with most delays - express jet
bad_airline_carrier <- flights %>% 
        filter(arr_delay > 0) %>% 
        count(carrier) %>% #count does group by and then tally
        arrange(desc(n))

group_by(carrier)
summarize(delay_carrier = n()) %>% 
        arrange(desc(delay_carrier))

#min(bad_airline$arr_delay)
filter(airlines, carrier=="EV"|carrier=="B6"|carrier=="UA")

# airline carrier with worst delays on average - frontier, united for big ones        
bad_airline <- flights %>% 
        group_by(carrier) %>% 
        summarize(arr_delay = mean(arr_delay, na.rm = T)) %>% 
        arrange(desc(arr_delay))

filter(airlines, carrier=="F9")

#4b. Airport with most arrival delays
bad_airport_most_delay <- flights %>% 
        filter(arr_delay > 0, !is.na(arr_delay)) %>% 
        count(dest) %>% #count does group by and then tally
        arrange(desc(n))

#How does the airport with most arrival delays change when total number of flights is taken into account so proporiton of delayed flights is calculated?
#Total number of flights at each airport
total_flights_airport <- flights %>% 
        group_by(dest) %>% 
        summarize(no_flights = n()) %>% 
        arrange(desc(no_flights))

bad_airport_most_delay <- flights %>% 
        filter(arr_delay > 0, !is.na(arr_delay)) %>% 
        count(dest) %>% 
        arrange(desc(n)) %>% 
        left_join(total_flights_airport, by = "dest") %>% 
        mutate(prop_delay = n/no_flights) %>% 
        arrange(desc(prop_delay))

#Airport with worst delays
bad_airport <- flights %>% 
        group_by(dest) %>% 
        summarize(worst_delay = max(arr_delay, na.rm = T)) %>% 
        arrange(desc(worst_delay))

#Airport with worst delays on average
bad_airport_avg <- flights %>% 
        group_by(dest) %>% 
        summarize(worst_delay = mean(arr_delay, na.rm = T)) %>% 
        arrange(desc(worst_delay))

View(airports)
filter(airports, faa=="CAE")

#5. What is the busiest day to fly? thanksgiving 11/28
busy_day <- flights %>%
        group_by(year, month, day) %>% 
        summarize(no_flights = n()) %>% 
        arrange(desc(no_flights))

#6. Avg arrival delay by day of week - Sat shortest, Thurs longest
str(flights)
arrival_delay <- flights %>% 
        mutate(week_day = wday(time_hour,label = T)) %>%
        group_by(week_day) %>% #add month
        summarize(delay = mean(arr_delay,na.rm = T)) %>% 
        arrange(desc(delay))

tail(arrival_delay$week_day)


# Tidy Data - tidyr package ####

#Example with Crystal dataset
Crystal_wide <- read_csv("Data/Crystal_2014_wtrtemp.csv")
str(Crystal_wide)

#Gather - Convert data from wide to long format
#variable names are always converted to character vector
#key = create new column from column names
#value = what values or rows in dataset correspond to (Crystal example - water temperature) 
#typical set-up for gather:
#gather (<dataset>, <key>, <value>, which columns to transform (if not included, all variables are selected)
#all other variables in dataset remain same and are replicated as needed

Crystal_long <- Crystal_wide %>%
        gather(key = "depth", value = "wtr_temp",-datetime) %>% #gather all variables except datetime
        
        separate(depth,into = c("wtr","depth"), sep = "_") %>% #separate new column by underscore to have separate column that's just depth
        select(-wtr) %>% #remove the wtr column
        arrange(datetime) #order by profile so all depths are together from the same profile

str(Crystal_long)

#with specification for separate
Crystal_long <- Crystal_wide %>%
        gather(key = "depth", value = "wtr_temp",-datetime) %>%
        separate(depth,into = c("wtr","depth"), sep = "_", convert = T) %>% #convert will keep structure of depth and code as integer instead of character
        select(-wtr) %>% 
        arrange(datetime)

#Spread - convert data from long to wide
Crystal_wide2 <- Crystal_long %>% 
        spread(key = depth, value = wtr_temp)

names(Crystal_wide)
colnames(Crystal_wide2) = paste(colnames(Crystal_wide))

# Heat map example for when wide data helpful
install.packages(rLakeAnalyzer)
library(rLakeAnalyzer)

wtr.heat.map.j <- function (wtr, ...) 
{
        depths = get.offsets(wtr)
        n = nrow(wtr)
        wtr.dates = wtr$datetime
        wtr.mat = as.matrix(wtr[, -1])
        y = depths
        filled.contour(wtr.dates, y, wtr.mat, ylim = c(max(depths), 
                                                       0), nlevels = 100, color.palette = colorRampPalette(c("violet", 
                                                                                                             "blue", "cyan", "green3", "yellow", "orange", "red"), 
                                                                                                           bias = 1, space = "rgb"), ylab = "Depth (m)", ...)
        
}

wtr.heat.map.j(Crystal_wide)

#Gap minder example - https://www.gapminder.org
#Dataset of life expectanacy, GDP, population for 142 countries from 1952-2007
gap_minder <- read_csv("Data/gapminder_wide.csv")

#Tidy data by separating year from variable name
gap_minder_tidy <- gap_minder %>%
        gather(key = country_stat, value = gdp_pop, gdpPercap_1952:pop_2007) %>%
        separate(col=country_stat, into=c("var_name","year"),sep="_") %>%
        spread(key=var_name,value=gdp_pop)

#Spread and gather take key value pair
#key = column names
#takes all variables names and makes it key column
#value = all values into column called value

#unite - opposite of separate to join columns
gap_minder_unite <- gap_minder_tidy %>% 
        unite(country_year,country,year,sep = " ")#default sep = _ (underscore)

#Why does this fail?
people <- tribble(
        ~name,             ~key,    ~value,
        #-----------------|--------|------
        "Phillip Woods",   "age",       45,
        "Phillip Woods",   "height",   186,
        "Phillip Woods",   "age",       50,
        "Jessica Cordero", "age",       37,
        "Jessica Cordero", "height",   156
)

spread(people, key, value)
#multiple entries for Phillip Woods so won't be able to spread unless each variable has a unique identifier

# Solution #
new_people <- mutate(people,obs = c(1,1,2,1,1)) #creates new column called observation for multiple observations on same person
add_column(people,obs = c(1,1,2,1,1))

spread(new_people, key, value)

# gather or spread? 
preg <- tribble(
        ~pregnant, ~male, ~female,
        "yes",     NA,    10,
        "no",      20,    12
)

# 1 version #
gather(preg, key = sex, value = no_offspring, male, female) %>%
        mutate(pregnant = pregnant == "yes",
               female = sex == "female") %>%
        select(-sex)

# Dealing with missing values with gather and spread #
#explicit vs. implicit - ie NA vs. value not present (blank)
#extra = drops extra values with warning, extra = "merge" to keep extra values, fill with missing values
#pass na.rm = T to gather if don't want NA turns explicit to implicit
#complete = finds all unique combinations of set of columns and if data doesn't contain values, fills in NA

stocks <- tibble(
        year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
        qtr    = c(   1,    2,    3,    4,    2,    3,    4),
        return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>%
        spread(year, return) %>% 
        gather(year, return, `2015`,`2016`) #, na.rm = T)

stocks %>% 
        complete(year, qtr)

stocks <- tibble(
        year   = c(2015, NA, NA, NA, 2016, NA, NA),
        qtr    = c(   1,    2,    3,    4,    2,    3,    4),
        return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>% fill(year)

# Joins - tidyr package ####
bind_cols() #equivalent to cbind or rbind
bind_rows

View(flights)
View(airports)
View(airlines)
View(planes)
View(weather)

# Example of left_join = mutating join 
airline_names <- flights %>% 
        select(year:day, tailnum, carrier) %>% 
        left_join(airlines, by = "carrier") #by tells it which variable to join by

# Example if want to join by columns with same variable but different name
airlines$Carrier <- airlines$carrier #Create new column with carrier spelled with capital C

airlines <- airlines %>%
        select(-carrier)

airline_names <- flights %>% 
        select(year:day, tailnum, carrier) %>% 
        left_join(airlines, by = c("carrier" = "Carrier")) #concatenate multiple variables and set equal

# Join Examples
x <- tribble(
        ~key, ~val_x,
        1, "x1",
        2, "x2",
        3, "x3"
)
y <- tribble(
        ~key, ~val_y,
        1, "y1",
        2, "y2",
        4, "y3"
)

#inner join
inner_join <- x %>% 
        inner_join(y, by = "key") #default for by is to join on all columns that match
#only joins matching keys and others dropped, unmatched keys are not in result

#left join - good default, preserves originial observations even when there isn't match in second dataset and adds NA if missing data
left_join(x,y, by = "key")

#Duplicate keys (not unique) - get all possible values of duplicates

flights_test_join <- flights %>% 
        select(year:day, hour, origin, dest, tailnum, carrier)

View(planes) #year = year plane manufactured
flights_test_join %>% 
        left_join(planes, by = "tailnum")

flights_test_join %>% 
        left_join(airports, by = c("dest" = "faa"))

#Filtering joins - never duplicate rows

#Anti-join example
flights %>% 
        anti_join(planes, by = "tailnum") %>% 
        count(tailnum, sort = TRUE) # sort = TRUE puts na values to top

#Set observations:
# intersect = return only observations in both x & y
# union = return unique observations in x & y
# setdiff = return observations in x but not in y
