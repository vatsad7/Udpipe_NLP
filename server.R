#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(igraph)
library(ggraph)
library(ggplot2)




options(shiny.maxRequestSize = 40*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  set.seed=2092014 
   
  # You can access the value of the widget with input$file, e.g.
  #output$inputfile <- renderPrint({str(input$file)})
  #output$checkbox <- renderPrint({ input$checkGroup })
  
  textfile <- reactive({
    if (is.null(input$file1)) {return(NULL)}
    else {
      Document <- readLines(input$file1$datapath)
      corpus = readLines(Document)
      corpus  =  str_replace_all(corpus, "<.*?>", "")
      return(corpus)}
  })
  
  model_trained <- reactive({
    english_model = udpipe_load_model(input$model$datapath)  # file_model only needed
    # now annotate text dataset using ud_model above
    # system.time({   # ~ depends on corpus size
    x <- udpipe_annotate(english_model, x = english_model)#%>% as.data.frame() %>% head()
    x <- as.data.frame(x)
    return(x)
    })
  
  cooccurence_plot <- reactive ({
    text_colloc <- keywords_collocation(x = model_trained,   # try ?keywords_collocation
                                        term = "token",group = c("doc_id", "paragraph_id", "sentence_id"),
                                        ngram_max = 4) 
    text_cooc <- cooccurrence(# try `?cooccurrence` for parm options
      x = subset(model_trained, upos %in% c(input$checkGroup)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))
    
    wordnetwork <- head(text_cooc, 30)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    cooccurence_graph <- ggraph(wordnetwork, layout = "fr") +  
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      labs(title = "Cooccurrences within 3 words distance")
    return(cooccurence_graph)
    
  })
  
  output$plot1  <- renderPlot({
    cooccurence_plot    
    
    })
    })
