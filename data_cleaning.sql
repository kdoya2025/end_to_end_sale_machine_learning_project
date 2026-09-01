select *
from  customers
limit 20;

select *
from  `products (1)`

limit 20;

select *
from  `sales (1)`
;

select *
from  stores

limit 20;

select *
from  calendar

limit 20;

-- Data cleaning 

-- customer id

create table stagings_customers like customers;
insert into stagings_customers
select*
from customers;

select *
from stagings_customers;

-- removing duplicates

select*, row_number() over(partition by customer_id,age,join_date) as row_num
from stagings_customers;

with customer_cst as (
select*, row_number() over(partition by customer_id,age,join_date) as row_num
from stagings_customers)
select *
from customer_cst
where row_num>1;
-- there is no duplicate in customer table

-- handling null value

select *
from stagings_customers
where customer_id='' or customer_id is null;

select *
from stagings_customers
where age='' or age is null;

select *
from stagings_customers
where gender='' or gender is null;

select *
from stagings_customers
where join_date='' or join_date is null;


-- after using null and empty value we noticed that there ere not null values

-- standardizing customer table

select distinct join_date
from stagings_customers;
select *
from stagings_customers
where join_date  like 'C%';
update stagings_customers
set join_date =null
where join_date like 'C%';
update stagings_customers 
set join_date=str_to_date(join_date,'%Y-%m-%d');

select distinct gender
from stagings_customers;

update stagings_customers
set gender = null
where gender like 'P%';

select *
from stagings_customers;

select distinct age
from stagings_customers;

select distinct customer_id
from stagings_customers
order by customer_id asc;

update stagings_customers
set customer_id= null
where customer_id like '0R%'
-- WE set them as null it was respecting custimer id terms
;

select distinct loyalty_member
from stagings_customers;

-- after finshing cleaning customers table let's clean  sales table

select *
from  `products (1)`;

-- creating stagings product

create table staging_product like `products (1)`;

insert into staging_product 
select *
from  `products (1)`;

-- removing duplicates from staging product table
select*,row_number() over(partition by product_id,brand,category,weight_g) as row_num
from staging_product;

-- creating cts to check if there are any duplicates
with st_product as(select*,row_number() over(partition by product_id,brand,category,weight_g) as row_num
from staging_product)
select *
from st_product
where row_num>1;

-- after using row number to remove duplicate we release that there are no duplicates

-- standardization

select distinct product_id
from staging_product
order by product_id asc;

-- first anomaly we release is that there are som e order id in product id so we will be replacing them by null

update staging_product set
product_id=null
where product_id like "0R%";

select *
from staging_product;

select distinct product_name
from staging_product;


select *
from staging_product
where product_name like "20%";

-- the product name we notice some date inside the column so we will be replacing it with null values

update staging_product set
product_name= null
where product_name like "20%";

select distinct brand
from staging_product;

select *
from staging_product
where brand like "P%";

update staging_product set
brand= null
where brand like "P%";

select distinct category
from staging_product;

update staging_product set
category= null
where category like "S%";

select distinct weight_g
from staging_product;

-- handling null value of staging ptoduct


select*
from staging_product
where product_id is  null or product_name is null or brand is null or category is null;

delete 
from staging_product
where product_id is  null and product_name is null and brand is null and category is null;

delete 
from staging_product
where product_id is  null and product_name is null and brand is null ;

delete 
from staging_product
where product_id is  null ;


-- i deleted every row there were not any  product id because product id is the only element with we can join other table

-- now cleaning sale dataset

select *
from  `sales (1)`;

create table staging_sales like `sales (1)`;

insert into staging_sales

select *
from  `sales (1)`;

select*
from staging_sales;
-- removing duplicates
select*,row_number() over(partition by order_id,order_date,store_id,product_id
,customer_id,quantity) as row_num
from staging_sales;

with st_sales as(select*,row_number() over(partition by order_id,order_date,store_id,product_id
,customer_id,quantity) as row_num
from staging_sales)
select *
from st_sales
where row_num>1;

-- there were no duplicates

-- standardization

select*
from staging_sales
;





select distinct order_date
from staging_sales;

update staging_sales set
order_date=str_to_date(order_date,'%Y-%m-%d');

select distinct order_date
from staging_sales;

select*
from staging_sales
where order_id NOT LIKE '0R%';
-- cleaning store table

