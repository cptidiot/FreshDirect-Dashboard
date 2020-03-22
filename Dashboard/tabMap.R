tabMap <- 
  
  tabPanel('Map',
           
           div(
             
             class='outer', # custom class defined in styles.css
             
             tags$head(includeCSS('www/styles.CSS')), # custom CSS
             
             leafletOutput('map', width='100%', height='100%'),
             
             ####################################
             # main control panel on the right
             ####################################
             
             
             
             ####################################
             # zip detail panel on the left
             ####################################
             
             absolutePanel(
               id = 'text', class = 'panel panel-default', 
               fixed = TRUE, draggable = TRUE, 
               top = 60, left = 50, right = 'auto', bottom = 'auto',
               width = 320, height = 'auto',
               
               htmlOutput('zipText'),
               plotlyOutput('genMix'))

               
             ) # absolutePanel
             ####################################
           ) # div
           
  
