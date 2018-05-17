#### Data Visualizations ####
# Created by JAB April 2018 for EEES Seminar
# Available on github class respository: https://github.com/jabrent/EEES_Seminar


# Install Packages ####
library(tidyverse)
library(gcookbook)

# Basic ggplot structure ####
ggplot(data = <DATASET>)+ #add + at end of line 
        <GEOM_FUNCTION>(mapping = aes(x = , y = , ... ))


# 
ggplot(data = <DATASET>) + 
        <GEOM_FUNCTION>(
                mapping = aes(<MAPPINGS>),
                stat = <STAT>, 
                position = <POSITION>
        ) +
        <COORDINATE_FUNCTION> + #switch x & y axis
        <FACET_FUNCTION>
        

# Aesthetics options ####
#options for asesthetics in addition to axis variables
color
alpha #transparency
fill
size #number in mm ex. 2 or 4
linetype #0-6 or blank, solid, dashed, dotted, dotdash, longdash, twodash
shape #max 6 shapes, integers 0-25

# A look at all 25 symbols
# Hollow shapes - border set with color = 0-14 
# Solid shapes - color set with fill = 15-18
# Filled shapes - set border with color and inside color with fill = 21-25
df2 <- data.frame(x = 1:5 , y = 1:25, z = 1:25)
s <- ggplot(df2, aes(x, y))+
        geom_point(aes(shape = z), size = 4) +
        scale_shape_identity()
# While all symbols have a foreground colour, symbols 19-25 also take a
# background colour (fill)
s +
geom_point(aes(shape = z), size = 4, colour = "Red") +
        scale_shape_identity()
s +
geom_point(aes(shape = z), size = 4, colour = "Red", fill = "Black") +
        scale_shape_identity()

#Options for colors - Rcolor Brewer and viridis package
library(RColorBrewer) #color brewer package
display.brewer.all()
display.brewer.pal(n = 8, name = 'Dark2')

install.packages("viridis")
library(viridis)

ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
        geom_hex() + coord_fixed() +
        scale_fill_viridis() + theme_bw()

#color blind friendly options
library(dichromat)


# Test dataset - mpg = US EPA data on 38 models of cars ####
View(mpg) #displ = car's engine size, hwy = car's fuel efficiency mpg
str(mpg)

ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) #local mapping
                   
#Add color - Local vs. Global mapping
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + #global mapping
        geom_point(color = "blue") #go oustide aesthetic mapping

#Map color to categorical variable
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = class))+
        theme_classic()

#Map color to continuos variable, shape?
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = cty)) #cty = city 

# Facets ####

#useful for categorical variables
#facet_wrap() = facet by 1 variable
#facet_grid() = facet by 2 variables

#Instead of plotting class to color, facet by class
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_wrap( ~ class) #, nrow = 2) # ~ tilda implies formula, use discrete variables (not continuous)

#facet grip
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(drv ~ class)+ # ~ tilda implies formula
        theme_classic()
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(class ~ .) #switches dimension to facet on


# Add geom ####
# geom = visual object that plot uses to represent data
# Some examples
geom_bar()
geom_boxplot()
geom_histogram()
geom_line()
geom_point()
geom_text()
geom_smooth()

ggplot(data = mpg) + 
        geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
?geom_smooth
#geom_smooth = default loess for < 1000 obs, lm, glm

# Add multiple geoms to same plot - beauty of ggplot layers!
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + #global mapping
        geom_point() +
        geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
        geom_point() + #local mapping overwrites global mapping
        geom_smooth()

#map different datasets to different geoms
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point(mapping = aes(color = class)) + 
        geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE) #se = F turns off confidence intervals around best fit line 


# Bar plots vs. histograms ####
ggplot(data = mpg) +
        geom_bar(mapping = aes(x = class)) #reorder with factor levels

#Geoms that calculate new variables - bar, histogram, smoooth, boxplot
#bar plots - bin data & plot bin counts (# of points that fall in each bin)
#stat = statistical transformation
#default stat = count, number in each category on x
# If you instead want to have the height of the bar correspond to a variable you can change the stat to "identity" or use geom_col
# stat = identity - height of bars = sum or raw values of y variable 
#geom_bar interchangeable with stat_count() 

