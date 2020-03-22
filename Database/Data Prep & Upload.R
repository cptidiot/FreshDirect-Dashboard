# Loading Packages
require('RPostgreSQL')
require('dplyr')
require('tidyr')
require('readr')

# PostgresSQL Driver and Connection
drv <- dbDriver('PostgreSQL')

con <- dbConnect(drv,dbname = 'sfhqxipq', 
                 host = 'drona.db.elephantsql.com', 
                 user = 'sfhqxipq', password = 'Bq8j2SGQXNAUQiZJ-nOXp7BjNey_a2N3')

# Drop All Existing Tables
sql <- "
          drop table if exists review cascade;
          drop table if exists order_items cascade;
          drop table if exists dma cascade;
          drop table if exists orders cascade;
          drop table if exists customer cascade;
          drop table if exists acquire_source cascade;
          drop table if exists zipcode cascade;
          drop table if exists discount cascade;
          drop table if exists loss_reason cascade;
          drop table if exists loss_records cascade;
          drop table if exists restocking_df cascade;
          drop table if exists items_df cascade;
          drop table if exists supplier_df cascade;
       "

dbGetQuery(con, sql)

# Loading Dataset for Each Tables
dma<-read.csv("dma")
zipcode <- read.csv("zipcode")
acquire_source <- read.csv("acquire_source")
customer<-read.csv("customer")
review <- read.csv("review")
orders <- read.csv("orders")
discount <- read.csv("discount")
order_items <- read.csv("order_items")
  # loss_reason
reason_id <- sprintf('%d', 1:6)
description <- c("employee carelessness", "transportation issue", "Unknown Causes", "Vendor Fraud", "Customer theft", "Employee Theft")
loss_reason <- data.frame(reason_id, description)

  # restocking_df
restocking_df <- read.csv("restocking.csv")
restocking_df <- subset(restocking_df, select = -1)
restocking_df$sku <- sprintf('s%d',1:nrow(restocking_df))

  #supplier_df
supplier_df <- read.csv("supplier.csv")

  #items_df
items_df<-read.csv("items.csv")

  #loss_records
loss_id <- sprintf('%d', 1:70)
loss_time <- sample(seq(as.Date('2016/01/01'), as.Date('2018/10/05'), by="day"), 70)


RandomSelectRoW <- items_df[sample(nrow(items_df), 70), ]
sku <-  RandomSelectRoW %>% select(sku) %>%distinct()

quantity <- floor(runif(70, min=1, max=200))
reasons<-sample(reason_id, size = 70, replace=TRUE)
loss_records <- data.frame(loss_id, loss_time, sku, quantity,reasons)


  #category
cat_id <- sprintf('CA%d', 1:21)
category_name <- c('AlcoholicBeverages', 'BabyBoutique','Bakery', 'Bread','Catering','Dairy','DeliandCheese',
                   'Floral','Freezer','Grocery','HealthandBeautyAids','HouseholdEssentials','Kitchen','MealKit',
                   'Meat','NonalcoholicBeverages','PetShop','Poultry','Produce','Seafood','Snacks')
category_df <- data.frame(cat_id, category_name)

  #warehouse_managers
warehouse_manager_id <- sprintf('%d', 1:21)
warehouse_manager_name <- c('Gus Dobby','Leoine Lemmon','Karleen Meins','Herman Vonasek','Maryjane Baldin',
                            'Barbie Langfat','Cordelie Laflin','Bondy Suarez','Coral Hegge','Kiley Deppen',
                            'Gabi Matessian','Baudoin Feek','Kittie Board','Eulalie Knyvett','Klaus Grelak',
                            'Dorian Droghan','Ulrike Gerardet','Vilma Christofol','Gayleen Crallan','Sam Dixcee',
                            'Menard Shutler')
warehouse_manager_monthly_salary <- c(3000, 3500, 3100, 2900, 3000, 2900, 3000, 3100, 3200, 3300, 3000,
                                      2900, 3500, 3400, 2900, 2700, 2000, 3000, 3000, 3000, 2700)
warehouse_manager_phone <- c('778-679-6952','820-906-0462','705-867-6655','537-843-9114','674-937-4518','552-777-1100',
                             '734-419-5652','466-557-3824','182-272-6334','531-784-6145','124-491-1014','284-328-5445',
                             '150-311-1344','886-211-7766','595-957-1934','966-790-4688','125-763-3116','546-805-9081',
                             '641-572-3731','959-890-9051','887-129-5496')
warehouse_managers_df <- data.frame(warehouse_manager_id, warehouse_manager_name, warehouse_manager_monthly_salary, warehouse_manager_phone)

  #warehouse
