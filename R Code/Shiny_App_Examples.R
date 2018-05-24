#### Shiny App Brief Tutorial ####
# Created by JAB May 2018 for EEES Seminar
# Available on github class respository: https://github.com/jabrent/EEES_Seminar
# Example from Jenny Bryan - written by Dean Attali: http://stat545.com/shiny01_activity.html
# R Studio shiny tutorial: http://shiny.rstudio.com/tutorial/
# Final app: https://daattali.com/shiny/bcl/

# Install packages ####
install.packages("shiny")
library(shiny)

# Other useful pacakges

shinythemes #alter the appearance
shinyjs #use JavaScript functions without knowning JavaScript
leaflet #add interactive maps
ggivs #similar to ggplot but more interactive
shinydashboard #tools for creating visual "dashboards"

# Test example - see more examples at: ShowMeShiny.com
runExample("01_hello")

# Example of basic Shiny app for Yellowstone Old Faithful geyser eruptions

# Define UI for app that draws a histogram ----
ui <- fluidPage(
        
        # App title ----
        titlePanel("Hello Shiny!"),
        
        # Sidebar layout with input and output definitions ----
        sidebarLayout(
                
                # Sidebar panel for inputs ----
                sidebarPanel(
                        
                        # Input: Slider for the number of bins ----
                        sliderInput(inputId = "bins",
                                    label = "Number of bins:",
                                    min = 1,
                                    max = 50,
                                    value = 30)
                        
                ),
                
                # Main panel for displaying outputs ----
                mainPanel(
                        
                        # Output: Histogram ----
                        plotOutput(outputId = "distPlot")
                        
                )
        )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
        
        # Histogram of the Old Faithful Geyser Data ----
        # with requested number of bins
        # This expression that generates a histogram is wrapped in a call
        # to renderPlot to indicate that:
        #
        # 1. It is "reactive" and therefore should be automatically
        #    re-executed when inputs (input$bins) change
        # 2. Its output type is a plot
        output$distPlot <- renderPlot({
                
                x    <- faithful$waiting
                bins <- seq(min(x), max(x), length.out = input$bins + 1)
                
                hist(x, breaks = bins, col = "#75AADB", border = "white",
                     xlab = "Waiting time to next eruption (in mins)",
                     main = "Histogram of waiting times")
                
        })
        
}

shinyApp(ui, server)

# Primary components of shiny app:
# 1. User interface - design layout of app using HTML coding you write using Shiny's functions
# 2. Server - logic of the app, instructions for web page

# Create a template with the following code and name the file app.R and make sure the R script is in it's own folder

library(shiny)
ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

# Caution - order matters! make sure ui call is followed by server and then final shinyApp call 

#Can also create separate ui.R and server.R files in same folder for more complicated apps

#Run app is using:
runApp()

# User Interface - Add inputs:
#The entire UI will be built by passing comma-separated arguments into the fluidPage() function. By passing regular text the web page will just render boring unformatted text.

# If we want our text to be formatted nicer, Shiny has many functions that are wrappers around HTML tags that format text. We can use the h1() function for a top-level header (<h1> in HTML), h2() for a secondary header (<h2> in HTML), strong() to make text bold (<strong> in HTML), em() to make text italicized (<em> in HTML), and many more.

#br() for a line break, img() for an image, a() for a hyperlink, and others.

#sidebarLayout() to add a simple structure. It provides a simple two-column layout with a smaller sidebar and a larger main panel. We’ll build our app such that all the inputs that the user can manipulate will be in the sidebar, and the results will be shown in the main panel on the right.

#Inputs = gives users a way to interact with a Shiny app, every input must have a unique inputId

#textInput() is used to let the user enter text, numericInput() lets the user select a number, dateInput() is for selecting a date, selectInput() is for creating a select box (aka a dropdown menu).

#All input functions have the same first two arguments: inputId and label.

# Add placeholders for outputs:
#After creating all the inputs, we should add elements to the UI to display the outputs. Outputs can be any object that R creates and that we want to display in our app - such as a plot, a table, or text. We’re still only building the UI, so at this point we can only add placeholders for the outputs that will determine where an output will be and what its ID is, but it won’t actually show anything. Each output needs to be constructed in the server code later.

# Adding logic to server function
#If you look at the server function, you’ll notice that it is always defined with two arguments: input and output. You must define these two arguments! Both input and output are list-like objects. As the names suggest, input is a list you will read values from and output is a list you will write values to. input will contain the values of all the different inputs at any given time, and output is where you will save output objects (such as tables and plots) to display in your app.

#There are three rules to build an output in Shiny:

#1. Save the output object into the output list (remember the app template - every server function has an output argument)
#2. Build the object with a render* function, where * is the type of output
#3. Access input values using the input list (every server function has an input argument)

# Reactive programming in Shiny

# Typically R values don't change unless you redefine a variable. for example:
x <- 5
y <- x + 1
x <- 10

# y = 6 but in reactive programming y would be equal to 11 if that is the last value of x that is set
# In Shiny, all inputs are reactive - code gets re-excuted with new input values each time they change - any render functions, reactive, and observe but have to be in reactive context

#If you want to access a reactive variable defined with reactive({}), you must add parentheses after the variable name, as if it’s a function. 

#As a reminder, Shiny creates a dependency tree with all the reactive expressions to know what value depends on what other value. For example, when the price input changes, Shiny looks at what values depend on price, and sees that filtered is a reactive expression that depends on the price input, so it re-evaluates filtered. Then, because filtered is changed, Shiny now looks to see what expressions depend on filtered, and it finds that the two render functions use filtered. So Shiny re-executes the two render functions as well.

# How to make your shiny accessible on web

#RStudio provides a service called shinyapps.io which lets you host your apps for free. It is integrated seamlessly into RStudio so that you can publish your apps with the click of a button, and it has a free version. The free version allows a certain number of apps per user and a certain number of activity on each app, but it should be good enough for most of you. It also lets you see some basic stats about usage of your app.

#Hosting your app on shinyapps.io is the easy and recommended way of getting your app online. Go to www.shinyapps.io and sign up for an account. When you’re ready to publish your app, click on the “Publish Application” button in RStudio and follow their instructions. You might be asked to install a couple packages if it’s your first time.

