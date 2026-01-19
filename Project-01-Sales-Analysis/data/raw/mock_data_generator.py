# This code will will generate a file named raw_ecommerce_sales.csv 
# with 1,000 rows of data, including intentional errors (missing values, duplicates, and outliers)

import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# Set seed for reproducibility
np.random.seed(42)

# Configuration
num_rows = 1000
categories = ['Electronics', 'Home & Kitchen', 'Fashion', 'Beauty', 'Sports', None]

# 1. Generate Basic Data
data = {
    'order_id': [1000 + i for i in range(num_rows)],
    'order_date': [datetime(2023, 1, 1) + timedelta(days=random.randint(0, 730)) for _ in range(num_rows)],
    'customer_id': [random.randint(1, 200) for _ in range(num_rows)],
    'category': [random.choice(categories) for _ in range(num_rows)],
    'sales_amount': [round(random.uniform(10.0, 500.0), 2) for _ in range(num_rows)],
    'quantity': [random.randint(1, 10) for _ in range(num_rows)],
}

df = pd.DataFrame(data)

# 2. Add "Real-World" Messiness
# Add Profit column (Sales * random margin)
df['profit'] = df['sales_amount'] * np.random.uniform(0.05, 0.30, size=num_rows)

# Add Duplicates (approx 20 rows)
duplicates = df.sample(20)
df = pd.concat([df, duplicates], ignore_index=True)

# Add Missing Values in Order ID (to test dropna)
df.loc[df.sample(5).index, 'order_id'] = np.nan

# Add Outliers/Errors (Negative sales and high outliers)
df.loc[df.sample(5).index, 'sales_amount'] = -50.0 
df.loc[df.sample(2).index, 'sales_amount'] = 50000.0 # Extreme outlier

# 3. Export to CSV
df.to_csv('raw_ecommerce_sales.csv', index=False)

print("File 'raw_ecommerce_sales.csv' has been created with 1,025 rows.")
print("It contains missing values, duplicates, and price outliers.")