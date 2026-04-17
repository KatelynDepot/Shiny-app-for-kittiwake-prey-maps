
# packages
library(shiny)
library(DT)
library(dplyr)

# load data
table <- read.csv('data/Shiny_plot_table.csv', stringsAsFactors = FALSE)
gurge_data <- read.csv('data/Shiny_gurge_table_long.csv')
metazoa_data <- read.csv('data/Shiny_fDNA_metazoa_long.csv')
fish_data <- read.csv('data/Shiny_fDNA_fish_long.csv')


# ---- UI ----
ui <- fluidPage(
  titlePanel("Prey samples from GPS-tracked kittiwakes"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("sample_type", "Sample type:",
                   choices = c("Regurgitate" = "gurge", 
                               "Fecal DNA" = "fDNA"),
                   selected = "gurge",
                   inline = T),
      fluidRow(
        column(width = 7, 
               selectInput("prey_type", "Prey type:", choices = NULL),
        ),
        column(width = 5, 
               numericInput("min_prop", "Proportion:",
                            value = 0.01, min = 0.01, max = 1, step = 0.01),
        )
      ),
      DTOutput("table")
    ),
    mainPanel(
      p("Georeferenced prey samples from GPS-tracked black-legged kittiwakes 
        at Middleton Island, Alaska, showing prey proportions and associated 
        GPS points classified as “foraging” from the 9 h (regurgitates) or 
        24 h (fecal DNA) before sample collection. “X” denotes GPS battery death."),
      uiOutput("image_display")
    )
  ),
  p("These data are associated with the publication: ",
    em("Katelyn M. Depot, Shannon Whelan, Mayumi L. Arimitsu, 
    Gemma V. Clucas, and Kyle H. Elliott. 2026. Coupling diet and foraging 
    behavior of a surface-feeding seabird to map prey spatial distribution."), 
    style = "font-size: 75%;")
)


# functions for prey filtering
get_gurge_ids <- function(prey, prop){
  gurge_data %>%
    dplyr::filter(Prey == prey & rel_mass > prop) %>%
    pull(dep_id)
}
get_fDNA_ids <- function(prey, prop){
  rbind(fish_data, metazoa_data) %>%
  dplyr::filter(Prey == prey & rra > prop) %>%
  pull(dep_id)
}

# ---- Server ----
server <- function(input, output, session) {
  
  observeEvent(input$sample_type, {
    new_choices <- if (input$sample_type == "gurge") {
      c("Any", unique(gurge_data$Prey))
    } else {
      c("Any", unique(metazoa_data$Prey), unique(fish_data$Prey))
    }
    updateSelectInput(session, "prey_type",
                      choices = new_choices)
  })
  
  filtered_table_hidden <- reactive({
    if (input$sample_type == "gurge" & input$prey_type == "Any") {
      table %>%
        filter(type == "Regurgitate")
    } else if (input$sample_type == "fDNA" & input$prey_type == "Any") {
      table %>%
        filter(type == "Fecal DNA")
    } else if (input$sample_type == "gurge" & input$prey_type != "Any") {
      table %>%
        filter(type == "Regurgitate",
               dep_id %in% get_gurge_ids(input$prey_type, input$min_prop))
    } else {
      table %>%
        filter(type == "Fecal DNA",
               dep_id %in% get_fDNA_ids(input$prey_type, input$min_prop))
    }
  })
  
  filtered_table <- reactive({
    if (input$sample_type == "gurge" & input$prey_type == "Any") {
      table %>%
        filter(type == "Regurgitate") %>%
        dplyr::select(Deployment = dep_id, LocalTime)
    } else if (input$sample_type == "fDNA" & input$prey_type == "Any") {
      table %>%
        filter(type == "Fecal DNA") %>%
        dplyr::select(Deployment = dep_id, LocalTime)
    } else if (input$sample_type == "gurge" & input$prey_type != "Any") {
      table %>%
        filter(type == "Regurgitate",
               dep_id %in% get_gurge_ids(input$prey_type, input$min_prop)) %>%
        dplyr::select(Deployment = dep_id, LocalTime)
    } else {
      table %>%
        filter(type == "Fecal DNA",
               dep_id %in% get_fDNA_ids(input$prey_type, input$min_prop)) %>%
        dplyr::select(Deployment = dep_id, LocalTime)
    }
  })
  
  output$table <- renderDT({
    datatable(filtered_table(), selection = "single", options = list(
      scrollY = "200px",
      scrollX = TRUE,
      paging = FALSE
    ))
  })
  
  output$image_display <- renderUI({
    selected <- input$table_rows_selected
    if (length(selected) == 1) {
      filename <- filtered_table_hidden()[selected, "plot"]
      filepath <- file.path("plots", filename)
      tags$img(src = filepath, style = "max-width:800px; width:100%; margin-top:25px;")
    } else {
      tags$p("Select a row from the table to view the plot.",
             style = "margin-top:25px;")
    }
  })
}

# ---- Run App ----
shinyApp(ui, server)
