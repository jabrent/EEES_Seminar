# Data Visualizations

# Install Packages ####
library(tidyverse)

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
        theme_bw()

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
#bar plots - bin data & plot bin counts
#default stat = count

#To map value to y-aixs, use geom_col or geom_bar change stat to identity
#Change stat to prop as well
ggplot(data = mpg) +
        geom_col(mapping = aes(x = class, y = hwy)) 

ggplot(data = mpg) +
        geom_bar(mapping = aes(x = class, y = hwy), stat) 

View(mpg)

# Positions - dodge, or fill bars
ggplot(mpg, aes(class))+ 
        geom_bar(aes(fill = drv))
ggplot(mpg, aes(class))+ 
        geom_bar(aes(fill = drv), position = "fill")

# Historgram ####
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
        geom_histogram(binwidth = 0.25)

geom_freqpoly() #good for overlaying multiple histograms in same plot


#Diamond example
smaller <- diamonds %>% 
        filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
        geom_histogram(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
        geom_freqpoly(binwidth = 0.1)

# Replacing outliers with NA ####

#if else statements - 3 arguments
# 1. test = logical vector
# 2. result if test is TRUE
# 3. result if test is FALSE

diamonds2 <- diamonds %>% 
        mutate(y = ifelse(y < 3 | y > 20, NA, y))

# Box plots ####
#good for one categorical variable and one continuous variable
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
        geom_boxplot()

#change order
ggplot(data = mpg) +
        geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) + 
        #coord_flip()
#reorder = similar to factor(x, levels)
        
#2 categorical variables
# often use plot with count
        
#2 continuous variables - scatterplot
 
# Themes and Clean Plots ####
theme_bw(base_family = "Times")+
        theme(axis.title.x = element_text(size=18),
              axis.title.y = element_text(size=18),
              axis.text=element_text(size=16,colour ="black"))+
        theme(panel.border=element_blank(),
              axis.line = element_line(color="black"),
              plot.background = element_blank(),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())

#export
ggsave("All_lakes_mom_chla.pdf", width=11, height=8.5)

plot()
hist()
# R colors - Color Brewer

