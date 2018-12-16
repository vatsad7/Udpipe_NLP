#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Udpipe - Natural Language Processing"),
  sidebarLayout( 
    sidebarPanel(  
  #Upload data
  fileInput("file1", "Upload any text file for analysis",multiple = FALSE,
            accept = c("text",
                       "text/plain",
                       ".txt")), 
  
  tags$hr(),
  
  #Upload data
  fileInput("file2", "Upload any udpipe trained model file for any language",multiple = FALSE), 
  
  tags$hr(),
  
  #Part of Speech Checkboxes
  checkboxGroupInput("checkGroup", label = h4("XPOS Selection"), 
                     choices = list("Adjective" = 1, "Noun" = 2, "Proper Noun" = 3,"Adverb" = 4,"Verb"=5),
                     selected = list(1,2,3)),
  
  tags$hr(),
  
  submitButton(text = "Apply Changes", icon("refresh"))
  ),  
  
  #########################
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Overview",
                         h4(p("Data input")),
                         p("This app supports only text file",align="justify"),
                         p("Please refer to the link below for sample text file."),
                         a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                           ,"Sample data input file"),   
                         br(),
                         h4('How to use this App'),
                         p('To use this app, click on', 
                           span(strong("Upload any text file for analysis")),
                           'and upload the text file. You can upload an udpipe file for different languages and also modify the Part of Speech'),
                verbatimTextOutput("start")),  
                
                tabPanel("Co-occurence plot", 
                         plotOutput('plot1')
                         )
    ))# end of tabsetPanel
  )# end of main panel
)
)