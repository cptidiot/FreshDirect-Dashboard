tabInv <- 
  
  tabPanel('Inventory',
         
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
          tabPanel('Summary',
       
            h3('Inventory Summary'),
            wellPanel(plotOutput('InvSummary'))
          ),
          tabPanel('Loss Reasons',
        
            h3('Loss Reason Plot'),
            wellPanel(plotOutput('loss',width = '800'))
          ),
          tabPanel('Inventory Turnover',
        
            h3('Inventory Turnover'),
            wellPanel(plotOutput('turnover'))
          ),
          tabPanel('Inventory by Supplier',
                   
                   h3('Inventory by Supplier'),
                   wellPanel(plotOutput('supplier'))
          )
          
        )
      )
    )
  )