select *
from  stores;

-- removing duplicates


create table staging_store like stores;

insert into staging_store
select *
from  stores;

select *
from  staging_store;

select *,row_number() over(partition by store_id,store_name,city,country,store_type) as row_num
from  staging_store;

with st_store as (select *,row_number() over(partition by store_id,store_name,city,country,store_type) as row_num
from  staging_store)
select*
from st_store
where row_num>1;
-- there is no duplicate 

-- standardization


select distinct country
from  staging_store;

update staging_store set
country= null
where country like 'S%';


select distinct city
from  staging_store
where city not like 'P%';

update staging_store set
city= null
where city like 'P%';

select distinct store_type
from  staging_store;


update staging_store set
store_type= null
where store_type like 'C%'

;


select distinct store_name
from  staging_store;

select distinct store_name
from staging_store
where store_name not like 'Ch%';

update staging_store set
store_name=null
where store_name like '20%'
;

select distinct store_id
from  staging_store;

select distinct store_id
from  staging_store
where store_id not like 'S%';

update staging_store set
store_id= null
where store_id not like 'S%';


update staging_store set
country="USA" where city="New York" ;
update staging_store set
country="Australia" where city="Sydney" or city="Melbourne";
update staging_store set
country="Canada" where city="Toronto";
update staging_store set
country="UK" where city="London";
update staging_store set
country="Germeny" where city="Berlin";


update staging_store set
city="New York" where country="USA" ;
update staging_store set
country="Australia" where city="Sydney" or city="Melbourne";
update staging_store set
city="Toronto" where country="Canada";
update staging_store set
city="London" where country="UK";
update staging_store set
city="Berlin" where country="Germeny" ;
update staging_store set
country="Australia" where city="Sydney";



-- data analysis

select*
from staging_sales;
select*
from stagings_customers;
select*
from staging_product;
select*
from staging_store;
-- descriptive statistics

select min(quantity) as Mini_quantity,
round(max(quantity),2) as max_quantity,
sum(quantity) AS total_quantity,
round(avg(quantity),2) as average_quantity,
round(stddev(quantity),2) as standard_deviation_quanity
from staging_sales
;
-- the minum quantity sold was 1 unit
-- the maximum quantity sold was 5 units
-- the average of quantity sold was 2.99 around 3 units
-- with a standard deviation of 1.4 around 2 (because there is no half units)
-- that means that quntity sold vary around 2
-- the total quanity sold was 13 506 units

select min(unit_price) as Mini_unit_price,
round(max(unit_price),2) as max_unit_price,
sum(unit_price) AS total_unit_price,
round(avg(unit_price),2) as average_unit_price,
round(stddev(unit_price),2) as standard_deviation_unit_price
from staging_sales
;
-- the minum (unit_price was 3
-- the maximum unit_price  was 15
-- the average of unit_price  was 9.05 
-- with a standard deviation of 3.42 
-- that means that unit_price vary around 3.42
-- the total unit_price was 40 925.87
select min(discount) as Mini_discount,
round(max(discount),2) as max_discount,
sum(discount) AS total_discount,
round(avg(discount),2) as average_discount,
round(stddev(discount),2) as standard_deviation_discount
from staging_sales
;
-- the minum discount  was 0
-- the maximum discount  was 0.2(2%)
-- the average of discount was 0.06(0.6%)
-- with a standard deviation of 0.08(0.8%)
-- that means that discount  vary around 0.8%
-- the total discount was 250.59

select min(revenue) as Mini_revenue,
round(max(revenue),2) as max_revenue,
sum(revenue) AS total_revenue,
round(avg(revenue),2) as average_revenue,
round(stddev(revenue),2) as standard_deviation_revenue
from staging_sales
;
-- the minum revenue get from a sales  was 2.55
-- the maximum revenue get from a sales  was 75
-- the average of revenue get from a sales was 25.41
-- with a standard revenue get from a sales of 16.02
-- that means that revenue get from a sales  vary around 16.02
-- the total revenue get from a sales was 114 964.89

select min(cost) as mini_cost,
round(max(cost),2) as max_cost,
sum(cost) AS total_cost,
round(avg(cost),2) as average_cost,
round(stddev(cost),2) as standard_deviation_cost
from staging_sales
;
-- the minum cost by unit  was 1.49
-- the maximum cost by unit  was 52.37
-- the average of cost by unit was 15.27
-- with a standard cost by unit of 9.82
-- that means that cost by unit  vary around 9.82
-- the total cost by unit was 69 101.76
select min(profit) as Mini_profit,round(max(profit),2) as max_profit,sum(profit) AS total_profit,round(avg(profit),2) as average_profit,round(stddev(profit),2) as standard_deviation_profit
from staging_sales
;

-- the minum profit get from a sales  was 0.87
-- the maximum profit get from a sales  was 37.23
-- the average of profit get from a sales was 10.14
-- with a standard profit get from a sales of 6.59
-- that means that profit get from a sales  vary around 6.59
-- the total profit get from a sales was 45 863.47

select*
from staging_sales;

select*
from stagings_customers;


-- analysing sales by gender
select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id;


select gender, 
min(quantity) as Mini_quantity,
round(max(quantity),2) as max_quantity,
sum(quantity)/sum(sum(quantity)) over ()*100 AS total_quantity,
round(avg(quantity),2) as average_quantity,
round(stddev(quantity),2) as standard_deviation_quanity
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id) as join_table1
group by gender
;

