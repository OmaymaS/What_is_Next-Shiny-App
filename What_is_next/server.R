## lLoad libraries ----------------------------
library(shiny)
library(shinydashboard)
library(data.table)
library(stringr)
library(tm)
library(shinyjs)

## read data --------------------------------
unig <- readRDS("gram1x.rds")
big <- readRDS("gram2x_minus1.rds")
trig <- readRDS("gram3x_minus1.rds")

## source functions -------------------------
source("functions/NextWord.R",local = T)
source("functions/TrigProb.R", local=T)

## What's Next Server -----------------------------
shinyServer(function(input, output, session) {

  ## setup ---------------------
  output$setupComplete <- reactive({
    return(TRUE)
  })

  outputOptions(output, 'setupComplete', suspendWhenHidden=FALSE)

  ## Next predicted words buttons ------------------
  output$my_button1 <- renderUI({actionButton("action1", class="act1",
                                              label = val()[1])})
  output$my_button2 <- renderUI({actionButton("action2", class="act1",
                                              label = val()[2])})
  output$my_button3 <- renderUI({actionButton("action3", class="act1",
                                              label = val()[3])})
  
  ## get next 3 predicted words ------------------------
  val <- reactive({
    ip <- input$sample1 %>% 
      trimws %>% 
      tolower

    if (is.na(ip)|ip=="") {
      k <- ""
      }
    else{
      # get last two words
      k <- paste(word(ip,-2),word(ip,-1),sep=" ") %>% 
        stripWhitespace()
    }
    # find next predicted word
    return (NextWord(k))
  })

  ## update next predicted words buttons -----------------------
  observeEvent(input$action1,{
    updateTextInput(session,
                    inputId = "sample1",value=paste(trimws(input$sample1),val()[1], sep=" "))
  })
  
  observeEvent(input$action2,{
    updateTextInput(session,
                    inputId = "sample1",value=paste(trimws(input$sample1),val()[2], sep=" "))
  })
  
  observeEvent(input$action3,{
    
    updateTextInput(session,
                    inputId = "sample1",value=paste(trimws(input$sample1),val()[3], sep=" "))
  })

  ## trigram probability tab infobox  --------------------------
  output$prob1 <- renderInfoBox({
    infoBox(
      paste("P(",word(trimws(input$trigram), -3, -1),")"),
      valTrigram(),
      width = "100%",
      icon = icon("calculator"),
      fill = T,
      color = if (is.numeric(valTrigram())) "green" else "red"
    )
  })
  
  ## get trigram probability -------------------------------------------
  valTrigram <- reactive({
    t3 <- input$trigram %>%
      trimws() %>%
      tm::stripWhitespace()

    p1 <- word(t3, -3, -1)
    
    # find trigarm probability
    x <- TrigProb(p1)
    return(x)

  })
})
