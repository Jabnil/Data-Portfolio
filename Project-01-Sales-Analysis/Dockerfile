# Use an official Python slim image for a small footprint
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY Project-01-requirements.txt .
RUN pip install --no-cache-dir -r Project-01-requirements.txt

# Copy the rest of the project files
COPY . .

# Command to keep the container running (allows you to exec into it)
CMD ["tail", "-f", "/dev/null"]