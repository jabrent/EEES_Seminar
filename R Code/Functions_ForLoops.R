#### Functions & For Loops ####
# Created by JAB April 2018 for EEES Seminar
# Available on github class respository: https://github.com/jabrent/EEES_Seminar

# Functions ####
#Function arguments - 2 pieces
#1. Data to use
#2. Any details 

# Calculate standard error
head(iris)
standard.error <- sd(iris$Petal.Width)/sqrt(length(iris$Petal.Width))

standard.error <- sd(x)/sqrt(length(x))


standard_error <- function(x) {
        sd(x)/sqrt(length(x)) # x defined in local environment
}

iris
standard_error(iris$Petal.Width)

x <- 1:100 # defined in global environment

# Define variables in functions
standard_error <- function(x) {
        s <- sd(x)
        n <- length(x)
        s/sqrt(n)
}

# R for data science example
# Goal = write a function that rescales data in each column to have a range from 0 to 1

#read in data
df <- tibble::tibble(
        a = rnorm(10), #rnorm generates 10 random numbers with normal distribution
        b = rnorm(10),
        c = rnorm(10),
        d = rnorm(10)
)

#Rescales data between 0 and 1
df$a <- (df$a - min(df$a, na.rm = TRUE)) /
        (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

# Could copy and paste for b,c, and d or write function

# Change temporary variables to general names and rewrite statement using x
(x <- df$a)
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

# Make new variable for the range of x
rng <- range(x, na.rm = TRUE) #range returns min and mix of given arguments
rng[2]

(x - rng[1]) / (rng[2] - rng[1])

# Put it into a function 
rescale01 <- function(x) {
        # Make new variable called range ---- 
        rng <- range(x, na.rm = TRUE)
        (x - rng[1]) / (rng[2] - rng[1])
} # functions always start and end with curly braces


---- #Used for line breaks need minimum of 4
# Test
rescale01(c(0, 5, 10)) #in this case x = c(0, 5, 10)
rescale01(c(1, 2, 3, NA, 5))

#
mean_ci <- function(x, conf = 0.95) { # x = data, conf = detail, most common value
        se <- sd(x) / sqrt(length(x))
        alpha <- 1 - conf
        mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}


mean_ci(x, conf = 0.99) # can change default value

# Debug code - R recycles vectors so need to explicit check if vectors not the same length and through error message

wt_mean(1:6, 1:3)

wt_mean <- function(x, w) {
        if (length(x) != length(w)) {
                stop("`x` and `w` must be the same length", call. = FALSE)
        }
        sum(w * x) / sum(w)
}

# stopifnot statement = checks if each argument true, stops and produces generic error message if not
wt_mean <- function(x, w, na.rm = FALSE) {
        stopifnot(is.logical(na.rm), length(na.rm) == 1)
        stopifnot(length(x) == length(w))
}

#Return statements - Value returned by function defaults to last statement evaluated but can return early or explicitly call
return()

# Remove arguments or functions
rm(x)

#Function to show number of missing values in data frame
show_missing_values <- function(df) {
        n <- sum(is.na(df))
        cat("Missing values: ", n, "\n", sep = "")
        
        invisible(df) #invisible tells it not to print data frame
}

show_missing_values(Crystal)

        
# Heat map example ####

library(rLakeAnalyzer)

wtr.heat.map.j <- function (wtr, ...) 
{
        depths = get.offsets(wtr)
        n = nrow(wtr)
        wtr.dates = wtr$datetime
        wtr.mat = as.matrix(wtr[, -1])
        y = depths
        filled.contour(wtr.dates, y, wtr.mat, ylim = c(max(depths), 0), nlevels = 100,
                       color.palette = colorRampPalette(c("violet", "blue", "cyan", "green3", 
                        "yellow", "orange", "red"), 
                        bias = 1, space = "rgb"), ylab = "Depth (m)", ...)
        
}

wtr.heat.map.j(Crystal)



# If/else statements #### 

#if else statements - 3 arguments
# 1. test = logical vector - has to be True or False
# 2. result if test is TRUE
# 3. result if test is FALSE

# help for if = ?`if`

# Example outline for if else statement - always surround with curly braces and start a new line after the opening one and the closing you should be on its own line unless followed by else

if (condition) {
        # code executed when condition is TRUE - always indented
} else { 
        # code executed when condition is FALSE
} #use curly braces in if else statements

# Function checks if element of a vector is named and returns a logical value

x <- c("apple", "banana", "blueberry")

#function is looking for column names
has_name <- function(x) {
        nms <- names(x)
        if (is.null(nms)) {
                rep(FALSE, length(x)) # then statement
        } else {
                !is.na(nms) & nms != ""
        }
}

has_name(x)

# Test with Crystal dataset

# Read in data from Data folder in R project
Crystal <- read_csv("Data/Crystal_2014_wtrtemp.csv") 

x <- Crystal
has_name(x)

# use && and || in if statements to combine multiple logical vectors
if (x > 2 && y > 4)
        #then

# Replacing outliers with NA
diamonds2 <- diamonds %>% 
        mutate(y = ifelse(y < 3 | y > 20, NA, y))

# Else if statements

if (this) {
        # do that
} else if (that) {
        # do something else
} else {
        # 
}

# Linear interpolation example ####
library(zoo) #for time series data
library(rLakeAnalyzer) #for heat map plots

Crystal_2014_wtrtemp = read_csv("Data/Crystal_2014_wtrtemp.csv")

data = Crystal_2014_wtrtemp
data$datetime = as.POSIXct(data$datetime)

depths = get.offsets(data)
ncols = ncol(data)

for(i in 1:nrow(data)){
        
        values = unlist(data[i,2:ncols])
        
        if(sum(!is.na(values)) <= floor(ncols/4)){
                #if there isn't at least 25% of the data, then we skip it - might want to modify if needed 
                next
        }
        
        new_vals = na.approx(values,x=depths, xout=depths, na.rm=FALSE)
        
        data[i, 2:ncols] = new_vals	
}

wtr.heat.map(data, main="after x-depth interp")

maxgap = 2  #Fill gaps = 1 day

for(i in 2:ncol(data)){
        
        values = unlist(data[, i])
        
        new_vals = na.approx(values, x=data$datetime, xout=data$datetime, na.rm=FALSE, maxgap=maxgap)
        
        data[, i] = new_vals	
}

wtr.heat.map(data, main="after both interp")

# For loops ####

df <- tibble(
        a = rnorm(10),
        b = rnorm(10),
        c = rnorm(10),
        d = rnorm(10)
)

# Write for loop to calculate median of each column in df
output <- vector("double", ncol(df))  # 1. output

for (i in seq_along(df)) {            # 2. sequence
        output[[i]] <- median(df[[i]])      # 3. body
}

output
## [[ ]] signifies working with single value, will also work with single square brackets

# Example with iris

output <- vector("double", ncol(iris))

for(i in seq_along(iris)) {
        output[i] <- n_distinct(iris[i])
}
output

# Example of water temperature
for(i in 1:nrow(lake.surface)){
        mean.temp <- mean(lake.surface[ ,i])
        sd.temp <- sd(lake.surface[ ,i])
        cv <- sd.temp/mean.temp
        print(cv)
}

# Example with time
Crystal <-  read.csv("Data/Crystal_2014_wtrtemp.csv")
Crystal$datetime = as.POSIXlt(Crystal$datetime, format = "%Y-%m-%d %H:%M")

str(Crystal)
nrow(Crystal)

newtime <- as.POSIXlt(Crystal[,1])
length(newtime)
for (i in 1:NROW(newtime)) {
        if (newtime[i]$hour < 24)
        {newtime[i]$min = 30
        }
        Crystal_newtime = cbind(newtime,Crystal)
}

#Improve

#Add output
length(newtime)
output <- vector("list", length(Crystal))
#use seq_along

for (i in seq_along(newtime)) {
        if (newtime[i]$hour < 24) {
        newtime[i]$min = newtime[i]$min + 3
        }
     
}

head(newtime)

# Example to read in a bunch of csv files

files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)

df <- vector("list", length(files))
for (fname in seq_along(files)) {
        df[[i]] <- read_csv(files[[i]])
}
df <- bind_rows(df)