#To map value to y-aixs, use geom_col or geom_bar change stat to identity
#Change stat to prop as well

ggplot(data = mpg) +
        geom_bar(mapping = aes(x = class, y = hwy)) #stat has to be used if set y variable

ggplot(data = mpg) +
        geom_bar(mapping = aes(x = class, y = hwy), stat="identity") #identity will set height of bars to sum of y value

#same plot
ggplot(data = mpg) +
        geom_col(mapping = aes(x = class, y = hwy)) 

# Example of other stat options
ggplot(data = diamonds) +
        stat_summary(
                mapping = aes(x = cut, y = depth),
                fun.ymin = min,
                fun.ymax = max,
                fun.y = mean
        )

# Position Adjustments - dodge & fill bars
ggplot(mpg, aes(class))+ 
        geom_bar(aes(color = drv)) #color will only change the outline of the bars use fill instead for bar plots

ggplot(mpg, aes(class))+ 
        geom_bar(aes(fill = drv)) #default stacked bar with variable plotted to fill

ggplot(mpg, aes(class))+ 
        geom_bar(aes(fill = drv), position = "dodge") #more common than fill which creates stacked bar chart which are hard to visualize

# Change position - options = dodge, fill, identity
# poistion dodge = places bars next to each for variable mapped to fill
# position identity = overlaps each bar, can change with alpha or fill = NA
# position fill = stacked bars all to the same height
# position jitter = useful for scatterplots to jitter points if all overplotted, geom_jitter



# Histogram ####
#Binwidth is always measured in units of x variable

#Diamond example
ggplot(data = diamonds) +
        geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

#zoom in
smaller <- diamonds %>% 
        filter(carat < 3)

#test smaller binwidth
ggplot(data = smaller, mapping = aes(x = carat)) +
        geom_histogram(binwidth = 0.1)

geom_freqpoly() #good for overlaying multiple histograms in same plot
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
        geom_freqpoly(binwidth = 0.1)

#Explore relationships between variables - number of old faithful eruptions based on duration of eruption time in minutes
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
        geom_histogram(binwidth = 0.25)
View(faithful)

# Checking for outliers
ggplot(diamonds) + 
        geom_histogram(mapping = aes(x = y), binwidth = 0.5)

#coord_cartesian allows you to see outliers
ggplot(diamonds) + 
        geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
        coord_cartesian(ylim = c(0, 50))

# change outliers to NA
diamonds2 <- diamonds %>% 
        mutate(y = ifelse(y < 3 | y > 20, NA, y))

# Covariation ####

# 1 categorical and 1 continuous variable
ggplot(data = diamonds, mapping = aes(x = price)) + 
        geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

#change y to density
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
        geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

# Box plots 
#good for one categorical variable and one continuous variable
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
        geom_boxplot()

#change order
ggplot(data = mpg) +
        geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

#reorder = similar to factor(x, levels)
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
        geom_boxplot()

# 2 categorical variables
ggplot(data = diamonds) +
        geom_count(mapping = aes(x = cut, y = color))

#Heat map
diamonds %>% 
        count(color, cut) %>%  
        ggplot(mapping = aes(x = color, y = cut)) +
        geom_tile(mapping = aes(fill = n))

# 2 continuous variables - scatterplot
ggplot(data = diamonds) +
        geom_jitter(mapping = aes(x = carat, y = price))
       

# bin data for large datasets
smaller <- diamonds %>% 
        filter(carat < 3)

ggplot(data = smaller) +
        geom_bin2d(mapping = aes(x = carat, y = price))

# Dot plots ####
# A better bar plot - dot plots!
ggplot(data = mpg, aes(x = class, y = hwy)) +
        geom_point() + #also do stat_indentity()
        stat_summary(fun.y = mean, geom="point", color="red", shape = 3, size = 5)

# Could also add do with geom_errorbarh
# Calculate mean + SD
mpg_summary <- mpg %>% 
        group_by(class) %>% 
        mutate(hwy_mean = mean(hwy)) %>% 
        mutate(hwy_sd = sd(hwy))

