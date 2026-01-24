import pandas as pd
import numpy as np
import os

input_dir = os.getcwd()+'/data/raw'
print(input_dir)

# 1. Load the raw data
df = pd.read_csv(f'{input_dir}/raw_sales.csv')

# 2. Handling Missing Values
# Fill missing 'Category' with 'Uncategorized' and drop rows without Order IDs
df['category'] = df['category'].fillna('Uncategorized')
df.dropna(subset=['order_id'], inplace=True)

# 3. Data Type Correction
# Ensure dates are datetime objects and prices are floats
df['order_date'] = pd.to_datetime(df['order_date'])
df['sales_amount'] = pd.to_numeric(df['sales_amount'], errors='coerce')

# 4. Removing Duplicates
df.drop_duplicates(inplace=True)

# 5. Outlier/Error Removal
# Remove orders with negative prices or quantities
df = df[(df['sales_amount'] > 0) & (df['quantity'] > 0)]

# 6. Feature Engineering (Creating a Profit Margin column for SQL)
df['profit_margin'] = (df['profit'] / df['sales_amount']) * 100

# 7. Export Clean Data for SQL Import
output_dir = os.getcwd()+'/data/processed'
print(output_dir)

df.to_csv(f'{output_dir}/cleaned_sales_data.csv', index=False)

print("Data Cleaning Complete. Ready for SQL Import.")