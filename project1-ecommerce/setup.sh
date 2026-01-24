#!/bin/bash

# --- Configuration ---
PROJECT_NAME="Ecommerce-ETL-Pipeline"
DB_CONTAINER="ecommerce_db"
APP_CONTAINER="ecommerce_analysis"
DB_USER="analyst"
DB_NAME="ecommerce_sales"

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Helper Functions ---
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 1. Prerequisite Checks
log_info "Starting setup for ${PROJECT_NAME}..."

if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed. Please install it to continue."
fi

if ! docker info &> /dev/null; then
    log_error "Docker is not running. Please start the Docker Desktop app."
fi

# 2. Check for Port Conflicts
if lsof -Pi :5432 -sTCP:LISTEN -t >/dev/null ; then
    log_warn "Port 5432 is already in use. Ensure no other Postgres instance is running."
fi

# 3. Spin up Containers
log_info "Building and starting Docker containers..."
docker compose down --remove-orphans # Clean start
docker compose up -d --build

# 4. Wait for Database Health
log_info "Waiting for PostgreSQL to be healthy..."
MAX_RETRIES=30
COUNT=0

until [ "$(docker inspect -f '{{.State.Health.Status}}' ${DB_CONTAINER})" == "healthy" ]; do
    if [ $COUNT -ge $MAX_RETRIES ]; then
        log_error "Database failed to become healthy in time."
    fi
    printf "."
    sleep 2
    ((COUNT++))
done
echo -e "\n"

# 5. Initialize SQL Schema
log_info "Initializing database schema..."
docker exec -i ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} < sql/schema_setup.sql || log_error "SQL Schema setup failed."

# 6. Run the ETL Pipeline
log_info "Step 1/3: Generating Mock Data..."
docker exec ${APP_CONTAINER} python scripts/mock_data_generator.py || log_error "Data generation failed."

log_info "Step 2/3: Cleaning Data (IQR Method)..."
docker exec ${APP_CONTAINER} python scripts/data_cleaning.py || log_error "Data cleaning failed."

log_info "Step 3/3: Loading to PostgreSQL..."
docker exec -e DB_HOST=db ${APP_CONTAINER} python scripts/load_to_sql.py || log_error "Database load failed."

# 7. Final Verification
log_info "Verifying data record count..."
ROW_COUNT=$(docker exec -i ${DB_CONTAINER} psql -U ${ analyst} -d ${DB_NAME} -t -c "SELECT count(*) FROM sales_data;")
log_info "Success! ${ROW_COUNT} rows are now ready for analysis."

echo -e "${GREEN}---------------------------------------------------"
echo -e "🚀 SETUP COMPLETE: Your environment is live!"
echo -e "Database: localhost:5432"
echo -e "Next Step: Run sql/analysis_queries.sql to see insights."
echo -e "---------------------------------------------------${NC}"