ggplot(data = mpg_summary, aes(x = class, y = hwy)) +
        geom_point() + 
        geom_errorbar(aes(ymin = hwy_mean - hwy_sd, ymax = hwy_mean + hwy_sd), width = 0.2)+
        stat_summary(fun.y = mean, geom="point", color="red", shape = 3, size = 5)

# Example with larger dataset
install.packages("gcookbook")
library(gcookbook) 
View(tophitters2001) # batting averge of top hitters in MLB in 2001

#subset to top 25
tophit <- tophitters2001 [1:25, ]

#names sorted alphabetically
ggplot(tophit, aes(x = avg, y = name))+ 
        geom_point() 

#subset to include name, league (lg), and batting average (avg)
tophit <- tophit %>% 
        select(name, lg, avg)
str(tophit) #names character so sorted alphabetically


# reorders dataset to sort by avg instead of alphabetically by name
reorder(tophit$name,tophit$avg) #takes name column turns it into a factor and sorts the factor levels by avg

#use reorder command in ggplot call
ggplot(tophit, aes(x = avg, y = reorder(name,avg)))+ 
        geom_point(size = 3) +
        theme_bw()+
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.major.y = element_line(color = "grey60", linetype = "dashed"))

#swap axes for names
ggplot(tophit, aes(y = avg, x = reorder(name,avg)))+ 
        geom_point(size = 3) +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 60, hjust = 1),
              panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.major.y = element_line(color = "grey60", linetype = "dashed"))

#group by second variable - league in addition to batting average
#reorder will only order factor levels by one variable so have to do manually
nameorder <- tophit$name[order(tophit$lg, tophit$avg)]

#turn name into a factor with levels in the order of nameorder
tophit$name <- factor(tophit$name, levels = nameorder)

# map league to color
ggplot(tophit, aes(x = avg, y = name))+ 
        geom_segment(aes(yend = name), xend = 0, color = "grey50")+ #makes lines go only to points
        geom_point(size = 3, aes(color = lg))+
        scale_color_brewer(palette = "Set1", limits = c("NL", "AL"))+ #sets colors to set 1 for different groups in limit
        theme_bw()+
        theme(panel.grid.major.x = element_blank(),
              panel.grid.minor.x = element_blank(),
              panel.grid.major.y = element_line(color = "grey60", linetype = "dashed"))

# clean up and remove horizontal grid lines
ggplot(tophit, aes(x = avg, y = name))+ 
        geom_segment(aes(yend = name), xend = 0, color = "grey50")+
        geom_point(size = 3, aes(color = lg))+
        scale_color_brewer(palette = "Set1", limits = c("NL", "AL"))+ 
        theme_bw()+
        theme(panel.grid.major.y = element_blank(),
              legend.position = c(0.85, 0.55), #max of x = 1
              legend.justification = c(1, 0.5)) #moves legend inside plot area

# or can facet
ggplot(tophit, aes(x = avg, y = name))+ 
        geom_segment(aes(yend = name), xend = 0, color = "grey50")+
        geom_point(size = 3, aes(color = lg))+
        scale_color_brewer(palette = "Set1", limits = c("NL", "AL"), guide = FALSE)+ #removes extra legend
        theme_bw()+
        theme(panel.grid.major.y = element_blank())+
        facet_grid(lg ~ ., scales = "free_y", space = "free_y") #space - default = fixed and all panels have same size, allows height to be proportional to the length of the y scale


# Violin Plots - compare density estimates of different groups or multiple data distributions
# uses kernal estimate of density to form symmetrical shape, 
#example of height & weight of school children
View(heightweight)

ggplot(heightweight, aes(x = sex, y = heightIn)) + 
        geom_violin()

ggplot(heightweight, aes(x = sex, y = heightIn)) + 
        geom_violin()+ 
        geom_boxplot(width = 0.1, fill = "black", outlier.color = NA)+ # don't display outliers
        stat_summary(fun.y = median, geom = "point", fill = "white", shape = 21, size = 2.5)


#total area same by default but can change to proportion
#adjusts changes the smoothing, larger numbers = smoother, defalt = 1
#trim = whether or not to include to keep tails or flat ends

