#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Baby Names Dashboard",
               tabPanel("Analysis",
                        fluidPage(
                            titlePanel("Most Popular Baby Names"),
                            sidebarLayout(
                                sidebarPanel(
                                    selectInput("gender", "Select the Gender:",
                                                c("Female" = "F","Male" = "M")),
                                    sliderInput("year","Select the Year:", min = 1880, max = 2017, value = 1900),
                                    checkboxInput("both", "Show Both Genders", FALSE),
                                    checkboxInput("allY", "Show All Years", FALSE)
                                ),
                                
                                mainPanel(
                                    h3(textOutput("caption")),
                                    
                                    tabsetPanel(type = "tabs", 
                                                tabPanel("Graphic", plotOutput("bygenGraph")),
                                                tabPanel("Data Base", DT::DTOutput("tableOutput"))
                                    )
                                )
                            )
                        )
               ),
               tabPanel("Babynames Data Set",
                        
                        h3("US Baby Names 1880-2017"),
                        helpText("Full baby names provided by the SSA. This includes all names with at least 5 uses."),
                        h3("Format"),
                        p("A data frame with five variables: year, sex, name, n and prop (n divided by the total number of applicants in 
                          that year, which means proportions are of people of that gender with that name born in that year)."),
                        
                        a("https://cran.r-project.org/web/packages/babynames/babynames.pdf")
               ),
               tabPanel("Github Repository",
                        a("https://github.com/manastiwari/Developing-Data-Products-Week-4-Course-Project"),
                        hr(),
                        h4("I hope you like the Shiny App"),
                        h4("The name of the repository is Developing Data Products Week 4 Course Project")
               )
    )
)