import os
import pandas as pd
from sqlalchemy import create_engine

# 1. Test Directory Creation (The fix for your error)
output_folder = 'data/output'
if not os.path.exists(output_folder):
    os.makedirs(output_folder)
    print(f"✅ Created directory: {output_folder}")

# 2. Test Database Connection
# Using the env variable you defined in docker-compose.yml
db_url = os.getenv('DATABASE_URL', 'postgresql://analyst:password123@db:5432/ecommerce_sales')

try:
    engine = create_engine(db_url)
    # Create a dummy dataframe
    df = pd.DataFrame({'test_col': [1, 2, 3], 'status': ['connected', 'working', 'perfect']})
    
    # Try writing to Postgres
    df.to_sql('connection_test', engine, if_exists='replace', index=False)
    print("✅ Successfully wrote to Postgres!")
    
    # 3. Test File Saving (The Volume Check)
    file_path = os.path.join(output_folder, 'test_results.csv')
    df.to_csv(file_path, index=False)
    print(f"✅ Successfully saved file to: {file_path}")

except Exception as e:
    print(f"❌ Error: {e}")