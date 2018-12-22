#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

##################
#Name: Abhilash Mishra
#PGID 11810021
#Name: Suryakant Mohanty
#PGID 11810045
#Name : Shubhendra Singh Vatsa
#PGID 11810059
##################

library(shiny)
library(igraph)
library(ggraph)
library(ggplot2)
library(udpipe)
library(stringr)

options(shiny.maxRequestSize = 40*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  set.seed=2092014 
   
  # You can access the value of the widget with input$file, e.g.
  #output$inputfile <- renderPrint({str(input$file)})
  #output$checkbox <- renderPrint({ input$checkGroup })
  
  text_file <- reactive({
    if (is.null(input$file)) {return(NULL)}
    else {
      Document <- readLines(input$file$datapath)
      
      corpus  =  str_replace_all(Document, "<.*?>", "")
            return(corpus)
      }
  })
  model <- reactive({
    x <- udpipe_download_model(input$select, model_dir = tempdir())
    return(x$file_model)
  })
  
  
  english_model <- reactive  ({
    english_model <- udpipe_load_model(model())  # file_model only needed
    return(english_model)
     } )
  
  annotation_function <- reactive({
    
    udp <- udpipe_annotate(english_model(), text_file())#%>% as.data.frame() %>% head()
    udp <- as.data.frame(udp)
    return(udp)
    })
  
  output$plot1  <- renderPlot ({
        text_cooc <- cooccurrence(# try `?cooccurrence` for parm options
        x = subset(annotation_function(), upos %in% c(input$checkGroup)), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      wordnetwork <- head(text_cooc, 30)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        labs(title = "Cooccurrences within 3 words distance")  
          })
  
  output$wc1 <-  renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_adjectives = annotation_function() %>% subset(., upos %in% "ADJ") 
      top_adjectives = txt_freq(all_adjectives$lemma)  # txt_freq() calcs noun freqs in desc order
      wordcloud(top_adjectives$key,top_adjectives$freq, min.freq = 3,colors = 1:10 )
    }})
  output$wc2 <-  renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_nouns = annotation_function() %>% subset(., upos %in% "NOUN") 
      top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3,colors = 1:10 )
    }})
  
  output$wc3 <-  renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_proper_noun = annotation_function() %>% subset(., upos %in% "PROPN") 
      top_proper_nouns = txt_freq(all_proper_noun$lemma)  # txt_freq() calcs noun freqs in desc order
      wordcloud(top_proper_nouns$key,top_proper_nouns$freq, min.freq = 3,colors = 1:10 )
    }})
  output$wc4 <-  renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_adverbs = annotation_function() %>% subset(., upos %in% "ADV") 
      top_adverbs = txt_freq(all_adverbs$lemma)  # txt_freq() calcs noun freqs in desc order
      wordcloud(top_adverbs$key,top_adverbs$freq, min.freq = 3,colors = 1:10 )
    }})
  output$wc5 <-  renderPlot({
    if(is.null(input$file)){return(NULL)}
    else{
      all_verbs = annotation_function() %>% subset(., upos %in% "VERB") 
      top_verbs = txt_freq(all_verbs$lemma)  # txt_freq() calcs noun freqs in desc order
      wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10 )
    }})
  })
