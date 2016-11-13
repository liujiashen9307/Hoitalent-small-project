library(shiny)
library(shinythemes)
library(plotly)
library(wordcloud)
dt <- read.csv('HT.csv')
bg <- read.csv('Background.csv')[c(2:16,19),1]
bg<- as.character(bg)
shinyUI(fluidPage(theme = shinytheme("sandstone"),
                  titlePanel(h3(strong('Find the position you may be interested in'))),
                  sidebarPanel(
                    conditionalPanel('input.tab=="Dashboard"',
                    h4("Description"),
                    p(h5('By selecting two of your most matched backgrounds, you can check:')),
                    p(h5('a. What extra backgrounds do positions you can apply need')),
                    p(h5('b. Which company may be your potential employer?')),
                    p(h5('c. Which language skills you better have for being more competitive ')),
                    p(h5('d. How many years of experience and degree you better have')),
                    p(h5('e. What are the key words in the job description?')),
                    br(),
                    h4('Choose two of your background'),
                    selectInput('bg1','Background 1',choices = bg,selectize = TRUE),
                    
                    selectInput('bg2','Background 2',choices = bg,selected = bg[7],selectize = TRUE)
                    
                    
                    ),
                    
                    conditionalPanel('input.tab=="Position Recommendation"',
                    
                    h4('Description'),
                    p(h5('This part can be used as a simple search engine based on the content in job description')),
                    br(),
                    p('However, it is also a prototype of personalized recommender. If one gets the full data set of the browsing history of all users, he or she can use the similar model to make a recommendation to a specific user based on his or her background, education, language, experience and browsing history.'),
                    
                    br(),
                   
                    p('Type in the words and click "Find the Position"'),
                    br(),
                    h4('Key words of your dreamed job'),
        
                    textInput('text',label = 'Use space to seperate different words. More words you provide, more accurate the algorithm will be. Default keywords are provided below already.',value ='Data Python Machine Learning',placeholder = 'Please type in the key words of your dream job, and we will match the most suitable job for you.',width = '600px'),
                    actionButton("go", "Find the Position")
                    ),
                    conditionalPanel('input.tab=="About"',
                    h4('Contact Author'),
                    p(h5('Jiashen Liu')),
                    p(h5('Graduate of Rotterdam School of Management, Erasmus Univerisity')),
                    p(
                      a(h5("LinkedIn"),href="https://nl.linkedin.com/in/jiashen-liu-4658aa112",target="_blank"),
                      a(h5("Github"),href="https://github.com/liujiashen9307/",target="_blank"),
                      a(h5("Kaggle"),href="https://www.kaggle.com/jiashenliu",target="_blank")
                      
                      
                    )
          
                                     
                                     
                                     )
                    
                  ),
                  mainPanel(
                    tabsetPanel(
                      id='tab',
                      tabPanel('Dashboard',
                               h4('A: Explore the extra background and required experience'),
                               splitLayout(cellwidths=c("50%","50%"),plotlyOutput("plot1"),plotlyOutput("plot2")),
                               h4('B: Explore the potential employer and location of company'),
                               splitLayout(cellwidths=c("50%","50%"),plotlyOutput("plot3"),plotlyOutput("plot4")),
                               h4('C: Explore required languages and degree requirement'),
                               splitLayout(cellwidths=c("50%","50%"),plotlyOutput("plot5"),plotlyOutput("plot6")),
                               h4("D: Briefly explore what terms are in Job Description"),
                               plotOutput('plot7')
                               ),
                      tabPanel('Position Recommendation',
                              h4('TOP 5 Positions picked by the words you typed in'),
                              dataTableOutput('dt')
                               
                               
                               ),
                      tabPanel('About',
                               h4("Overall"),
                               p('Two parts of contents are included in this small project. The first one serves as the visualization of data set while the second part, which implements a KNN model, builds a small recommendation system based on the key words you type in',align='Justify'),
                               h4('Data Source'),
                               p("All data are from Hoitalent.com , the largest job portal for English Jobs in the Netherlands",align='Justify'),
                               h4('Packages Used'),
                               p("Python Packages: bs4, requests, pandas."),
                               p("R Packages: Shiny, Shinythemes, plotly, wordcloud, FNN,tm, snowballC,sqldf,ggplot2, and RColorBrewer",align='Justify'),
                               h4("Link of Code"),
                               p('If you are interested, you can find both the web scraping script and Shiny Scripts in the below github link.',align='Justify'),
                               a(h5("Click me for the Code"),href="https://github.com/liujiashen9307/Hoitalent-small-project",target="_blank")
                               
                               
                               )
                      
                    )
                    
                  )
                  
                  
                  
                  
                  
                  
                  
                  ))