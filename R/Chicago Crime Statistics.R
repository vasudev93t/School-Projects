#SIP 1 

library(tidyverse)
library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(mice)
library(leaflet)
library(sp)


#Load data
crimes <- read_csv("Crimes_2020.csv")

#Basic Data Checks
dim(crimes)
str(crimes)


#Checking for missing values
p <- function(x) {sum(is.na(x))/length(x)*100}
apply(crimes, 2, p)
sum(is.na(crimes))


#Visual Representation
md.pattern(crimes) # Majority of missing values are from the longitude,latitude columns and x & y cord columns

library(VIM)
aggr_plot <- aggr(crimes, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(crimes), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))


#From the data inspection we can see that majority of the missing values are for the Geographical Features,
#Since we they are missing at random and we cannot impute them, we will drop this columns 

df<- na.omit(crimes)

sum(is.na(df))  # O missing data 
apply(df, 2, p)



#Removing Space from column name
colnames(df) <- gsub(" ", "", colnames(df))
colnames(df)



#Checking if data type of Date Column
class(df$Date)

#Converting Date columns to DateTime format
df$DateTime <- strptime(df[["Date"]], format = "%m/%d/%Y %H:%M" )
class(df$DateTime)

df$Date <- as.Date(df[["Date"]], format = "%m/%d/%Y")
class(df$Date)

#Creatinga Month Column
df$Month <- strftime(df$DateTime,"%m")
class(df$Month)


#Extracting Time from datetime
df$Time <- strftime(df$DateTime, format = "%H")

# Recheck for missing values after parsing date time.
sum(is.na(df))  
apply(df, 2, p)

#As the inputs missing are date-time that cannot be simply imputed, we will drop them
df<- na.omit(df)
sum(is.na(df))

#Adding a crime.count columns
df$count <- 1


df2 <- df %>% group_by(PrimaryType, Month,Arrest) %>% summarize(Total = sum(count), .groups = 'keep') 
df44 <- df %>% group_by(PrimaryType,Arrest) %>% summarize(Total = sum(count), .groups = 'keep') #Only grouped by Types for Tab 4
df33 <- df[1:1000,]  ##I have used only a subset as full dataset is causing my R to crash.

server <- function(input, output, session) {
  
  
  reac_df1 <- reactive({
    req(input$type)
    df1 <- df %>% filter(PrimaryType %in% input$type) %>% group_by(PrimaryType, Month) %>% summarize(Total = sum(count), .groups = 'keep')
  })
  
  observe({
    updateSelectInput(session,"type", choices = unique(df$PrimaryType))
  })
  
  
  #TAb 1 
  output$bar <- renderPlot({
    ggplot(reac_df1(),aes(x=(Month), y=(Total))) +geom_bar(stat='identity',fill = "#FF6666") + ggtitle("Crime Rates across the months")
  })
  
  
  
  
  #Tab 2
  
  df33 <- df[1:1000,]  ##I have used only a subset as full dataset is causing my R to crash. 
  
  output$map <- renderLeaflet({
    
    df33$Longitude <- as.numeric(df33$Longitude)
    df33$Latitude <- as.numeric(df33$Latitude )
    df33.SP <- SpatialPointsDataFrame(df[,c(20,21)],df[,-c(20,21)])
    
    leaf_data <- df33[df33$Date==input$date,]
    
    leaflet() %>% 
      addTiles() %>% addMarkers(data = leaf_data, lng = ~Longitude, lat = ~Latitude, popup = ~PrimaryType)
    
  })
  
  
  #Tab 3
  hmap <- df %>%
    dplyr::group_by(PrimaryType,Time) %>% 
    dplyr::tally()
  
  output$hmap <- renderPlot({
    ggplot(hmap,aes(x=(Time), y=(PrimaryType), fill=n)) + geom_tile() + theme_minimal()+
ggtitle("Crimes Intensity vs Time") + scale_fill_gradient(low="#F0F8FF",high="#9F000F")
  
    
    
      
  })
  
  
  
  
  #TAb 4 
  
  
  
  output$arrest <- renderPlot({
    ggplot(df44, aes(x=PrimaryType, y=Total, color=Arrest)) + geom_point(size=6) + ggtitle("Crimes and their arrest count") + theme(axis.text.x=element_text(angle=90, hjust=1))
  })    
  
  
  
  
  
}

ui <- fluidPage( 
  h1("Crimes Statistics in Chicago"),
  mainPanel(
    tabsetPanel(type = "tab",
                tabPanel("Montly Crime Rate vs Types of Crime", 
                         selectInput("type",label = "Types of Crimes", "Names"),
                         plotOutput("bar")),
                tabPanel("Location of Crimes by Date", 
                         dateInput("date",label = "Date", value = mean(df33$Date),min(df33$Date), max(df33$Date)),
                         leafletOutput("map" , height = 600)),
                tabPanel("HeatMap - Crimes relation to time", 
                         plotOutput("hmap")),
                tabPanel("Arrest Proportion per Crime", 
                         plotOutput("arrest", height = 600, width = 600)))
  )
)

shinyApp(ui, server)

