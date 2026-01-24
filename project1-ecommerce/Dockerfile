FROM python:3.11-slim

# Prevent Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Install system dependencies for psycopg2
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

COPY p1-requirements.txt .
RUN pip install --no-cache-dir -r p1-requirements.txt

COPY . .

# Create a non-root user for security
RUN useradd -m analyst
USER analyst

CMD ["python"]