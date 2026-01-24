#!/bin/bash

# Exit on error
set -e

echo "🛠️ Finalizing environment setup..."

# Install dependencies (already in Dockerfile, but good for local updates)
pip install --user -r p1-requirements.txt

# Give execution permissions to the setup script
chmod +x setup.sh

echo "✅ Environment is ready! Use './setup.sh' to initialize the data pipeline."