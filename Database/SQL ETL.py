#!/usr/bin/env python
# coding: utf-8

# In[125]:


import pandas as pd
import numpy as np


# In[654]:


df = pd.read_excel('freshdirect.xlsx')


# # Zipcode

# In[379]:


# find out unique zip code in original dataset that have more than 20 customers
temp = df.groupby('ZIP_CODE').count()['CUSTOMER_ID'].sort_values(ascending = False)
temp1 = temp[temp>20].reset_index()

df_zipcode = pd.DataFrame({'zip':temp1.ZIP_CODE})

# read popluation data
df_pop = pd.read_csv('zipcode_population.csv')

# subset info we need
df_pop = df_pop[['zip','city','population','density']]

# merge popluation info to original dataset
df_zip = pd.merge(df_zipcode, df_pop, on=['zip'], how='inner')

# read income data
df_income = pd.read_csv('zipcode_income.csv')

# subset average total income
df_income = df_income[['ZIPCODE','Avg total income']]

# rename ZIPCODE to zip in df_income
df_income.rename(columns={'ZIPCODE':'zip'}, inplace=True)

# merge income to updated df
df_zip = pd.merge(df_zip, df_income, on=['zip'], how='inner')

df_zip.rename(columns={'Avg total income':'avg_total_income'}, inplace=True)


# # DMA

# In[391]:


# using city name to be dma name
city = pd.DataFrame({'dma_name':df_zip.zip.unique()})

# create unique dma id
dma_id = []
for i in range(0,len(city)):
    dma_id.append('d' + str(i))
dma_id = pd.DataFrame({'dma_id':dma_id})

# import marketing_cost data
marketing_cost = pd.DataFrame({'marketing_cost':np.random.randint(50000,200000,len(city))})

# populate df with market source
marketing_cost['method_of_marketing'] = np.random.choice(['digital ads', 'magazine', 'newspaper','TV','Mail'], marketing_cost.shape[0])

# combine all data together
df_dma = pd.concat([dma_id,city,marketing_cost], axis=1)


# # Acquire Source

# In[393]:


acquire_id = pd.DataFrame({'acquire_id':['a1','a2','a3','a4','a5','a6']})
acquire_name = pd.DataFrame({'acquire_name':['online ads','referral','street campaign','holiday campaign','subway ads','email ads']})
acqurie_cost = pd.DataFrame({'average_cost':[25,15,10,10,5,4]})

df_acquire = pd.concat([acquire_id,acquire_name,acqurie_cost],axis=1)


# # Customer

# In[475]:


# subset columns for customer table
freq_df = df[df.ZIP_CODE.isin(temp1.ZIP_CODE)]
df_customer = freq_df[['AGE',' INCOME ','GENDER','ZIP_CODE','ACQUIRED_DATE','LOYALTY_SEGMENT']]

# process NA
df_customer.AGE = df_customer.AGE.fillna(value = int(df_customer.AGE.mean()))
df_customer[' INCOME '] = df_customer[' INCOME '].fillna (value = int( df_customer[' INCOME '].mean() ))
#df_customer.GENDER = df_customer.GENDER.fillna(value = 'F')

# process negative income
df_customer[' INCOME '].loc[df_customer[' INCOME ']<0] = 50000

# assign acquire source to each customer
df_customer['ACQUIRE_SOURCE'] = np.random.choice(['a1','a2','a3','a4','a5','a6'],df_customer.shape[0])

# assign dma for each customer
df_customer = pd.merge(df_customer,df_zip,left_on = 'ZIP_CODE',right_on = 'zip',how = 'inner')

df_customer.rename(columns = {'zip':'dma'},inplace = True)

# drop unnecessary cols
df_customer.drop(['population','density','avg_total_income','city'],axis = 1, inplace = True)


# add random customer name and address
a = pd.read_csv('customer_1.csv')
b = pd.read_csv('customer_2.csv')
c = pd.read_csv('customer_3.csv')
df_name_address = pd.concat([a,b,c],ignore_index=True)

