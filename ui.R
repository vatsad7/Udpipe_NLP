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
  fileInput("file", "Upload any text file for analysis"), 
  
  tags$hr(),
  
  selectInput("select", label = h3("Select box"), 
              choices = list("English" = "english", "Spanish" = "spanish", "Hindi" = "hindi"), 
              selected = "english"),
  
  hr(),
  
  #Part of Speech Checkboxes
  checkboxGroupInput("checkGroup", label = h4("UPOS Selection"), 
                     choices = list("Adjective" = "ADJ", "Noun" = "NOUN", "Proper Noun" = "PROPN","Adverb" = "ADV","Verb"="VERB"),
                     selected = c("ADJ","NOUN","PROPN")),
  #fluidRow(column(5, verbatimTextOutput("checkbox"))),
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
                         a(href="https://raw.githubusercontent.com/vatsad7/Udpipe_NLP/master/sample.txt"
                           ,"Sample data input file"),   
                         br(),
                         h4('How to use this App'),
                         p('To use this app, click on', 
                           span(strong("Upload any text file for analysis")),
                           'and upload the text file. You can select any language from the dropdown menu and also modify the Part of Speech'),
                        p('App also creates word clouds for different parts of speech'),
                                         verbatimTextOutput("start")),  
                
                tabPanel("Udpipe Models",
                         (p("Refer to the below links for Udpipe models in different languages")),
                          a(href="https://github.com/vatsad7/Udpipe_NLP/blob/master/english-ud-2.0-170801.udpipe?raw=true
                            ","English --> Udpipe Model"),
                          br(),
                          a(href="https://github.com/vatsad7/Udpipe_NLP/blob/master/hindi-ud-2.0-170801.udpipe?raw=true","Hindi --> Udpipe Model")
                         ),
                tabPanel("Co-occurence plot", 
                         plotOutput('plot1')
                         ),
                
                tabPanel("Word Clouds",
                         h3("Adjective"),
                         plotOutput('wc1'),
                         h3("Noun"),
                         plotOutput('wc2'),
                         h3("Proper Noun"),
                         plotOutput('wc3'),
                         h3("Adverb"),
                         plotOutput('wc4'),
                         h3("Verb"),
                         plotOutput('wc5'))
    ))# end of tabsetPanel
  )# end of main panel
)
)
