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

# Coordinate systems & Spatial Data ####
# Default coordinate system is Cartesian coordinates
coord_flip() #useful for horizontal boxplots or long labels

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
        geom_boxplot()+ 
        coord_flip()

coord_quickmap() #correct aspect ratio for maps

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

# Polar coordinates
coord_polar()


# Chernoff faces ####
install.packages("aplpack")
library(aplpack)

faces(x=as.matrix(cdata[ilifew,c(8,7,9,6,4,2,3)]),
      labels=as.character(cdata$name[ilifew]))


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

# Export plots ####
ggsave("Name of plot.file type", width=11, height=8.5) #width and height are in inches but can change

#will save most recent plot or can call specific one
#Can support pdf, jpeg, eps, tiff, png 

#Base R
pdf("Name_of_figure.pdf") #tiff(), png()
plot(1:10)
dev.off #remove any formatting in plot window if packages have different defaults for plot window sizes

#Grid Extra example
library(gridExtra)

#Jenny Bryan
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



# Dealing with factors ####
gapminder <- gapminder %>%
        mutate(country = factor(country),
               continent = factor(continent))