-- max and min quntity bought by Male and Female ramained the same 1 unit as min and 5 units as the max
-- 52.57% of the quantity sold was was  made by male and 47.06 ws made by female
-- the avergae of quantity bought by a male was 3.10 around 4 (because there is not half units)
-- with a standard deviation 1.39 around 2 that means the quantity vary around 2 from the average
-- the average of quantity bought by female was 2.95 around 3 
-- with standard deviation 1.37 around 2 that means the quantity vary around 2 from the average

select gender,min(unit_price) as Mini_unit_price,
round(max(unit_price),2) as max_unit_price,
round(sum(unit_price)/sum(sum(unit_price)) over() *100,2) AS total_unit_price,
round(avg(unit_price),2) as average_unit_price,
round(stddev(unit_price),2) as standard_deviation_unit_price
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id) as join_table1
group by gender;

-- the cheapest units that a Male bought costed 3.02 and the most enspensive costed 14.98
-- the cheapest units that a female bought costed 3.14 and the most enspensive costed 14.97
-- the avergae of unit price for  male customer coted 8.96  per unit 
-- with a standard deviation 3.47 that means the unit price vary around  the average  by 3.47
-- the avergae of unit price for  female customer coted 8.65  per unit 
-- with a standard deviation 3.39 that means the unit price vary around  the average  by 3.39

select gender, 
min(discount) as Mini_discount,
round(max(discount),2)as max_discount,
 round(sum(discount)/sum(sum(discount)) over() *100,2) AS total_discount,
 round(avg(discount),2)as average_discount,
 round(stddev(discount),2) asstandard_deviation_discount
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id) as join_table1
group by gender
;
-- the  min discount made for a customer was 0% and the max discount made was 2% (for male and female)
-- the mal got the 51.13% of the to total discount and the female got the 48.87% of the total discount
-- the average distcount was 0.5% for male and female with a standard deviation of 0.7%(vary from the average by 0.7%)

select gender, 
min(revenue) as Mini_revenue,
round(max(revenue),2) as max_revenue,
round(sum(revenue)/sum(sum(revenue)) over()*100,2) AS total_revenue,
round(avg(revenue),2) as average_revenue,
round(stddev(revenue),2) as standard_deviation_revenue
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id) as join_table1
group by gender
;
-- the min revenue generated by male customer was 3.07 and the max was 74.75
-- the min revenue generated by female customer was 2.75 and the max was 69.2
-- the male customer generated 54.69% of the revenue and female customer generated 45.79% of the revenue
-- the average of revenue generated by a male customer was 26.43 and that everage vary around 16.5
-- the average of revenue generated by a female customer was 23.99 and that everage vary around 14.96


select gender,
min(cost) as mini_cost,
round(max(cost),2) as max_cost,
round(sum(cost)/sum(sum(cost)) over()*100) AS total_cost,
round(avg(cost),2) as average_cost,
round(stddev(cost),2) as standard_deviation_cost
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id) as join_table1
group by gender
;
-- the min cost of  a product bought by male was 1.92 and the max was 51.5
-- the min cost of  a product bought by female was 1.87 and the max was 44.31
-- the male product costed 54% of the cost and female product costed 46% of the total product cost
-- the female costed less than male product
-- the average cost by male product was 15.92 and vary by 10.27
-- the average cost by male product was 14.34 and vary by 9.1

