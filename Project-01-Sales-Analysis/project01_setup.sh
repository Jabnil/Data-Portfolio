#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Project 1 Environment..."

# 1. Start Docker containers in the background
docker compose up -d

echo "⏳ Waiting for PostgreSQL to be ready..."

# 2. Loop until Postgres is accepting connections
# This prevents the schema script from failing if the DB is still booting
until docker exec ecommerce_db pg_isready -U analyst -d ecommerce_sales; do
  sleep 2
done

echo "✅ Database is up! Initializing schema..."

# 3. Run the schema setup script
docker exec -i ecommerce_db psql -U analyst -d ecommerce_sales < sql/schema_setup.sql

echo "🧹 Running data cleaning and ETL pipeline..."

# 4. Run the Python scripts inside the analysis container
chmod u+x notebooks/mock_data_generator.py
docker exec ecommerce_analysis python notebooks/mock_data_generator.py


#docker exec ecommerce_analysis python notebooks/data_cleaning.py
#docker exec -e DB_HOST=db ecommerce_analysis python notebooks/load_to_sql.py

echo "---------------------------------------------------"
echo "🎉 Setup Complete!"
echo "Database: localhost:5432 (User: analyst, DB: ecommerce_sales)"
echo "Next Step: Run analysis_queries.sql"
echo "---------------------------------------------------"