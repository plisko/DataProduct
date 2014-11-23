library(shiny)
# http://www.math.hope.edu/swanson/statlabs/data.html
shinyUI(pageWithSidebar(
    headerPanel("Data Explorer!"),
    sidebarPanel(fileInput('datafile', h5('Upload your data file here:'),,
                           accept = c('text/csv','text/comma-separated-values',
                                      'text/tab-separated-values','text/plain','.csv','.tsv')
                           ),
                 tags$hr(),
                 h5('File format setting:'),
                 checkboxInput('header', 'HasHeader', TRUE),
                 tags$br(),
                 radioButtons('separator', p('Column separator:'),
                             c(Comma=',',Semicolon=';',Tab='\t'),','),
                 tags$hr(),
                 h5('Plot axes information:'),
                 selectInput("selectOut", label = p("Y variable"), choices = list("-- no file uploaded --" = -1), -1),
                 checkboxInput('jitterY', 'Add Jitter', FALSE),
                 selectInput("selectIn", label = p("X variable"), choices = list("-- no file uploaded --" = -1), -1),
                 checkboxInput('jitterX', 'Add Jitter', FALSE),
                 tags$hr(),
                 radioButtons('regressionMethod', h5('Smoothing method'),
                              c('Linear (lm)'='lm', 'Generalized Linear (glm)' = 'glm', 'Polynomial (loess)'='loess'),'lm'),
                 tags$hr(),
                 h5('Plot points labels and colors:'),
                 checkboxInput('labels', 'Show Labels on points', FALSE),
                 checkboxInput('colors', 'Apply Colors on points', FALSE),
                 tags$br(),
                 selectInput("selectLabel", label = p("Choose labeling column:"), choices = list("-- no file uploaded --" = -1), -1, selectize = TRUE),
                 selectInput("selectColor", label = p("Choose coloring column:"), choices = list("-- no file uploaded --" = -1), -1, selectize = TRUE)
                 ),
    mainPanel(tabsetPanel(type = "tabs",
                          tabPanel("Summary", verbatimTextOutput('summary')),
                          tabPanel("DataTable", textOutput('dataTabMessage'), dataTableOutput('datatab')),
                          tabPanel("Regression Line", textOutput('plotTabMessage'), plotOutput('scatter'))
              ))
))
