
source(file = 'tabMain.R', local = TRUE)
source(file = 'tabCust.R', local = TRUE)
source(file = 'tabMap.R', local = TRUE)
source(file = 'tabInv.R', local = TRUE)
source(file = 'tabAdmin.R', local = TRUE)

navbarPage(
  
  title = 'FRESH DIRECT', 
  id = 'nav',
  position = 'static-top',
  collapsible = TRUE,
  inverse = FALSE,
  
  tabMain,

  tabCust,
  
  tabMap,
  
  tabInv,
  
  tabAdmin 
         
)


