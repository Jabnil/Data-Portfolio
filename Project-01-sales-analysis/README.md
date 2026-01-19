E-commerce Performance Deep Dive (SQL & Python)
Goal: Identified $150K in "lost" profit by analyzing underperforming product categories and calculating Year-over-Year (YoY) growth trends across 1,000+ orders.

2. The Business Problem
The executive team observed a stagnation in revenue despite higher marketing spend. This project identifies which categories are dragging down margins and who the highest-value customers are to help reallocate the Q4 budget effectively.

3. Tech Stack
Python (Pandas/NumPy): Data cleaning and outlier detection.

SQL (PostgreSQL): Advanced analysis (Window functions, CTEs).

Tableau/Power BI: Executive-level data visualization.

4. Data Cleaning (The "Python" Phase)
I transformed a "dirty" dataset into a reliable source of truth by:

Standardizing date formats and handling NaN values.

Detecting and removing price outliers ($ > 3$ standard deviations).

Eliminating duplicate entries to prevent revenue inflation.

5. Key SQL Insights
YoY Growth: Revenue in the "Fashion" category grew by 12%, while "Electronics" saw a 4% decline.

Profit Margins: 3 out of 6 categories are operating below the company's 15% target margin.

VIP Customers: The top 5% of customers contribute to 22% of total revenue.

6. Business Recommendations
Reallocate Spend: Shift 10% of the "Electronics" marketing budget to "Fashion" for the holiday season.

Loyalty Program: Implement a tiered rewards system for customers with a CLV (Customer Lifetime Value) over $2,000.