warehouse_id <- sprintf('%d', 1:21)
warehouse_location <- c('19 Mayflower Street Brooklyn, NY 11211','2 Howard St. Brooklyn, NY 11215','4 Smoky Hollow St. Manhattan, NY 10002','823 Myrtle St. Bronx, NY 10469',
                        '936 Crescent St. Levittown, NY 11756', '7982 Brown Street Yonkers, NY 10701', '9076 Mammoth Street Spring Valley, NY 10977', '11 Border Street Huntington, NY 11743',
                        '41 Spruce St. Staten Island, NY 10314', '13 Sycamore Rd. Bronx, NY 10465', '9910 NE. Locust Court Bronx, NY 10466', '88 Miller St. Jamestown, NY 14701',
                        '68 North Orchard Ave. Brooklyn, NY 11216', '143 Oak Meadow Ave. Jamaica, NY 11434', '239 Rockcrest St. Woodside, NY 11377', '695 Rockwell St. Jamaica, NY 11432',
                        '7829 Bay St. Manhattan, NY 10033', '32A North Wagon Drive Bronx, NY 10463','8349 Bellevue St. Manhattan, NY 10023','908 Cherry Dr. Manhattan, NY 10003', 
                        '9853 Brandywine Drive Lockport, NY 14094')
warehouse_phone <- c('859-611-5195', '608-127-5448', '285-491-0611', '839-149-3369', '450-592-9482', '922-365-2041', '513-604-1717', '451-323-3503', '390-900-3767','625-914-4000',
                     '269-297-5386', '637-432-9560', '357-278-5136', '167-770-6781', '346-154-9897', '431-385-8925', '727-649-6911', '349-791-2321', '571-807-8625', '217-481-8053','331-426-1570')
warehouse_manager_id <- sample(warehouse_manager_id, size = 21)
warehouse_df <- data.frame(warehouse_id, cat_id, warehouse_location, warehouse_phone, warehouse_manager_id)


# Write Data into PostgresSQL server
dbWriteTable(con, name = 'dma', value = dma, row.names = FALSE, append=TRUE)
print('1')
dbWriteTable(con, name = 'zipcode', value = zipcode, row.names = FALSE, append=TRUE)
print('2')
dbWriteTable(con, name = 'acquire_source', value = acquire_source, row.names = FALSE, append=TRUE)
print('3')
dbWriteTable(con, name = 'customer', value = customer, row.names = FALSE, append=TRUE)
print('4')
dbWriteTable(con, name = 'review', value = review, row.names = FALSE, append=TRUE)
print('5')
dbWriteTable(con, name = 'orders', value = orders, row.names = FALSE, append=TRUE)
print('6')
dbWriteTable(con, name = 'discount', value = discount, row.names = FALSE, append=TRUE)
print('7')
dbWriteTable(con, name = 'order_items', value = order_items, row.names = FALSE, append=TRUE)
print('8')
dbWriteTable(con, name='loss_reason', value=loss_reason, row.names=FALSE, append =TRUE)
print('9')
dbWriteTable(con, name = 'restocking_df', value = restocking_df, row.names = FALSE, append=TRUE)
print('10')
dbWriteTable(con, name = 'supplier_df', value = supplier_df, row.names = FALSE, append=TRUE)
print('11')
dbWriteTable(con, name = 'items_df', value = items_df, row.names = FALSE, append=TRUE)
print('12')
dbWriteTable(con, name="category", value=category_df, row.names=FALSE, append=TRUE)
print('13')
dbWriteTable(con, name="warehouse_managers", value=warehouse_managers_df, row.names=FALSE, append=TRUE)
print('14')
dbWriteTable(con, name="warehouse", value=warehouse_df, row.names=FALSE, append=TRUE)
print('15')
dbWriteTable(con, name='loss_records', value=loss_records, row.names=FALSE, append =TRUE)
print('16')


################# DEBUG #################


# Create Functions 
age_level_func <- 
"CREATE OR REPLACE FUNCTION Age_Level(age double precision) 
    RETURNS TEXT AS 
            $func$
                DECLARE res text;
                BEGIN
                      select case
                                  when age < 30 then 'Young'
                                  when age > 60 then 'Older'
                                  ELSE  'Middle-Aged' end  into res;
                      return res;
                END;
            $func$
            
LANGUAGE plpgsql;
      "


income_level_func <- "
                      CREATE OR REPLACE FUNCTION Income_Level (income double precision) 
                      RETURNS TEXT AS 
                                    $income_level$
                                    DECLARE res TEXT;

                                                BEGIN
                                                  select (case
                                                              when income < 50000 then 'Low'
                                                              when income > 150000 then 'High'
                                                              ELSE  'Middle'
                                      	          end ) into res;
                                                RETURN res;
                                                END; 
                                    $income_level$
                     LANGUAGE plpgsql;

                    "

# Upload Function
dbGetQuery(con, age_level_func)
dbGetQuery(con, income_level_func)

