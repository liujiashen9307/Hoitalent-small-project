library(shiny)
library(shinythemes)
library(plotly)
library(wordcloud)
dt <- read.csv('HT.csv')
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
bg <- read.csv('Background.csv')[c(2:16,19),1]
bg<- as.character(bg)
shinyUI(fluidPage(theme = shinytheme("superhero"),
                  titlePanel(h3(strong('Find the position you may be interested in'))),
                  sidebarPanel(
                    conditionalPanel('input.tab=="Dashboard"',
                    h4('Choose two of your background'),
                    selectInput('bg1','Background 1',choices = bg,selectize = TRUE),
                    selectInput('bg2','Background 2',choices = bg,selected = bg[7],selectize = TRUE)
                    ),
                    
                    conditionalPanel('input.tab=="Position Recommendation"',
                    
                  
                    h4('Key words of your dreamed job'),
                    textInput('text',label = 'Use space to seperate different words. More words you provide, more accurate the algorithm will be.',value ='Data Python Machine Learning',placeholder = 'Please type in the key words of your dream job, and we will match the most suitable job for you',width = '600px'),
                    actionButton("go", "Find the Position")
                    ),
                    conditionalPanel('input.tab=="About"',
                    h4('Contact Author'),
                    br()
                    
                                     
                                     
                                     )
                    
                  ),
                  mainPanel(
                    tabsetPanel(
                      id='tab',
                      tabPanel('Dashboard',
                               h4('Extra Education Background and Experience'),
                               splitLayout(cellwidths=c("50%","50%"),plotlyOutput("plot1"),plotlyOutput("plot2")),
                               splitLayout(cellwidths=c("50%","50%"),plotlyOutput("plot3"),plotlyOutput("plot4")),
                               splitLayout(cellwidths=c("50%","50%"),plotlyOutput("plot5"),plotlyOutput("plot6"))
                               
                               
                               ),
                      tabPanel('Position Recommendation',
                              h4('TOP 5 Positions picked by the words you typed in'),
                              dataTableOutput('dt')
                               
                               
                               ),
                      tabPanel('About')
                      
                    )
                    
                  )
                  
                  
                  
                  
                  
                  
                  
                  ))