df_customer

# merge name and address into customer
df_customer = pd.concat([df_name_address,df_customer],axis = 1)
df_customer.rename(columns = {' INCOME ':'income','AGE':'age','GENDER':'gender','ZIP_CODE':'zip_code','ACQUIRED_DATE':'acquired_date','LOYALTY_SEGMENT':'loyalty_segment','ACQUIRE_SOURCE':'acquire_source'},inplace = True)


# In[640]:


df_customer.shape


# # Review

# In[478]:


# generate unique review id
r_id = []
for i in range (1,20001):
    r_id.append('r'+str(i))
r_id = pd.DataFrame({'r_id':r_id})

# generate quality review
q_review = np.random.choice([2,2.5,3,3.5,4,4.5,5],20000)

# generate delivery review
d_review = np.random.choice([3,3.5,4,4.5,5],20000)

# generate avg review
avg_review = (q_review+d_review)/2

# merge all data
r_id['q_review'] = q_review
r_id['d_review'] = d_review
r_id['avg_review'] = avg_review

df_review = r_id


# # Orders

# In[646]:


# create order_id
o_id = []
for i in range(1,20001):
    o_id.append('o'+str(i))
o_id = pd.DataFrame({'order_id':o_id})

#  select customer name and their addresses from customer table 
customer_name_temp = df_customer.customer_name
customer_address_temp = df_customer.address

customer_name = pd.DataFrame({'customer_name':np.random.choice(customer_name_temp,20000),'address':np.random.choice(customer_address_temp,20000)})


# generate data for day_of_week and sales accrodingly with reasonable weights

day_of_week = pd.DataFrame(columns = ['day_of_week','sales'])
day_of_week.day_of_week = np.random.choice(['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],size = 20000,p = [0.05,0.05,0.1,0.1,0.3,0.3,0.1])

def day_of_week_sales():
    for i in range(len(day_of_week)):
        if day_of_week.day_of_week[i] == 'Friday' or day_of_week.day_of_week[i] == 'Saturday':
            day_of_week.sales[i] = np.random.randint(100,500)
        else:
            day_of_week.sales[i] = np.random.randint(30,250)
    return day_of_week

df_day_of_week = day_of_week_sales()

# generate data for status
status = pd.DataFrame({'status':np.random.choice(['Completed','Pending'],size = 20000,p = [0.7,0.3])})

# generate random order date

import random
import time

def strTimeProp(start, end, format, prop):

    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))
    ptime = stime + prop * (etime - stime)

    return time.strftime(format, time.localtime(ptime))


def randomDate(start, end, prop):
    return strTimeProp(start, end, '%m/%d/%Y %I:%M %p', prop)


temp = []
for i in range(1,20001):
    temp.append(randomDate("1/1/2018 1:30 PM", "3/31/2019 11:59 PM", random.random()))

date = pd.DataFrame({'date':temp})

# generate data for total_dis
total_dis = []
for i in range(len(day_of_week)):
    total_dis.append(day_of_week['sales'][i]*(1-round(random.uniform(0.7,1), 2)))
total_discount = pd.DataFrame({'total_dis':total_dis})

# generate delivery fee
delivery_fee = pd.DataFrame({'delivery_fee':np.random.randint(0,10,20000)})

# generate delivery pass
delivery_pass = pd.DataFrame({'delivery_pass':np.random.choice(['True','False'],size = 20000,p=[0.7,0.3])})

# combine all the columns

df_order = pd.concat([o_id,customer_name,day_of_week,status,date,total_discount,delivery_fee,delivery_pass],axis=1)
# combine review to df

df_order = pd.concat([df_order,df_review['r_id']],axis = 1)

df_order.rename(columns={'r_id':'review'}, inplace=True)


# # Discount

# In[496]:


# create unique id for discount table
temp = []
for i in range(1,31):
    temp.append('dis'+str(i))