ggplot(heightweight, aes(x = sex, y = heightIn)) + 
        geom_violin(trim = FALSE, scale = "count", adjust = 0.5)+ 
        geom_boxplot(width = 0.1, fill = "black", outlier.color = NA)+ 
        stat_summary(fun.y = median, geom = "point", fill = "white", shape = 21, size = 2.5)



# Scatter plots ####
# use school children height and weight data 

ggplot(heightweight, aes(x = ageYear, y = heightIn)) + 
        geom_point(shape = 19, size = 2) #default is shape = 16 but 19 is less jagged

#group by second categorical variable (factor) - can use color or shape
ggplot(heightweight, aes(x = ageYear, y = heightIn, color = sex, shape = sex)) + 
        geom_point(size = 4) #default shape = 16 but 19 is less jagged

#grouping by continuous variable - color
ggplot(heightweight, aes(x = ageYear, y = heightIn, color = weightLb)) + 
        geom_point(size = 4)

#shape for bubble plot
ggplot(heightweight, aes(x = ageYear, y = heightIn, size = weightLb)) + 
        geom_point() #size here will override aesthetics

#both shape and color
ggplot(heightweight, aes(x = ageYear, y = heightIn, size = weightLb, color = weightLb)) + 
        geom_point() #size here will override aesthetics

# put it all together
ggplot(heightweight, aes(x = ageYear, y = heightIn, size = weightLb, color = sex)) + 
        geom_point(alpha = 0.5)+ #alpha will change transparency of points
        scale_size_area() + #area proportinal to numeric value
        scale_color_brewer(palette = "Set1")

#add fitted linear regression line
ggplot(heightweight, aes(x = ageYear, y = heightIn, color = sex)) + 
        geom_point(alpha = 0.5)+ #alpha will change transparency of points
        scale_color_brewer(palette = "Set1") +
        geom_smooth(method = lm, se = FALSE, fullrange = TRUE) #extends to full range of data 

#but we don't grow linearly forever!
ggplot(heightweight, aes(x = ageYear, y = heightIn, color = sex)) + 
        geom_point(alpha = 0.5)+ #alpha will change transparency of points
        scale_color_brewer(palette = "Set1") +
        geom_smooth(method = loess, se = TRUE) #default for geom_smooth()

# Scatterplot matrix ####
#need to use numeric data
View(countries)

countries_2009 <- countries %>%
        filter(Year== 2009) %>% 
        select(Name, GDP, laborrate, healthexp, infmortality)

# Function pairs from base R will make scatterplot matrix
pairs(countries_2009[,2:5])

# From pairs help page: copy & paste!
# Function to show correlation coefficient of each pair of variables in scatter plot
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...) {
        usr <- par("usr")
        on.exit(par(usr))
        par(usr = c(0, 1, 0, 1))
        r <- abs(cor(x, y, use="complete.obs"))
        txt <- format(c(r, 0.123456789), digits=digits)[1]
        txt <- paste(prefix, txt, sep="")
        if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
        text(0.5, 0.5, txt, cex = cex.cor * (1 + r) / 2) #higher correlation in larger font but slight variation from pairs so font sizes aren't as extreme
}

# shows histograms of each variable along diagonal
panel.hist <- function(x, ...) {
        usr <- par("usr")
        on.exit(par(usr))
        par(usr = c(usr[1:2], 0, 1.5) )
        h <- hist(x, plot = FALSE)
        breaks <- h$breaks
        nB <- length(breaks)
        y <- h$counts
        y <- y/max(y)
        rect(breaks[-nB], 0, breaks[-1], y, col="white", ...)
}

# Run pairs with function calls
pairs(countries_2009[,2:5],
      upper.panel = panel.cor, 
        diag.panel = panel.hist,
        lower.panel = panel.smooth) #use LOWESS

#Change panel.smooth to lm
panel.lm <- function (x, y, col = par("col"), bg = NA, pch = par("pch"), cex = 1, col.smooth = "black", ...) {
        points(x, y, pch = pch, col = col, bg = bg, cex = cex)
        abline(stats::lm(y ~ x),  col = col.smooth, ...)
}

