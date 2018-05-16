##Example 2 from flight data
#Created by Rebecca Finger on April 18, 2018
##What percent of flights are delayed by more than 30 min 
#but make-up 30 minutes in flight?


#Load libraries
library(tidyverse)
library(lubridate)
library(hms)

#install NYCflights data
install.packages("nycflights13")
flights<-rename(flights_new_name)

#filter out data that are delayed by 30 min
delay=filter(flights, dep_delay >= 30)
        
#from the delay df, filter flights that make up time
delay_arriv<-mutate(delay, arr_delay -dep_delay)

catch_up<-filter(delay_arriv, arr_delay -dep_delay < (-30) )

#figure out proportion of delayed flights that make up 30 min
(count(catch_up)/count(delay_arriv))*100
