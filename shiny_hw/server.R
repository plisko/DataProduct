library(shiny)
library(ggplot2)

shinyServer(function(input, output, session) {
    
    filedata <- reactive({
        infile <- input$datafile
        if (is.null(infile)) {
            # User has not uploaded a file yet
            return(NULL)
        }
        fileCsv <- read.csv(infile$datapath, header = input$header, sep = input$separator)
        numericColumns <- colnames(fileCsv[,sapply(fileCsv,is.numeric)])
        if (length(numericColumns) == 0) {
            numericColumns <- list("-- no numeric columns --" = -1)
        }
        updateSelectInput(session, 'selectOut', choices = numericColumns, selected = numericColumns[min(1,length(numericColumns))])
        updateSelectInput(session, 'selectIn', choices = numericColumns, selected = numericColumns[min(2,length(numericColumns))])
        updateSelectInput(session, 'selectLabel', choices = colnames(fileCsv))
        updateSelectInput(session, 'selectColor', choices = colnames(fileCsv))
        updateCheckboxInput(session, 'labels', value = FALSE)
        updateCheckboxInput(session, 'colors', value = FALSE)
        updateCheckboxInput(session, 'jitterX', value = FALSE)
        updateCheckboxInput(session, 'jitterY', value = FALSE)
        return(fileCsv)
    })
    
    output$datatab <- renderDataTable({
        filedata()
    })
    
    output$summary <- renderPrint({
        df <- filedata()
        if (is.null(df)) {
            return ("Please upload a file to view its summary here.")
        }
        summary(df)
    })

    output$dataTabMessage <- renderText({
        if (is.null(filedata())) {
            return ("No file uploaded.")
        }
        return ('')
    })
    
    output$plotTabMessage <- renderText({
        if (is.null(filedata())) {
            return ("No file uploaded.")
        }
        if (input$selectOut == -1 || input$selectIn == -1) {
            return ("Please select two numeric columns of the dataframe.")
        }
        return ('')
    })
    
    output$scatter <- renderPlot({
        df <- filedata()
        if (is.null(df)) {
            return (NULL)
        }
        
        outputCol <- input$selectOut
        inputCol <- input$selectIn
        
        if (outputCol == -1 || inputCol == -1) {
            return (NULL)
        }
        
        collist <- rep(1, nrow(df))
        if (input$colors) {
            collist <- df[,input$selectColor]
        }
        
        x_variable <- df[,inputCol]
        if (input$jitterX) {
            x_variable <- jitter(x_variable)
        }
        
        y_variable <- df[,outputCol]
        if (input$jitterY) {
            y_variable <- jitter(y_variable)
        }
        
        ggp <- ggplot(df, aes(x=x_variable, y=y_variable, group=1, colour=factor(collist)), environment = environment())
        ggp <- ggp + xlab(inputCol) + ylab(outputCol)
        ggp <- ggp + geom_point()
        ggp <- ggp + geom_smooth(method = input$regressionMethod)
        ggp <- ggp + theme_minimal()
        if (!input$colors) {
            ggp <- ggp + theme(legend.position = "none")
        }
        else {
            ggp <- ggp + theme(legend.title=element_blank())
        }
        
        
        if (input$labels) {
            ggp <- ggp + geom_text(aes(label=df[,input$selectLabel]),hjust=1,vjust=1)
        }
        
        
        return(ggp)
    })

})