pairs(countries_2009[,2:5],
      upper.panel = panel.cor, 
      diag.panel = panel.hist,
      lower.panel = panel.lm)

# Coordinate systems ####
# Default coordinate system is Cartesian coordinates
coord_flip() #useful for horizontal boxplots or long labels

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
        geom_boxplot()+ 
        coord_flip()

coord_quickmap() #correct aspect ratio for maps

# Polar coordinates
coord_polar()


# Themes and Clean Plots ####
theme_classic() #great starting point!
theme_bw() #black and white theme is also good

theme_bw(base_family = "Times")+
        theme(axis.title.x = element_text(size=18),
              axis.title.y = element_text(size=18),
              axis.text=element_text(size=16,colour ="black"))+
        theme(panel.border=element_blank(),
              axis.line = element_line(color="black"),
              plot.background = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())


# Try plotly for interactive plots ####
# Need a free acount to post plots but can use on own computer for free, works with Python and Matlab too
# More info: https://plot.ly/r/getting-started/

# Install package and load library
install.packages("plotly")
library(plotly) #Yes if needs compilation question comes up

# Development version
devtools::install_github("ropensci/plotly")

#use dev version of ggplot2 with ggplotly()
devtools::install_github('hadley/ggplot2')
library(ggplot2)

#Link plotly account through API
# set plotly user name
Sys.setenv("plotly_username"="YOUR_plotly_username")
# set plotly API key
Sys.setenv("plotly_api_key"="YOUR_api_key")

#Basic functions
plot_ly
ggplotly

#Example with ggplot
diamond_freqpoly <-  ggplot(data = diamonds, mapping = aes(x = carat, colour = cut)) +
        geom_freqpoly(binwidth = 0.1)

ggplotly(diamond_freqpoly)

#Base plot
str(midwest) #demographic info of midwest counties
p <- plot_ly(midwest, x = ~percollege, color = ~state, type = "box")
p

#double click to isolate one state

# publish plotly plot to your plotly online account
py
api_create(p, filename = "r-docs-midwest-boxplots")

# Factors - forcats package ####
install.packages("forcats")
library(forcats) #also installs as part of tidyverse

# Make a list of different levels for the order you want that factors to be in
months <- c("Jan", "Feb", "Mar", "Dec")
str(months) #Defaults to character

month_levels <- c("Dec", "Jan", "Feb", "Mar") #any levels not included from original dataset will be converted to NA

#Function factor very useful
months_factor <- factor(months, month_levels) #list of months, levels that you want the factor ordered in
str(months_factor)

#Omit levels - uses alphabetical order
factor(months)

#Can set factor levels to first appearance in data
f1 <- factor(months, levels = unique(months))
f1

#or with fct_inorder
f2 <- months %>% 
        factor() %>% 
        fct_inorder()

#Levels allows you to see the set of levels directly
levels(f2)

#examples with General Social Survey (GSS) dataset that has a lot categorical variables
gss_cat #name of dataset
str(gss_cat)

#See order of factors levels with count function
gss_cat %>% 
        count(race)

#or with a bar fig

ggplot(gss_cat,aes(race)) +
        geom_bar()+
        scale_x_discrete(drop = FALSE) #by default ggplot will drop factor levels with NA but to make them plot you can set the scale x discrete function drop = F

#Changing the order of factor levels

#Wrangle the data to make a summary with the avg number of hours spent watching TV per day across religions
relig_tv <- gss_cat %>% 
        group_by(relig) %>% 
        summarize(
                age = mean(age, na.rm = TRUE),
                tvhours = mean(tvhours, na.rm = T),
                n = n()) #count of number of survey respondents in each religion group

ggplot(relig_tv, aes(tvhours, relig))+
        geom_point() + 
        theme_classic()

#use fct_reorder to reorder factors levels by increasing number of TV hours
#3 arguments: 
#1. f = factor with levels want to modify
#2. x = numeric vector to reorder levels
#3. fun = optional function used if multiple values of x for each value of f - default is set to median but could change to mean, max, min, etc. desc set to FALSE but change to TRUE if want in descending order
fct_reorder(f, x, fun = "median", desc = FALSE) #default

