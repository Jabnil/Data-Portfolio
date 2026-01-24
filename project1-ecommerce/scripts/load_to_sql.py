import pandas as pd
from sqlalchemy import create_engine
import os
import logging

path_dir = os.getcwd()+'/data/processed'
file_path = f'{path_dir}/cleaned_sales_data.csv'
print(file_path)
df = pd.read_csv(file_path)

# 1. Connection configuration
# In Docker, the hostname is the service name 'db'. 
# If running locally (outside Docker), use 'localhost'.
DB_USER = 'analyst'
DB_PASSWORD = 'password123'
DB_HOST = os.getenv('DB_HOST', 'db') 
DB_PORT = '5432'
DB_NAME = 'ecommerce_sales'

def load_to_postgres():
    # Use environment variable for the connection string
    db_url = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
    engine = create_engine(db_url)
    
    try:
        path_dir = os.getcwd()+'data/processed/'
        file_path = f'{path_dir}/cleaned_sales_data.csv'
        df = pd.read_csv(file_path)
        
        with engine.begin() as connection:
            df.to_sql('sales_data', con=connection, if_exists='replace', index=False)
            
        logging.info("✅ Data successfully loaded into PostgreSQL.")
    except Exception as e:
        logging.error(f"❌ Load failed: {e}")

if __name__ == "__main__":
    load_to_postgres()