-- inspect data
select * from Orders
select * from Returns

select distinct segment from orders
select distinct category from orders
select distinct sub_category from orders
select distinct ship_mode from orders
select distinct State from orders
select distinct year(order_date) from orders

-- group sales by category
select Category, round(sum(sales),0) as revenue 
from orders
group by Category

-- Top 5 states in revenue
select Top 5 State, round(sum(sales),0) as revenue 
from orders
group by State
order by revenue desc 

-- Top 5 cities in revenue
select Top 5 City, round(sum(sales),0) as revenue 
from orders
group by City
order by revenue desc

-- total customers for each state
select state, count(distinct customer_id) as num_of_customers
from Orders
group by state
order by count(distinct customer_id) desc

-- which product was returned the most?
select 
	Top 1 o.product_name, 
	o.sub_category, 
	o.category, 
	COUNT(o.product_id) as total_returns
from orders o
join returns r
on o.Order_ID = r.Order_ID
group by 
	o.product_name, 
	o.Sub_Category, 
	o.Category
order by total_returns desc

-- which month has the most sales for each year?
with most_sales_month as
(
select 
	year(order_date) as year, 
	month(order_date) as month, 
	sum(sales) as total_sales,
	rank() over (partition by year(order_date) order by sum(sales) desc) as rk
from Orders
group by 
	year(order_date), 
	month(order_date)
)

select year, month, round(total_sales,2)
from most_sales_month
where rk = 1
order by year

-- which product has the most sales in each category?
with most_sales_category as
(
select 
	category, 
	product_name, 
	sum(sales) as total_sales,
	rank() over (partition by category order by sum(sales) desc) as rk
from orders
group by category, product_name
)

select category, product_name, round(total_sales,2)
from most_sales_category
where rk = 1

-- each segment's average profit compared to the overall average profit
select 
	segment, 
	round(avg(profit),2) as avg_profit_segment,
	(select round(avg(profit),2) as avg_profit from orders) as avg_profit
from orders
group by segment
order by avg(profit) desc

-- RFM Analysis
with rfm as
(
select 
	customer_name, 
	round(sum(sales),2) as monetary_value,
	round(avg(sales),2) as avg_monetary_value,
	count(order_id) as frequency,
	max(order_date) as last_order_date,
	(select max(order_date) from orders) as max_order_date,
	datediff(day, max(order_date), (select max(order_date) from orders)) as recency
from orders
group by Customer_Name
),

rfm_calc as
(
select 
	*,
	ntile(4) over (order by recency desc) as rfm_recency,
	ntile(4) over (order by frequency) as rfm_frequency,
	ntile(4) over (order by monetary_value) as rfm_monetary
from rfm
)

select 
	*,
	rfm_recency + rfm_frequency + rfm_monetary as rfm_score,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary as varchar) as rfm_score_string
into #rfm
from rfm_calc

select 
	customer_name, 
	rfm_recency, 
	rfm_frequency, 
	rfm_monetary,
	case
		when rfm_score_string in (111,112,121,122,123,132,114,141,211,212) then 'lost_customers'
		when rfm_score_string in (133,134,143,244,334,343,344,144) then 'slipping away, cannot lose'
		when rfm_score_string in (311,411,421,331) then 'new customers'
		when rfm_score_string in (222,223,233,322) then 'potential churners'
		when rfm_score_string in (433,434,443,444) then 'loyal'
		else 'active'
	end rfm_segment
from #rfm