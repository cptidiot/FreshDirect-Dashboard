tabMain <- 
  
  tabPanel('Main',

    div(
      
      class = 'outer', # custom class defined in styles.css
      tags$head(includeCSS('www/styles.CSS')), # custom CSS
      style = "overflow-y:scroll",
      
     
      ####################################
      # main panel
      ####################################
       
      wellPanel(
         align = 'center',
        style = 'background-color: #dcdedf',
        ####################################
        # display boxes
        ####################################
        fluidRow(
           column(4,
             wellPanel(style = 'background-color: #64bbaa',
                htmlOutput('home1')
             )
           ),
           column(4,
             wellPanel(style = 'background-color: #64bbaa',
               htmlOutput('home2')
             )
           ),
           column(4,
             wellPanel(style = 'background-color: #64bbaa',
               htmlOutput('home3')
             )
           )
        ),
       hr(),
       ####################################
       # main plots
       ####################################
       tabsetPanel(
         ####################################
         # tab 1
         ####################################
         tabPanel('Sales by Month',
           fluidRow(
             column(6,
               wellPanel(
                 selectInput(
                   inputId = 'zip',
                   label = 'Zip Code',
                   choices = c('All', zips),
                   selected = 1
                 )
               )
             ),
             column(6,
               wellPanel(style = 'padding: 25px',
                 radioButtons(
                   inputId = 'gender',
                   label = 'Gender',
                   inline = TRUE,
                   choices = c( 'All','Compare'),
                   selected = 'All'
                 )
               )
             )
           ),
           h3('Total Sales'),
           wellPanel(plotOutput('plotMain', height = '600'))
         ),
         ####################################
         # tab 2
         ####################################
         tabPanel('DOW',
                  fluidRow(
                    column(12,
                           wellPanel(style = 'padding: 25px',
                                     radioButtons(
                                       inputId = 'gender2',
                                       label = 'Gender',
                                       inline = TRUE,
                                       choices = c('Compare', 'All'),
                                       selected = 'All'
                                     )
                           )
                    ),
                  h3('Day_of_Week'),
                  wellPanel(plotOutput('plotMain2',width = '800'))
         )
         ),
         ####################################
         # tab 3
         ####################################
         tabPanel('AGE',
          fluidRow(
            column(6,
                   wellPanel(
                     selectInput(
                       inputId = 'zip2',
                       label = 'Zip Code',
                       choices = c('All', zips)
                                )
                            )
                  ),
            
            column(6,
                   
                     wellPanel(style = 'padding: 25px',
                               radioButtons(
                                 inputId = 'gender3',
                                 label = 'Gender',
                                 inline = TRUE,
                                 choices = c('Compare', 'All'),
                                 selected = 'All'
                                            )
                              )
                            
                    )),
          h3('Sales by Age'),
         
          
                   wellPanel(style = 'background-color: "#123456";',
                     plotOutput('plotMain3',width = '800'))
            
          
          
         )
       )
      ####################################
      # end main plots
      ####################################
    )
  )
)

  

