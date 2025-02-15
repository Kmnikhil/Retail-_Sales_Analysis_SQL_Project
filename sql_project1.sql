-- PRINT 1ST 10 ROWS
SELECT * FROM retail_sales
LIMIT 10;

-- PRINT ALL COLUMNS
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'retail_sales';


-- CHECKING ANY NULL VALUE PRESENT 
SELECT * FROM retail_sales
WHERE 
	transaction_id is null
	or
	sale_date is null
	or
	total_sale is null
	or
	sale_time iS null
	or
	customer_id is null
	or
	cogs is null
	or
	age is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	gender is null
	or
	category is null;

-- REMOVE THE ROWS WHICH CONTAINS NULL VALUES
DELETE FROM retail_sales
WHERE 
	transaction_id is null
	or
	sale_date is null
	or
	total_sale is null
	or
	sale_time iS null
	or
	customer_id is null
	or
	cogs is null
	or
	age is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	gender is null
	or
	category is null;

-- COUNT
SELECT COUNT(*) FROM retail_sales;

-- DATA EXPLORATION
-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) AS CUSTOMERS_COUNT FROM retail_sales;

-- WHAT ARE THE UNIQUE CATEGORYS 
SELECT DISTINCT category AS CATEGORIES FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05?
SELECT * FROM retail_sales
	WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
	-- and the quantity sold is more than 4 in the month of Nov-2022?
SELECT * FROM retail_sales
	WHERE category = 'Clothing' and 
		TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' and
		quantity >=	 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(avg(age),2) as AVG_AGE
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale>=1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id)
	-- made by each gender in each category?
SELECT
	gender,
	category,
	COUNT(transaction_id) as TOTAL_NUMBER_OF_TRANSACTION
FROM retail_sales
GROUP BY gender,category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
	sale_year,
	sale_month,
	avg_sale
FROM
	(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS sale_year,
		EXTRACT(MONTH FROM sale_date) AS sale_month,
		ROUND(AVG(total_sale)) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)AS rank
	FROM retail_sales
	GROUP BY sale_year, sale_month
	)AS T1
WHERE rank=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	customer_id,
	SUM(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id )AS no_customer
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)?
WITH hourly_sales
AS
(
SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS no_of_order
FROM hourly_sales
GROUP BY shift