d_id = pd.DataFrame({'discount_id':temp})

# create discount rate
rate = []
for i in range(1,31):
    rate.append(round(random.uniform(0.5,0.95), 2))
d_rate = pd.DataFrame({'discount_rate':rate})

# create description:
desc = pd.DataFrame({'description':np.random.choice(['street campaign promotion','new customer promotion','Black Friday','subway ads promotion','newspaper ads promotion','Christmas Promotion'],size = 30, p = [0.1,0.3,0.2,0.2,0.1,0.1])})

# create valid_from
v_from = []
for i in range(1,31):
    v_from.append(randomDate("1/1/2018 4:00 PM", "6/1/2018 4:00 AM", random.random()))
v_from = pd.DataFrame({'valid_from':v_from})

# create valid_to
v_to = []
for i in range(1,31):
    v_to.append(randomDate("6/2/2018 1:30 PM", "6/5/2019 4:50 AM", random.random()))
v_to = pd.DataFrame({'valid_to':v_to})

# combine them together
df_discount = pd.concat([d_id,d_rate,desc,v_from,v_to],axis = 1)
df_discount.rename(columns={'r_id':'review'}, inplace=True)


df_discount = df_discount.append({'discount_id' : 'dis31' , 'discount_rate' : 1,'description' : 'No Discount','valid_from':'1900-01-01','valid_to':'9019-01-01'} , ignore_index=True)


# # Order_items

# In[549]:


import time
start = time.time()
# import items data to get sku information
item = pd.read_csv('items.csv')

# create temp df
df_temp = pd.DataFrame()

# randomly generate items for each order
np.random.seed(111)
for i in df_order.order_id:
    df_temp = df_temp.append({'order_id':i,'items':item.sku.sample(np.random.randint(2,20)).tolist()},ignore_index=True)
items = df_temp['items'].apply(pd.Series).stack().reset_index(level=1,drop = True).to_frame('items')


df_temp = pd.merge(items, df_temp, left_index=True,right_index=True)

del df_temp['items_y']
df_temp = df_temp.rename(columns = {'items_x':'items'})

       #df_temp['order_id']=df_temp.index
df_temp = df_temp.reset_index(drop=True)


# randomly generate quantity for each items in each order
temp = []
for i in range(len(df_temp)):
    temp.append(np.random.randint(1,10))
quantity = pd.DataFrame({'quantity':temp})

# randomly generate discount for each items
quantity['discount'] = 'dis31'

split = np.random.rand(len(discount)) < 0.3

quantity.discount[split] = np.random.choice(df_discount.discount_id[0:30],len(split))





# combine all together
df_order_items = pd.concat([df_temp,quantity],axis=1)

end = time.time()

duration = end-start


# In[666]:


df_order_items['quantity'].describe()


# In[679]:


import pandas as pd
from sqlalchemy import create_engine
conn_url = 'postgresql://postgres:drv2i9es@s19db.apan5310.com:50208/test'
engine = create_engine(conn_url)
conn = engine.connect()
print('successfully connected to database')


# In[675]:


import pandas as pd
from sqlalchemy import create_engine
conn_url = 'postgresql://marshall:@localhost:5432/marshall'
engine = create_engine(conn_url)
conn = engine.connect()


# In[680]:


conn.execute('drop table if exists review cascade')

conn.execute('drop table if exists order_items cascade')

conn.execute('drop table if exists orders cascade')

conn.execute('drop table if exists dma cascade')

conn.execute('drop table if exists customer cascade')

conn.execute('drop table if exists acquire_source cascade')

conn.execute('drop table if exists zipcode cascade')

conn.execute('drop table if exists discount cascade')

print('successfully dropped tables')


# In[681]:


conn. execute(""" 

create table dma(
 dma_id                 text,
 dma_name               text,
 marketing_cost         int,
 method_of_marketing    text,
 primary key (dma_name));


create table zipcode(
 zip                   bigint,
 city                  text,
 population            int,
 density               numeric,
 avg_total_income      numeric,
 
 primary key (zip));
     
  
create table acquire_source(
 acquire_id                   text,
 acquire_name                 text,
 average_cost                 int,
 primary key (acquire_id));
 
 
   
create table customer(
 customer_name           varchar(200),
 address                 text,
 age                     numeric,
 income                  numeric,
 gender                  text,
 zip_code                bigint,
 acquired_date           timestamp,
 loyalty_segment         text,
 acquire_source          text,
 dma                     text,
 primary key (customer_name),
 foreign key (dma) references dma(dma_name),
 foreign key (zip_code) references zipcode(zip),
 foreign key (acquire_source) references acquire_source(acquire_id));
 
 
 create table review(
 r_id            text,
 q_review        numeric,
 d_review        numeric,
 avg_review      numeric,
 primary key (r_id)) ;
 
 
 create table orders(
 order_id            text,
 customer_name       varchar(200),
 address             text,
 day_of_week         text,
 sales               int,
 status              text,
 date                timestamp,
 total_dis           numeric,
 delivery_fee        int,
 delivery_pass       text,
 review              text,
 primary key (order_id),
 foreign key (customer_name) references customer(customer_name),
 foreign key (review) references review(r_id));
 
 
     



create table discount(
 discount_id    text,
 discount_rate   numeric,
 description    text,
 valid_from    text,
 valid_to    text,
 primary key (discount_id));

     



create table order_items(
 items        text,
 order_id     text,
 quantity     int,
 discount     text,
 primary key (items,order_id),
 foreign key (discount) references discount(discount_id),
 foreign key (items) references items_df(sku),
 
 foreign key (order_id) references orders(order_id) );
     
""")

print('successfully created tables')


# # Download data into CVS for faster speed in R

# In[647]:



df_order.to_csv('orders',index = False)
print('order is uploaded successfully')


# In[594]:


s = time.time()
df_dma.to_csv('dma',index = False)


df_zip.to_csv('zipcode',index = False)
print('zipcode is uploaded successfully')


df_acquire.to_csv('acquire_source',index = False)
print('acquire is uploaded successfully')


df_customer.to_csv('customer',index = False)
print('customer is uploaded successfully')


df_review.to_csv('review',index = False)
print('review is uploaded successfully')


df_order.to_csv('orders',index = False)
print('order is uploaded successfully')



df_discount.to_csv('discount',index = False)
print('discount is uploaded successfully')


df_order_items.to_csv('order_items',index = False)
print('order_times is uploaded successfully')


e = time.time()
e-s


# # populate database

# In[664]:


s = time.time()
df_dma.to_sql('dma',engine,if_exists = 'append',index = False)
print('dma is uploaded successfully')

df_zip.to_sql('zipcode',engine,if_exists = 'append',index = False)
print('zipcode is uploaded successfully')


df_acquire.to_sql('acquire_source',engine,if_exists = 'append',index = False)
print('acquire is uploaded successfully')


df_customer.to_sql('customer',engine,if_exists = 'append',index = False)
print('customer is uploaded successfully')


df_review.to_sql('review',engine,if_exists = 'append',index = False)
print('review is uploaded successfully')


df_order.to_sql('orders',engine,if_exists = 'append',index = False)
print('order is uploaded successfully')



df_discount.to_sql('discount',engine,if_exists = 'append',index = False)
print('discount is uploaded successfully')


df_order_items.to_sql('order_items',engine,if_exists = 'append',index = False)
print('order_times is uploaded successfully')


e = time.time()
e-s


# # match zip_code with the coordinates

# In[628]:


co = pd.read_csv('coordinate_original.csv')

zip_co = pd.merge(df_zip,co,left_on = 'zip',right_on = 'ZIP',how = 'inner' )

zip_co.drop(['population','density','avg_total_income','city','ZIP'],axis = 1, inplace = True)

zip_co.rename(columns = {'LAT':'lat','LNG':'lon'},inplace = True)