select gender,
min(profit) as Mini_profit,
round(max(profit),2) as max_profit,
round(sum(profit)/sum(sum(profit)) over() *100,2) AS total_profit,
round(avg(profit),2) as average_profit,
round(stddev(profit),2) as standard_deviation_profit
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,emp1.profit,
             emp2.gender,emp2.age
from staging_sales as emp1
inner join  stagings_customers as emp2
on emp1.customer_id=emp2.customer_id) as join_table1
group by gender
;
-- the min profit generated by a male custome was 0.93 and the max was 30.03
-- the min profit generated by a female custome was 0.87 and the max was 31.52
-- the male generated 53.48% of the total profit and the female generated 46.11%
-- the man generated more revenue than female
-- the average of profit generated by a male was 10.51 and vary around 6.71
-- the average of profit generated by a female was 9.64 and vary around 6.2



-- analysing sales by country,city and store_type


select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id
;

select country,min(quantity) as Mini_quantity,
round(max(quantity),2) as max_quantity,
round(sum(quantity)/sum(sum(quantity)) over() *100,2) AS total_quantity,
round(avg(quantity),2) as average_quantity,
round(stddev(quantity),2) as standard_deviation_quanity
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
order by total_quantity desc
;
-- Australia sold 29.52% of the toatl quantity(top sales country)
-- Canada sold 23.82% of the toatl quantity(second top saler)
-- UK sold 20.31% of the toatl quantity(third top saler)
-- USA sold 13.61% of the toatl quantity
-- Germeny sold 10.37% of the toatl quantity
-- France sold 2.38% of the toatl quantity
select country, min(unit_price) as Mini_unit_price,
round(max(unit_price),2) as max_unit_price,
round(sum(unit_price)/sum(sum(unit_price)) over() *100,2) AS total_unit_price,
round(avg(unit_price),2) as average_unit_price,
round(stddev(unit_price),2) as standard_deviation_unit_price
from  (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
;
-- the min price was 3 and the max was 14.99 in Canada,Australia and USA
-- UK the min unit price was 3.01 and the max was 15
-- France the min unit price was 3.13 and the max was 14.97
-- UK the min unit price was 3.12 and the max was 15

select country,min(discount) as Mini_discount,
round(max(discount),2) as max_discount,
round(sum(discount)/sum(sum(discount)) over()*100,2) AS total_discount,
round(avg(discount),2) as average_discount,
round(stddev(discount),2) as standard_deviation_discount
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
order by total_discount desc
;
-- Australia has made 30.46% of the total discount
-- Canada has made 21.59% of the total discount
-- Uk has made 21.46% of the total discount
-- USA has made 14.47% of the total discount
-- Germeny has made 9.95% of the total discount
-- France has made 2.06% of the total discount


select country,min(revenue) as Mini_revenue,
round(max(revenue),2) as max_revenue,
round(sum(revenue)/sum(sum(revenue)) over()*100,2) AS total_revenue,
round(avg(revenue),2) as average_revenue,
round(stddev(revenue),2) as standard_deviation_revenue
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
order by total_revenue desc
;
-- Autralia generated 29.51% of the revenue
-- Canada generated 23.99% of the revenue
-- UK generated 20.29% of the revenue
-- USA generated 13.71% of the revenue
-- Germeny generated 10% of the revenue
-- France generated 2.49% of the revenue


select country,min(cost) as mini_cost,
round(max(cost),2) as max_cost,
round(sum(cost)/sum(sum(cost)) over()*100,2) AS total_cost,
round(avg(cost),2) as average_cost,
round(stddev(cost),2) as standard_deviation_cost
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
order by total_cost desc 
;
-- Austrlia  costed 29.45% of the total cost
-- Canada  costed 24.06% of the total cost
-- UK  costed 20.34% of the total cost
-- USA  costed 13.7% of the total cost
-- Germeny  costed 10.02% of the total cost
-- France  costed 2.2% of the total cost
select country, min(profit) as Mini_profit,
round(max(profit),2) as max_profit,
sum(profit) AS total_profit,round(avg(profit),2) as average_profit,
round(stddev(profit),2) as standard_deviation_profit
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
;


-- analysing sales by country and city


select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id
;

select country,city,min(quantity) as Mini_quantity,
round(max(quantity),2) as max_quantity,
sum(quantity) AS total_quantity,
round(avg(quantity),2) as average_quantity,
round(stddev(quantity),2) as standard_deviation_quanity
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country,city
;


select country,city, min(unit_price) as Mini_unit_price,
round(max(unit_price),2) as max_unit_price,
sum(unit_price) AS total_unit_price,
round(avg(unit_price),2) as average_unit_price,
round(stddev(unit_price),2) as standard_deviation_unit_price
from  (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country,city
;

select country,city,min(discount) as Mini_discount,
round(max(discount),2) as max_discount,
sum(discount) AS total_discount,
round(avg(discount),2) as average_discount,
round(stddev(discount),2) as standard_deviation_discount
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country
;


select country,city,min(revenue) as Mini_revenue,
round(max(revenue),2) as max_revenue,
sum(revenue) AS total_revenue,
round(avg(revenue),2) as average_revenue,
round(stddev(revenue),2) as standard_deviation_revenue
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country,city
;


select country,city,min(cost) as mini_cost,
round(max(cost),2) as max_cost,
sum(cost) AS total_cost,
round(avg(cost),2) as average_cost,
round(stddev(cost),2) as standard_deviation_cost
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country,city
;

select country,city, min(profit) as Mini_profit,
round(max(profit),2) as max_profit,
sum(profit) AS total_profit,round(avg(profit),2) as average_profit,
round(stddev(profit),2) as standard_deviation_profit
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.city,
             emp2.country,
             emp2.store_type
from staging_sales as emp1
inner join  staging_store as emp2
on emp1.store_id=emp2.store_id) as join_table2
group by country,city
;



-- analysing product

select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id
;




select brand,category,min(quantity) as Mini_quantity,
round(max(quantity),2) as max_quantity,
sum(quantity) AS total_quantity,
round(avg(quantity),2) as average_quantity,
round(stddev(quantity),2) as standard_deviation_quanity
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id) as join_table3
group by brand,category
;


