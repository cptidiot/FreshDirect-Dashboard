library(dplyr)
library(ggplot2)
library(leaflet)
library(plotly)
library(RPostgreSQL)
library(scales)
library(shiny)
library(shinyWidgets)
library(stringr)
library(tidyr)
library(RColorBrewer)
library(ggthemes)

con <- dbConnect(drv = dbDriver('PostgreSQL'),
                 dbname = 'test',
                 host = 's19db.apan5310.com', port = 50208,
                 user = 'postgres', password = 'drv2i9es')

require(ggplot2)
require('RPostgreSQL')
require('scales')

stmt0 <- "select zip, population, avg_total_income*1000 as average_income
          from zipcode"
zip_df = dbGetQuery(con, stmt0)

stmt1 <- "select dma_name as zip,marketing_cost
          from dma"
dma_df = dbGetQuery(con, stmt1)



stmt3<-"
        select zip_code as zip,sum(sales) as total_sales
        from (customer join orders on orders.customer_name = customer.customer_name) as t
        group by zip_code
        order by zip_code
        "
sales_df <- dbGetQuery(con, stmt3)






data = read_csv('ziploc.csv')
data2 <- data.frame(data$zip,data$lat,data$lng,data$pct_f)
colnames(data2)  = c('zip','lat','lng','pct_f')
data3 = data2[1:41,]


sales_df

head(dma_df)
head(zip_df)
head(sales_df)
head(data3)

result = merge(dma_df,zip_df,by='zip')
result = merge(result,sales_df,by='zip')
result = merge(result,data3,by='zip')

write.csv(result, file = "map.csv")