#Include in ggplot call
ggplot(relig_tv, aes(tvhours, fct_reorder(relig,tvhours)))+
        geom_point() + 
        theme_classic()

#Can also include in separate call outside of ggplot
relig_tv %>% 
        mutate(relig = fct_reorder(relig,tvhours)) %>% 
        ggplot(aes(tvhours, relig))+
        geom_point() + 
        theme_classic()

#If you want to keep the factor order but just move certain factors to bottom, use fct_relevel

fct_relevel(f, "level", after = Inf) # f = factor, level = name of level you want to move or multiple ones with concatenate (c) and after lets you set the position with a number (i.e. 2 or 3) or Inf moves the level to the end

ggplot(relig_tv, aes(tvhours, fct_relevel(relig,c("Other", "No answer", "None"), after = 1)))+
        geom_point() + 
        theme_classic()

#fct_relevel2 - reorders the factors by the y values associated with the largest x values, can make plots easier to read because the colors line up with the legend
# Example with gapminder dataset - Jenny Bryan
library(gapminder)

h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
        filter(country %in% h_countries) %>% 
        droplevels()
ggplot(h_gap, aes(x = year, y = lifeExp, color = country)) +
        geom_line() #legend defaults to ordering factor levels alphabetically

#Legend in same order as data - use fct_reorder2
ggplot(h_gap, aes(x = year, y = lifeExp,
                  color = fct_reorder2(country, year, lifeExp))) + #uses last x value to sort by
        geom_line() +
        labs(color = "country") #sets legend for color to country

#Bar plots
fct_infreq #will order levels in increasing frequency
fct_rev # will reverse order of factor levels

gss_cat %>%
        mutate(marital = marital %>%
                       fct_infreq()) %>%
        ggplot(aes(marital)) +
        geom_bar()

#Reverse factor order
gss_cat %>%
        mutate(marital = marital %>%
                       fct_infreq() %>%
                       fct_rev()) %>% 
        ggplot(aes(marital)) +
        geom_bar()

# Modify factor levels ###
#clarify levels for tidier figures or publications

fct_recode("New_name" = "Old_name",etc) #leaves levels not included in call as is

gss_cat %>% count(partyid) #bad names for factor levels

gss_cat %>%
        mutate(partyid = fct_recode(partyid,
               "Republican, strong"    = "Strong republican",
                "Republican, weak"      = "Not str republican",
                "Independent, near rep" = "Ind,near rep",
                "Independent, near dem" = "Ind,near dem",
                "Democrat, weak"        = "Not str democrat",
                "Democrat, strong"      = "Strong democrat"
        )) %>%
        count(partyid)

#Can also assign multiple factors to one level if you want to group them together
gss_cat %>%
        mutate(partyid = fct_recode(partyid,
         "Republican, strong"    = "Strong republican",
         "Republican, weak"      = "Not str republican",
         "Independent, near rep" = "Ind,near rep",
         "Independent, near dem" = "Ind,near dem",
         "Democrat, weak"        = "Not str democrat",
         "Democrat, strong"      = "Strong democrat",
          "Other"                = "No answer",
          "Other"                = "Don't know",
          "Other"               = "Other party"
        )) %>%
        count(partyid)

#To collapse a lot of factor level use fct_collapse - for each new variable, you can provide a vector of old levels

gss_cat %>%
        mutate(partyid = fct_collapse(partyid,
               other = c("No answer", "Don't know", "Other party"),
               rep = c("Strong republican", "Not str republican"),
               ind = c("Ind,near rep", "Independent", "Ind,near dem"),
               dem = c("Not str democrat", "Strong democrat"))) %>%
        count(partyid)

#To lump factor levels together - use fct_lump. Defaults to aggregating the smallest groups together and leaving the one large group but can change by setting n to be number of groups

gss_cat %>%
        mutate(relig = fct_lump(relig)) %>%
        count(relig)

#Lump into 10 levels
gss_cat %>%
        mutate(relig = fct_lump(relig, n = 5)) %>%
        count(relig, sort = TRUE)


# Jenny Bryan - gap minder example ####
library(gapminder)