select country,city, min(unit_price) as Mini_unit_price,
round(max(unit_price),2) as max_unit_price,
sum(unit_price) AS total_unit_price,
round(avg(unit_price),2) as average_unit_price,
round(stddev(unit_price),2) as standard_deviation_unit_price
from  (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id) as join_table3
group by brand,category
;

select brand,category,min(discount) as Mini_discount,
round(max(discount),2) as max_discount,
sum(discount) AS total_discount,
round(avg(discount),2) as average_discount,
round(stddev(discount),2) as standard_deviation_discount
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id) as join_table3
group by brand,category
;


select brand,category,min(revenue) as Mini_revenue,
round(max(revenue),2) as max_revenue,
sum(revenue) AS total_revenue,
round(avg(revenue),2) as average_revenue,
round(stddev(revenue),2) as standard_deviation_revenue
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id) as join_table3
group by brand,category
;


select brand,category,min(cost) as mini_cost,
round(max(cost),2) as max_cost,
sum(cost) AS total_cost,
round(avg(cost),2) as average_cost,
round(stddev(cost),2) as standard_deviation_cost
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id) as join_table3
group by brand,category
;

select brand,category, min(profit) as Mini_profit,
round(max(profit),2) as max_profit,
sum(profit) AS total_profit,round(avg(profit),2) as average_profit,
round(stddev(profit),2) as standard_deviation_profit
from (select emp1.customer_id, 
             emp1.quantity,
             emp1.unit_price,
             emp1.discount,
             emp1.revenue,
             emp1.cost,
             emp1.profit,
             emp2.brand,
             emp2.category
from staging_sales as emp1
inner join  staging_product as emp2
on emp1.product_id=emp2.product_id) as join_table3
group by brand,category
;

select *,
Case
when age<=24 then "Young"
when age<=59 then "Adult"
when age>59 then "Old"
end as age_group
from stagings_customers;


with customer_age_group as(
select *,
Case
when age<=24 then "Young"
when age<=59 then "Adult"
when age>59 then "Old"
end as age_group
from stagings_customers)
select age_group,count(age_group) as total_customer
from customer_age_group
group by age_group
order by age_group asc;



