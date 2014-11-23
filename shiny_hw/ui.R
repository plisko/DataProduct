library(shiny)
# http://www.math.hope.edu/swanson/statlabs/data.html
shinyUI(pageWithSidebar(
    headerPanel("Data Explorer!", windowTitle = "Data Explorer! - Coursera Data Products Project"),
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
                 checkboxInput('jitterY', 'Add Y-jitter', FALSE),
                 selectInput("selectIn", label = p("X variable"), choices = list("-- no file uploaded --" = -1), -1),
                 checkboxInput('jitterX', 'Add X-jitter', FALSE),
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
    mainPanel(tabsetPanel(type = "tabs", position = "above", selected = "Documentation",
                          tabPanel("Summary", verbatimTextOutput('summary')),
                          tabPanel("Data Table", textOutput('dataTabMessage'), dataTableOutput('datatab')),
                          tabPanel("Plot and Regression", textOutput('plotTabMessage'), plotOutput('scatter')),
                          tabPanel("Documentation",
                                   h3('What is the Data Explorer'),
                                   p('Data Explorer is the app of your choice to quickly perform any data exploration task!'),
                                   br(),
                                   p('With Data Explorer you can:'),
                                   tags$ul(
                                       tags$li('view basic summary statistics of your data [Summary tab]'),
                                       tags$li('navigate (view, sort, search) your data using an interactive table [Data Table tab]'),
                                       tags$li('show a scatterplot with a regression line of your data [Plot and Regression]')
                                       ),
                                   p('Data Explorer gives you several customizations such as:'),
                                   tags$ul(
                                       tags$li('adaptability to your data file format (separator/header)'),
                                       tags$li('ability to choose X and Y axes variables'),
                                       tags$li('ability to choose the type of regression to be used'),
                                       tags$li('abilty to set colors and labels of the points on the plot')
                                   ),
                                   h3('How to use the Data Explorer'),
                                   p('Use the panel on the left to upload the csv/tsv file containing your data.
                                     Using the radio buttons/checkboxes you can set the file separator and you can enable/disable the reading of the header in the input file.'),
                                   p('Using the select boxes you can choose the X and Y variables of the plot. Only numeric columns of your data set will be reported in the "variable" select boxes.
                                     If you need it, you can add jitter (noise) to your data points by enabling the jitter options. This may be useful to plot some kinds of datasets.'),
                                   p('You can set the smoothing (regression) method used in the plot. Options are lm, glm and loess.'),
                                   p('If you need it, you can set a data set variable as a label of the points in the plot. This can be done by enabling the labelling checkbox and by selecting the data set column used as a label.'),
                                   p('If you need it, you can set a data set variable as the color definer of the points in the plot. This can be done by enabling the coloring checkbox and by selecting the data set column used as color.
                                     The coloring will be performed by considering the selected column as a factor variable.'),
                                   br(),
                                   h3('Sample files'),
                                   p('You can file some sample csv files at the following link:'),
                                   tags$a(href = "https://github.com/plisko/DataProduct/tree/master/sample_datasets", "sample CSV files")
                                   
                                   )
              ))
))
