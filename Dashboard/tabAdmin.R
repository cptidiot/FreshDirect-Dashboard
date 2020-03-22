tabAdmin <- 
  
  tabPanel('Admin',
           # custom CSS to change font of SQL textbox to a monospace font
           tags$head(
             tags$style(
               HTML('textArea {font-family: Courier;
                    font-size: 18px;
                    font-weight: bold;}'
               )
               )
               ),
           # require a password to access
           passwordInput(inputId = 'pwd', label = 'Password:'),
           # show the rest of the page only if password is correct
           conditionalPanel(
             # pwd6 defined in global
             paste0('input.pwd == \'', pwd6, '\''), 
             sidebarLayout(
               # area to enter SQL code
               sidebarPanel(
                 # textbox to enter SQL code
                 textAreaInput(
                   inputId = 'sql', 
                   label = 'SQL:', 
                   value = '',
                   width = '100%', 
                   height = '300px',
                   resize = 'vertical'
                 ),
                 fluidRow(
                   
                   column(12, align = 'right',
                          # button to send SQL code to the reactive variable sq in server
                          actionBttn(
                            inputId = "run",
                            label = "RUN", 
                            style = "gradient",
                            color = "success",
                            icon = icon("flash")
                          )
                   )
                 )
               ),
               # space to show results of SQL run
               mainPanel(
                 wellPanel(
                   tableOutput('tbl')
                 )
               )
             )
           )
  )
