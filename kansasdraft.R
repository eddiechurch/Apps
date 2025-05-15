library(shiny)
library(tidycensus)
library(leaflet)
library(ggplot2)


kansas <- get_acs(
  geography = "county",
  variables = "B01003_001",
  state = "KS",
  year = 2010,
  geometry = TRUE
)

ui <- fluidPage(
  titlePanel("Kansas Census Data by County"),
  leafletOutput("map"),
  selectInput("variable", "Census Vairable", choices = c("Population" = "B01003_001"))
)


server <- function(input, output, session) {
  kansas <- reactive({
    get_acs(
      geography = "county",
      variables = input$variable,
      state = "KS",
      year = 2010,
      geometry = TRUE
    )
  })
  
  output$map <- renderLeaflet({
    data <- kansas()
    
  })
}



shinyApp(ui = ui, server = server)
