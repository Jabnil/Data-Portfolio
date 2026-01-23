import pandas as pd
from sqlalchemy import create_engine
import os

# 1. Connection configuration
# In Docker, the hostname is the service name 'db'. 
# If running locally (outside Docker), use 'localhost'.
DB_USER = 'analyst'
DB_PASSWORD = 'password123'
DB_HOST = os.getenv('DB_HOST', 'localhost') 
DB_PORT = '5432'
DB_NAME = 'ecommerce_sales'

# Create the connection string
connection_string = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
engine = create_engine(connection_string)

def load_data():
    try:
        # 2. Load the cleaned CSV
        file_path = '/workspaces/Data-Portfolio/Project-01-Sales-Analysis/data/processed/cleaned_sales_data.csv'
        df = pd.read_csv(file_path)
        
        # Convert date column to ensure SQL recognizes it correctly
        df['order_date'] = pd.to_datetime(df['order_date'])

        # 3. Load into SQL
        # 'if_exists="replace"' creates the table automatically
        df.to_sql('sales_data', engine, if_exists='replace', index=False)
        
        print(f"✅ Successfully loaded {len(df)} rows into the 'sales_data' table.")
        
    except Exception as e:
        print(f"❌ Error occurred: {e}")

if __name__ == "__main__":
    load_data()