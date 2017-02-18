## What's Next UI --------------------------------------------
ui <- dashboardPage(
  dashboardHeader(title = "What's Next"),
  ## Dashboard side bar ------------------------------------
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about"),
      menuItem("Next Word Prediction", tabName = "next_word"),
      menuItem("Trigram Probability", tabName = "trigram_model")
    )
  ),
  
  ## Dasboard body -------------------------------------------
  dashboardBody(
    ### Tags ---------------------------
    tags$head(tags$style('.act1 {width: 100%;margin: 4px 2px;
                                                    background-color: #4CAF50;color: white}')),
    
    tags$script(HTML("var openTab = function(tabName){$('a', $('.sidebar')).each(function() {
                     if(this.getAttribute('data-value') == tabName) {
                     this.click()
                     };
                     });
                     }
                     ")),
    
    
    ### Tab items -------------------------------
    tabItems(
      #### tab about ---------------------------
      tabItem("about",
              
              # description
              fluidRow(
                box(width=12,
                    h1("About What's Next",
                       style = "font-size: 150% ; font-weight: bold "),
                    tags$div("What's Next is an application that uses natural language models for text prediction. The application uses Katz's Backoff model with Good Turing estimate, providing two options:",
                             tags$br(),
                             tags$li("Next Word Prediction: gives the user the top predicted words according to the input."),
                             tags$li("Trigram Probability: gives the user the probability of a given trigram"),
                             tags$br(),
                             tags$strong("Try it now!") , style = "font-size: 120%"
                    ))
                
              ),
              
              # infoboxes with links
              fluidRow(
                # infobox Next Word Prediction
                infoBox(
                  tags$p("Next Word Prediction",
                         style = "font-size: 150%"),
                  a("Start", onclick = "openTab('next_word')",
                    style="cursor: pointer; font-size: 100%;"),
                  icon=icon("keyboard-o"),
                  color="aqua",
                  width = 6,
                  fill=T
                ),
                
                # infobox Trigram Probability
                infoBox(
                  # "Trigram Probability",
                  tags$p("Trigram Probability",
                         style = "font-size: 150%"),
                  a("Start", onclick = "openTab('trigram_model')",
                    style="cursor: pointer; font-size: 100%;"),
                  width = 6,
                  color="aqua",
                  fill=T
                )
              )
      ),
      
      #### tab next_word -----------------------------------
      tabItem("next_word",
              fluidRow(
                # infobox in Next Word Prediction tab
                infoBox(
                  tags$p("Next Word Prediction",
                         style = "font-size: 200%;"),
                  width = 12,
                  color="aqua",
                  fill=T,
                  icon=icon("keyboard-o"))
              ),
              
              fluidRow(
                # Next Word Prediction tab content
                conditionalPanel(
                  condition="output.setupComplete",
                  box(title="Input text",
                      textAreaInput("sample1", label=NULL,
                                    value = "here we",
                                    resize = "vertical"), 
                      width=8,
                      height = "200px")
                ),
                
                conditionalPanel(
                  condition = "!output.setupComplete",
                  box( title = "loading...",
                       width=12
                  )
                ),
                
                conditionalPanel(
                  condition="output.setupComplete",
                  box(title="Top Predicted Words",
                      
                      uiOutput("my_button1"),
                      uiOutput("my_button2"),
                      uiOutput("my_button3"),
                      width = 4,
                      align="center",
                      height = "200px"))
              )
      ),
      
      #### tab trigram_model ------------------------------------
      tabItem("trigram_model",
              fluidRow(
                # infobox in Trigram Probability tab
                infoBox(
                  tags$p("Trigram Probability",
                         style = "font-size: 200%;"),
                  width = 12,
                  color="aqua",
                  fill=T)
                
              ),
              fluidRow(
                # Trigram Probability tab content
                conditionalPanel(
                  condition = "!output.setupComplete",
                  box( title = "loading...",
                       width=12
                  )
                ),
                
                conditionalPanel(
                  condition="output.setupComplete",
                  box(title=NULL,
                      textInput("trigram", label="Trigram",
                                value = "here we go"), 
                      width=6)
                  ),
                
                
                conditionalPanel(
                  condition="output.setupComplete",
                  infoBoxOutput("prob1", width = 6))
                )
      )
    )
  )
)


