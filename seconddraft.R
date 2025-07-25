library(shiny)
library(tidycensus)
library(leaflet)
library(ggplot2)
library(DT)


kansas <- get_acs(
  geography = "county",
  variables = "B01003_001",
  state = "KS",
  year = 2010,
  geometry = TRUE
)

ui <- fluidPage(
  titlePanel("KS Population by County"),
  leafletOutput("map"),
  selectInput("variable", "Census Variable", choices = c("Population" = "B01003_001")),
  DTOutput("table")
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
    pal <- colorNumeric("Oranges", domain = data$estimate)
    leaflet(data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(
        fillColor = ~pal(estimate),
        fillOpacity = 0.7,
        highlight = highlightOptions(
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste0(NAME, ": ", formatC(estimate, format = "d", big.mark = ",")),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px ")
        )
      )
    
  })
  
  output$table <- renderDT({
    data <- kansas()
    table_data <- data.frame(
      County = data$NAME,
      Population = data$estimate
    )
    datatable(table_data, options = list(), rownames = FALSE)
  })
}



shinyApp(ui = ui, server = server)
