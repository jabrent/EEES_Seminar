#### Functions & For Loops ####
# Created by JAB April 2018 for EEES Seminar
# Available on github class respository: https://github.com/jabrent/EEES_Seminar


# For loops ####

# Example with time
n=Stechlin_all[,1]
datetime = as.POSIXlt(n)

for (i in 1:nrow(datetime)) {
        if ((datetime[i]$hour < 24))
        {datetime[i]$min = 0
        }
        Stechlin_newtime = cbind(datetime,Stechlin_all)
}


# If else statements #### 

# Replacing outliers with NA

#if else statements - 3 arguments
# 1. test = logical vector
# 2. result if test is TRUE
# 3. result if test is FALSE

diamonds2 <- diamonds %>% 
        mutate(y = ifelse(y < 3 | y > 20, NA, y))