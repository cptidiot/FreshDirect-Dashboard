tabCust <- 
  
  tabPanel('Customers',
         
    div(
      
      class = 'outer', # custom class defined in styles.css
             
      tags$head(includeCSS('www/styles.CSS')), # custom CSS
     
      ####################################
      # main panel
      ####################################
       
      wellPanel(
        align = 'center',
        style = 'background-color: #dcdedf',
        tabsetPanel(
          tabPanel('Income Segment',
            fluidRow(
              column(12,
                     wellPanel(style = 'padding: 25px',
                               radioButtons(
                                 inputId = 'age_income',
                                 label = 'AGE SEGMENT',
                                 inline = TRUE,
                                 choices = c( 'All','Compare'),
                                 selected = 'All'
                               )
                     )
                     
                     
              )
            ),
            h3('Customer Income Segment'),
            wellPanel(plotOutput('age'))
          ),
          tabPanel('Loyalty Segment',
            fluidRow(
              column(12,
                  wellPanel(style = 'padding: 25px',
                            radioButtons(
                              inputId = 'age_loyal',
                              label = 'AGE SEGMENT',
                              inline = TRUE,
                              choices = c( 'All','Compare'),
                              selected = 'All'
                            )
                  )
            
                
              )
        
            ),
            h3('Loyalty Segment'),
            wellPanel(plotOutput('loyal'))
          ),
          tabPanel('Acquire Source',
            fluidRow(
              column(12,
                wellPanel(
                  style = 'padding: 25px',
                  radioButtons(
                    inputId = 'age_acquire',
                    label = 'AGE SEGMENT',
                    inline = TRUE,
                    choices = c( 'All','Compare'),
                    selected = 'All'
              
                )
              )
            )),
            h3('Acquire_Source'),
            wellPanel(plotOutput('acquire'))
          )
        )
      )
    )
  )

