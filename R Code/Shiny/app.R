library(shiny)
library(ggplot2)
library(dplyr)
bcl <- read.csv("R Code/Shiny/bcl-data.csv", stringsAsFactors = FALSE)
#print(str(bcl)) # remove

#Step 1: Basic Set-up
ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

#Step 2: Add text
ui <- fluidPage("BC Liquor Store", "prices")
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

#Step 3: Format text
ui <-fluidPage(
        h1("My app"), #h1 = top level header, h2 = secondary header
        "BC",
        "Liquor",
        br(), #adds space between lines
        "Store",
        strong("prices") #strong = make text bold, em = make text italic
)

server <- function(input, output) {}
shinyApp(ui = ui, server = server)

#Step 4: Add official title and side bar layout
ui <- fluidPage(
        titlePanel("BC Liquor Store prices"), #Adds official website title - will show up as name of tab in browser
        sidebarLayout( # adds layout for sidebar
                sidebarPanel("our inputs will go here"),
                mainPanel("the results will go here")
        )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)
print(ui)
# Remember UI is all HTML - print(ui)

#Step 5: Add inputs to UI for price range - min & max with slider
#INPUT ID = priceInput, label = Price
# Set min and max price for $0-$100 and slider values at 25 and 40
ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, #Adds slider input 
                                         value = c(25, 40), pre = "$")), 
                mainPanel("the results will go here")
        )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

# Step 6: Add option to choose product type with Radio buttons and choose country from select box

ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel("the results will go here")
        )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

#Step 7: Add placeholder for where outputs (figure and table) will go

ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

#Step 8: Add outputs
ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)
server <- function(input, output) {
        output$coolplot <- renderPlot({
                plot(rnorm(input$priceInput[1])) #when choose new min price range, plot will update with new num. points
        })
        
}
shinyApp(ui = ui, server = server)

#server <- function(input, output) {
        output$coolplot <- renderPlot({
                ggplot(bcl, aes(Alcohol_Content)) + # switch to ggplot but changing input values no affect on plot yet
                        geom_histogram()
        })
        
#}

shinyApp(ui = ui, server = server)

#Step 9: Adjust plot so it reflects changes on input values
ui <- fluidPage(
       titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)

server <- function(input, output) {
        output$coolplot <- renderPlot({
                filtered <-
                        bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
                ggplot(filtered, aes(Alcohol_Content)) +
                        geom_histogram()
        })
        
}

shinyApp(ui = ui, server = server)

#Step 10: Add a table to output
ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)

server <- function(input, output) {
        output$coolplot <- renderPlot({
                filtered <-
                        bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
                ggplot(filtered, aes(Alcohol_Content)) +
                        geom_histogram()
        })
        output$results <- renderTable({
                filtered <-
                        bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
                filtered
        })
        
}

shinyApp(ui = ui, server = server)

# Step 11: Testing out "reactive" context and functions

ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)

server <- function(input, output) {
        output$coolplot <- renderPlot({
                filtered <-
                        bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
                ggplot(filtered, aes(Alcohol_Content)) +
                        geom_histogram()
        })
        output$results <- renderTable({
                filtered <-
                        bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
                filtered
        })
        #print(input$priceInput)# will throw error
         observe({print(input$priceInput)})
}

shinyApp(ui = ui, server = server)


# Step 12: Reduce code duplication by defining reactive variable to hold filtered dataset that we defined 2x

ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             selectInput("countryInput", "Country",
                                         choices = c("CANADA", "FRANCE", "ITALY"))), 
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)

server <- function(input, output) {
        filtered <- reactive({
                bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
        })
        
        output$coolplot <- renderPlot({
                ggplot(filtered(), aes(Alcohol_Content)) + #uses reactive variable
                        geom_histogram()
        })
        
        output$results <- renderTable({
                filtered() #uses reactive variable
        })
}

shinyApp(ui = ui, server = server)

# Step 13: Change country to call to uiOutput so you can create inputs dynamically and don't have to enter all of the countries manually

ui <- fluidPage(
        titlePanel("BC Liquor Store prices"),
        sidebarLayout(
                sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100, 
                                         value = c(25, 40), pre = "$"),
                             radioButtons("typeInput", "Product type",
                                          choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                          selected = "WINE"),
                             uiOutput("countryOutput")),
                mainPanel(plotOutput("coolplot"), #add placeholder for plot
                          br(), br(), #adds space between outputs
                          tableOutput("results")) #add placeholder for table
        )
)

server <- function(input, output) {
        filtered <- reactive({
                if (is.null(input$countryInput)) { # Removes error when trying to filter country input
                        return(NULL)
                }    
                
                bcl %>%
                        filter(Price >= input$priceInput[1],
                               Price <= input$priceInput[2],
                               Type == input$typeInput,
                               Country == input$countryInput
                        )
        })
        
        output$coolplot <- renderPlot({
                if (is.null(filtered())) { # Removes error when trying to filter country input
                        return()
                }
                ggplot(filtered(), aes(Alcohol_Content)) + #uses reactive variable
                        geom_histogram()
        })
        
        output$results <- renderTable({ #don't need the if statement here but tables are ok rendering NULL values
                filtered() #uses reactive variable
        
        })
        
        output$countryOutput <- renderUI({
                selectInput("countryInput", "Country",
                            sort(unique(bcl$Country)),
                            selected = "CANADA")
        })
        
}

shinyApp(ui = ui, server = server)