str(gapminder)

str(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)
class(gapminder$continent)

#count for factors
fct_count(mpg$model)

#Convert variables to factors
gapminder <- gapminder %>%
        mutate(country = factor(country),
               continent = factor(continent))

#Drop unused factor levels
nlevels(gapminder$country)

h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
        filter(country %in% h_countries)

nlevels(h_gap$country) # still at 142!

#use fct_drop
h_gap$country %>%
        fct_drop() %>%
        levels()

#order factor levels by frequency
gapminder$continent %>% 
        fct_infreq() %>%
        levels()

## backwards!
gapminder$continent %>% 
        fct_infreq() %>%
        fct_rev() %>% 
        levels()

#reorder factor levels by median or any function
fct_reorder(gapminder$country, gapminder$lifeExp, min) %>% #reorder the country by the minimum life expectancy
        levels() %>% head()

## backwards!
fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>% 
        levels() %>% head()

# Combine factor levels 
df1 <- gapminder %>%
        filter(country %in% c("United States", "Mexico"), year > 2000) %>%
        droplevels()
df2 <- gapminder %>%
        filter(country %in% c("France", "Germany"), year > 2000) %>%
        droplevels()

levels(df1$country)
levels(df2$country)

#Can't just concatenate
c(df1$country, df2$country) #Don't do!

#Instead use fct_c
fct_c(df1$country, df2$country)

#Row binding with factors - will turn back to characters so be careful!
df3 <- bind_rows(df1, df2)
str(df3)
df4 <- rbind(df1,df2) #keeps factors
str(df4)

gap_life_exp <- gapminder %>%
        group_by(country, continent) %>% #only keeps variables named in group
        summarise(life_exp = max(lifeExp)) %>% 
        ungroup() #removes grouping

gap_life_exp


# Heat maps ####
# example from Visualize This - Nathan Yau
heatmap() #function in Base R

bball <- read_csv("http://datasets.flowingdata.com/ppg2008.csv") 

bball$Name <-  factor(bball$Name, levels = unique(bball$Name))
str(bball)

bball <- bball %>% 
        arrange(PTS)
#replace row names with bball names - deprecated with tibbles now but needed for heatmap function
bball <- column_to_rownames(bball, var = "Name")

#Convert data to matrix
bball_matrix <- data.matrix(bball)

library(RColorBrewer)
bball_heatmap <- heatmap(bball_matrix, Rowv = NA, Colv = NA, #Rowv/Colv = dendrogram turn off
                         col = brewer.pal(9, "Blues"),scale = "column", margins = c(5,10))  

#scales = column tells R to use the min & max of each column to determine color gradients instead of min and max of entire matrix


# Spatial data - maps ####
#using maps package
nz <- map_data("nz")
world <- map_data("world")

ggplot(nz, aes(long, lat, group = group)) +
        geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(long, lat, group = group)) +
        geom_polygon(fill = "white", color = "black") + 
        coord_quickmap()

ggplot(world, aes(long, lat, group = group)) +
        geom_polygon(fill = "white", color = "black") + 
        coord_quickmap()

# Example of more advanced mapping with Visualize This - Yau ####
library(maps)

# read in costco data of store locations around the US
costcos <- read.csv("http://book.flowingdata.com/ch08/geocode/costcos-geocoded.csv", sep = ",")

map(database = "state") #1st layer
symbols(costcos$Longitude, costcos$Latitude, circles = rep(1, length(costcos$Longitude)), inches = 0.05, add = TRUE) #adds 2nd layer but makes sure to put map down first
# all circles same size

# Clean up - Hawaii & AK use world map instead of state
map(database = "state", col = "#cccccc") #hexadecimal colors = light gray
symbols(costcos$Longitude, costcos$Latitude, bg = "#e2373f", fg = "white", lwd = 0.5, circles = rep(1, length(costcos$Longitude)), inches = 0.05, add = TRUE) 

# More info on hexadecimal color specification in R if curious: http://stat545.com/block018_colors.html

