---
title: "Malaria Disease Surveillance Dashboard"
output: flexdashboard::flex_dashboard
runtime: shiny
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# 1. Loading and Preparing the Dataset

## 1.1 Installing sf library

```{r}
install.packages(c("shiny", "ggplot2", "dplyr", "leaflet", "sf", "rmarkdown"))

```

## 1.2 Loading the installed packages

```{r}
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(sf)
library(rmarkdown)
```

## 1.3 Loading the Dataset

```{r}
data <- read.csv("C:\\Users\\DELL\\Downloads\\National Unit-data.csv")
```

## 1.4 Printing columns'names

```{r}
colnames(data)
```

## 1.5 Install other important libraries

```{r}
install.packages(c("leaflet", "sf", "dplyr", "rnaturalearth"))
```

## 1.6 Load installed packages

```{r}
library(leaflet)
library(sf)
library(dplyr)
library(rnaturalearth)
```

## 1.7 Filter out rows with missing values and convert Year to Integer

```{r}
data$Year <- as.integer(data$Year)
data <- data %>% filter(!is.na(Value) & !is.na(Year))
```

## 1.8 Install naturalearth package

```{r}
install.packages("rnaturalearthdata")
```

## 1.9 Load rnaturalearth package

```{r}
library(rnaturalearth)
```

## 2.0 Loading the world shapefile dataset

```{r}
world <- ne_countries(scale = "medium", returnclass = "sf")
```

## 2.1 Joining My Data to the World Data

### 2.1.1 Assuming my Dataset has 'names' column with names of the Countries

```{r}
data$Name <- as.character(data$Name)
```

### 2.1.2 Merging My Data with World Shapefile Dataset

```{r}
merged_data <- world %>%
  left_join(data, by = c("name" = "Name"))
```

### 2.3 Checking for missing values

```{r}
sum(is.na(data$Value))  # Count missing values in the Value column
sum(is.na(data$Year))
```

## 3. Building and Deploying Shiny Dashboard

## 3.1 User Interface (UI)

```{r}
ui <- fluidPage(
  titlePanel("Malaria Disease Surveillance Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Select Year:", choices = sort(unique(data$Year))),
      selectInput("metric", "Select Metric:", choices = sort(unique(data$Metric))),
      actionButton("generate", "Generate Map")
    ),
    
    mainPanel(
      leafletOutput("map")  # Output for the map
    )
  )
)
```

## 3.2 Server Logic

```{r}
server <- function(input, output) {
  
  # Reactive expression to filter data based on user inputs
  filtered_data <- reactive({
    req(input$generate)  # Ensure the button is clicked
    
    # Filter the dataset by Year and Metric
    df <- merged_data %>%
      filter(Year == input$year, Metric == input$metric)
    
    print(str(df))  # Check the structure of the filtered data for debugging
    
    df
  })
  
  # Render the Leaflet map
  output$map <- renderLeaflet({
    df <- filtered_data()  # Get the filtered data
    
    # Check if there is any data to display
    if (nrow(df) == 0) {
      return(leaflet() %>% addTiles())  # Return a blank map if no data
    }
    
    # Create a choropleth map
    leaflet(df) %>%
      addProviderTiles("Stamen.Toner") %>%
      addPolygons(
        fillColor = ~colorQuantile("YlOrRd", df$Value)(df$Value),
        weight = 1,
        opacity = 0.7,
        color = "white",
        fillOpacity = 0.7,
        popup = ~paste("Country:", df$name, "<br>", "Metric:", df$Metric, "<br>", "Value:", df$Value)
      ) %>%
      addLegend(position = "bottomright", pal = colorQuantile("YlOrRd", df$Value), values = df$Value, title = "Prevalence")
  })
}
```

## 3.3 Running the Shiny Dashboard

```{r}
shinyApp(ui = ui, server = server)
```
