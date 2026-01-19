--profit margin analysis
SELECT 
    category,
    SUM(sales_amount) AS total_revenue,
    AVG(profit_margin) AS avg_margin
FROM sales_data
GROUP BY category
HAVING AVG(profit_margin) < (SELECT AVG(profit_margin) FROM sales_data)
ORDER BY avg_margin ASC;

--Year-over-Year (YoY) Growth
WITH YearlySales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS sales_year,
        SUM(sales_amount) AS total_sales
    FROM sales_data
    GROUP BY 1
)
SELECT 
    sales_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_year) AS previous_year_sales,
    ((total_sales - LAG(total_sales) OVER (ORDER BY sales_year)) / 
     LAG(total_sales) OVER (ORDER BY sales_year)) * 100 AS yoy_growth_pct
FROM YearlySales;

--Customer Lifetime Value (CLV)
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(sales_amount) AS total_spent,
    (SUM(sales_amount) / COUNT(order_id)) AS avg_order_value
FROM sales_data
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;
