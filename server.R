library(shiny)
library(shinythemes)
library(tm)
library(FNN)
library(SnowballC)
library(plotly)
library(sqldf)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
df <- read.csv('HT.csv')
shinyServer(function(input,output){
 rec_form <- reactive({
  dm<- df
  dm2 <- dm[,c('Position','Clean_Description')]
  tmp <- data.frame(Position='Guess',Clean_Description=input$text)
  dm2 <- rbind(tmp,dm2)
  corpus <- Corpus(VectorSource(dm2$Clean_Description))
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, stemDocument, language="english")  
  terms <-DocumentTermMatrix(corpus,control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE)))
  mat.df <- as.data.frame(data.matrix(terms), stringsAsfactors = FALSE)
  for(i in 1:length(mat.df[1,])){
    if(mat.df[1,i]!=0){
      mat.df[1,i]<-mat.df[1,i]*500
    }
  }
  k<-knn(mat.df[2:length(dm2[,1]),],mat.df[1,],dm2$Position[2:length(dm2[,1])],k = 5)
  indices <- attr(k, "nn.index")
  frame <- dm[indices,]
  frame
   })
 
  output$dt<- renderDataTable({
    input$go
    isolate(
    rec_form()[,c(1,2,10:12,19)])
  })
  
  
  dashboard <- reactive({
    
    lst<- c(as.character(input$bg1),as.character(input$bg2))
    index <- c()
    for(i in 1:length(df[,1])){
      lst2 <- c(as.character(df[i,3]),as.character(df[i,4]),as.character(df[i,5]),as.character(df[i,6]),as.character(df[i,7]),as.character(df[i,8]))
      cc<- length(c(lst2 %in% lst)[c(lst2 %in% lst)==TRUE])
      if(cc>0){
       index <- c(index,i)
  }
    }
    
  frame <- df[index,]
  frame
  })
  output$plot1<-renderPlotly({
    data <- dashboard()[,c(3:8)]
    BG<-c()
    lst <- c(input$bg1,input$bg2)
    for(i in 1:length(data[,1])){
      for(j in 1:length(data[1,])){
        if(data[i,j] %in% lst!=TRUE && is.na(data[i,j])!=TRUE ){
          BG<-c(BG,as.character(data[i,j]))
        }
      }
    }
    BG<- data.frame(Extra_Background = BG)
    BG<- sqldf('SELECT Extra_Background,count(Extra_Background) as Count from BG group by Extra_Background')
    p <- plot_ly(
      x = BG[,1],
      y = BG[,2],
      name = "Extra Background Except for Your Background",
      type = "bar"
    )
    
    p
  })
  output$plot2<-renderPlotly({
    data <- dashboard()[,11]
    data <- data.frame(Experience = data)
    data <- sqldf('Select Experience, count(Experience) as Count from data group by Experience')
    p<-plot_ly(data,labels = ~Experience, values = ~Count) %>%
      add_pie(hole = 0.6) %>%
      layout(title = "Donut charts of Required Experience",  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    p
  })
 
  output$plot3 <- renderPlotly({
     data <- dashboard()[,'Company']
     data <- data.frame(Company = data)
     data <- sqldf('Select Company, count(Company) as Count from data group by Company order by Count desc')
     p <- plot_ly(
       x = data[,1],
       y = data[,2],
       name = "Companies that want to recruit people with your background",
       type = "bar"
     )
     
     p
    
    
  })
  
  output$plot4 <- renderPlotly({
    data <- dashboard()[,'Location']
    data <- data.frame(Location = data)
    data <- sqldf('Select Location, count(Location) as Count from data group by Location')
    p<-plot_ly(data,labels = ~Location, values = ~Count) %>%
      add_pie() %>%
      layout(title = "Pie charts of Company's Location",  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    p
    
  })
  
  output$plot5<-renderPlotly({
    LG <- c()
    data <- dashboard()[,c(14:18)]
    for(i in 1:length(data[,1])){
      for(j in 1:length(data[1,])){
        if(data[i,j]!='English' && is.na(data[i,j])!=TRUE ){
          LG<-c(LG,as.character(data[i,j]))
        }
      }
    }
    LG<- data.frame(Extra_Language = LG)
    LG<- sqldf('SELECT Extra_Language,count(Extra_Language) as Count from LG group by Extra_Language')
    p <- plot_ly(
      x = LG[,1],
      y = LG[,2],
      name = "Extra Language Required for the positions matching your Background",
      type = "bar"
    )
    
    p
  })
  
  output$plot6 <- renderPlotly({
    
    
    data <- dashboard()[,'Degree']
    data <- data.frame(Degree = data)
    data <- sqldf('Select Degree, count(Degree) as Count from data group by Degree')
   p<- plot_ly(data,labels = ~Degree, values = ~Count) %>%
      add_pie() %>%
      layout(title = "Pie charts of Minimum Degree Requirement",  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  p
    
  })
  
  output$plot7 <- renderPlot({
    dt <- dashboard()
    corpus <- Corpus(VectorSource(dt$Clean_Description))
    corpus<- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus,content_transformer(tolower))
    terms <-TermDocumentMatrix(corpus)
    mat.df <- as.data.frame(data.matrix(terms), stringsAsfactors = FALSE)
    ap.v <- sort(rowSums(mat.df),decreasing=TRUE)
    ap.d <- data.frame(word = names(ap.v),freq=ap.v)
    pal2 <- brewer.pal(8,"Dark2")
    ap.d <- ap.d[ap.d$freq>=300,]
    wordcloud(ap.d$word,ap.d$freq, scale=c(4,0.5),max.words=Inf,random.order=FALSE, rot.per=0.15, colors=pal2)
    
  
    
  })
  
  
})
