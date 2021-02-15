#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(babynames)
library(dplyr)
library(ggplot2)

# Define server logic required to draw a histogram
auxBaby <- babynames

shinyServer(function(input, output) {
    
    formulaText <- reactive({
        auxGender <- if(input$gender == "F") "Female" else "Male"
        if(input$both){auxGender <- ""}
        auxYear <- paste("in ",input$year)
        if(input$allY){auxYear <- "from 1880 to 2017"}
        paste("Top 10 ", auxGender, "Baby Names ", auxYear)
    })
    
    output$caption <- renderText({
        formulaText()
    })
    
    output$bygenGraph <- renderPlot({
        
        auxNames <- auxBaby
        if(input$allY){
            if(input$both){
                auxNames <- auxBaby %>% select(name, prop) %>% arrange(desc(prop)) %>% distinct(name, .keep_all = TRUE)
            }else{
                auxNames <- auxBaby %>% filter(sex == input$gender) %>% select(name, prop) %>% arrange(desc(prop)) %>% distinct(name, .keep_all = TRUE)
            }
        }else{
            if(input$both){
                auxNames <-  auxBaby %>% filter(year == input$year)
            }else{
                auxNames <- auxBaby %>% filter(sex == input$gender, year == input$year)
            }
        }
        auxNames <- auxNames %>% top_n(10, prop) %>% arrange(desc(prop))
        
        auxCol <- if(input$gender == "F") "coral2" else "darkblue"
        if(input$both) {auxCol <- "darkred"}
        
        ggplot(auxNames, aes(reorder(name, -prop, sum),prop)) + 
            geom_col(color = auxCol, fill = auxCol, width = .8) +
            labs(x = "Name", y = "Proportion") +
            scale_y_continuous(labels = scales::percent) +
            theme(axis.title = element_text(size = 15),axis.text = element_text(size = 10, face = "bold", color = auxCol))
        
    })
    
    output$tableOutput <- DT::renderDT({
        auxNames <- auxBaby
        if(input$allY){
            if(input$both){
                auxNames <- auxBaby %>% select(name, prop) %>% arrange(desc(prop)) %>% distinct(name, .keep_all = TRUE)
            }else{
                auxNames <- auxBaby %>% filter(sex == input$gender) %>% select(name, prop) %>% arrange(desc(prop)) %>% distinct(name, .keep_all = TRUE)
            }
        }else{
            if(input$both){
                auxNames <-  auxBaby %>% filter(year == input$year)
            }else{
                auxNames <- auxBaby %>% filter(sex == input$gender, year == input$year)
            }
        }
        auxNames <- auxNames %>% top_n(10, prop) %>% arrange(desc(prop))
    })
    
})
