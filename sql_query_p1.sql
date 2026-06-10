--create table
Drop table IF EXISTS retail_sales;
create table retail_sales 
(
transactions_id INT PRIMARY KEY,
sale_date	DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(15),
age INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit	FLOAT,
cogs FLOAT,
total_sale FLOAT
);

select * from retail_sales
Limit 10;

-- count number of data
select count(*)
from retail_sales;

--Data cleaning 
select *from retail_sales
where transactions_id is null
      or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  gender is null
	  or
	  category is null
	  or 
	  age is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or 
	  cogs is null
	  or
	  total_sale is null;

--Data Exploration

--How many sales we have?
select count(*) as total_sale from retail_sales;

--How many uniqucustomer's we have?

select count(distinct  customer_id )as  customer_id 
from retail_sales;

--Q.1 Write a sql query to retrive all columns for sales made on "2022-11-05"

select * from retail_sales
where sale_date = '2022-11-05';

--Q.2 write a sql query to retrieve all transactions where the category is 'cloting' & the quantity sold is more than 10 om the month of nov-2022

select * from retail_sales
where category='Clothing'
      and quantiy>=4
	  and TO_CHAR(sale_date,'YYYY-MM')='2022-11';

--Q.3 write a sql query to calculate the total sales(total_sales) for each category.

select
  category,
  sum(total_Sale) as net_sale
from retail_sales
Group by 1;

--Q.4 Write a SQL query to find average age of customers who purchased items from the 'Beauty' category.

select 
round(avg(age),2) as Average_age
from retail_sales where category='Beauty';

--Q.5 write a SQL query to find all transactions where the total_sales is greater than 1000.

select *from retail_sales 
where total_sale>1000;

--Q.6 write a sql query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,
       gender,
	   count(*) as total_tranc
From retail_sales
group by
      category,
	  gender
order by 1;

--Q.7 Write a sql query to calculate the average sale for each month.Find out best selling month in each year

select year,month,avg_sale 
from
(
select
    Extract(year from sale_date) as year,
	Extract(Month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank()over(partition by extract(year from sale_date) order by avg(total_sale)desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank = 1
--order by 1,3 desc;

--Q.8 write a sql query to find the top customers based on the heighest total sales

select * from retail_sales;

select customer_id,
sum(total_sale) as total_sale 
from retail_sales
group by 1
order by 2 desc
limit 5;

--Q.9 write a sql query to find the number of unique customers who purchased items from each category.

select 
    category,
	count(distinct customer_id)
from retail_sales
group by category

--Q.10 write a sql query to create each shift and number of orders(Example Morning<=12,Afternoon between 12 & 17,Evening>17)

with hourly_sale
as
(select * ,
  CASE
  when extract(Hour From sale_time) <12 then 'Morning'
  when extract(Hour From sale_time) Between 12 and 17 then 'Afternoon'
  else 'Evening'
END as shift
from retail_sales
)
select shift ,
count(*)as total_order
from hourly_sale
group by shift;


	