# Map for specific regions - may have to clear previous plots or use dev.off
map(database = "state", region = c("California", "Nevada", "Oregon", "Washington"), col = "#cccccc") #hexadecimal colors = light gray
symbols(costcos$Longitude, costcos$Latitude, bg = "#e2373f", fg = "white", lwd = 0.5, circles = rep(1, length(costcos$Longitude)), inches = 0.05, add = TRUE) 

#Bubble map - area of bubbles related to additional variable
#adolescent fertility rate worldwide

fertility <- read.csv("http://book.flowingdata.com/ch08/points/adol-fertility.csv")

map("world", fill = FALSE, col = "#cccccc")
symbols(fertility$longitude, fertility$latitude, circles = sqrt(fertility$ad_fert_rate), bg = "#93ceef", fg = "white", inches = 0.15, add = TRUE) 

#Square root of fertility rates mapped to area of circles

#Summary for legend
summary(fertility$ad_fert_rate)


# Export plots ####
#vector vs. raster
#Vector: PDF, SVG (scalable vector graphics)
#Raster: jpeg, png - don't scale well - look grainy when blown up

#Base R - read device
pdf("Name_of_figure.pdf") #tiff(), png()
plot(1:10)
dev.off #remove any formatting in plot window if packages have different defaults for plot window sizes

# ggplot - use ggsave
ggsave("Name of plot.file type", width=11, height=8.5) #width and height are in inches but can change

#will save most recent plot or can call specific one
#Can support pdf, jpeg, eps, tiff, png 

#scale - posters & slides: scale = 0.8

#Examples with scale
library(gapminder)
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
p1 <- p + ggtitle("scale = 0.6")
p2 <- p + ggtitle("scale = 2")
p3 <- p + ggtitle("base_size = 20") + theme_grey(base_size = 20)
p4 <- p + ggtitle("base_size = 3") + theme_grey(base_size = 3)
ggsave("img/fig-io-practice-scale-0.3.png", p1, scale = 0.6)
#> Saving 4.2 x 3 in image
ggsave("img/fig-io-practice-scale-2.png", p2, scale = 2)
#> Saving 14 x 10 in image
ggsave("img/fig-io-practice-base-size-20.png", p3)
#> Saving 7 x 5 in image
ggsave("img/fig-io-practice-base-size-3.png", p4)
#> Saving 7 x 5 in image

#Grid Extra example from Jenny Bryan
library(gridExtra)

p_dens <- ggplot(gapminder, aes(x = gdpPercap)) + geom_density() + scale_x_log10() +
        theme(axis.text.x = element_blank(),
              axis.ticks = element_blank(),
              axis.title.x = element_blank())
p_scatter <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
        geom_point() + scale_x_log10()

print(grid.arrange(p_dens, p_scatter, nrow = 2, heights = c(0.35, 0.65)))

#p_both <- arrangeGrob(p_dens, p_scatter, nrow = 2, heights = c(0.35, 0.65))
#print(p_both)

png(file="NAME_of_Plot.png")
print(grid.arrange(g_dyn,g_errbar,g_errbar2,g_point,g_boxplot,g_violin,
                   nrow=2))

# Multiplot function from R Graphics Cookbook - Winston Chang
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
        require(grid)
        
        # Make a list from the ... arguments and plotlist
        plots <- c(list(...), plotlist)
        
        numPlots = length(plots)
        
        # If layout is NULL, then use 'cols' to determine layout
        if (is.null(layout)) {
                # Make the panel
                # ncol: Number of columns of plots
                # nrow: Number of rows needed, calculated from # of cols
                layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                                 ncol = cols, nrow = ceiling(numPlots/cols))
        }
        
        if (numPlots==1) {
                print(plots[[1]])
                
        } else {
                # Set up the page
                grid.newpage()
                pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
                
                # Make each plot, in the correct location
                for (i in 1:numPlots) {
                        # Get the i,j matrix positions of the regions that contain this subplot
                        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
                        
                        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                                        layout.pos.col = matchidx$col))
                }
        }
}
multiplot(p1, p2, p3, p4, cols = 2)

#To save in binary format to preserve formatting for factors
saveRDS()

#to remove extra files
file.remove(list.files(pattern = "^gap_life_exp"))  #remove extra plots in environment all ending in gap_life_exp
