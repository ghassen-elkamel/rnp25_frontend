#!/bin/bash

# Stop and remove existing container 
docker stop rnp25-frontend || true
docker rm rnp25-frontend || true

# Build the image with no cache
echo "Building Docker image with no cache..."
docker build --no-cache -t rnp25-flutter-web .

# Run the new container
echo "Starting new container..."
docker run -d -p 8081:80 --name rnp25-frontend rnp25-flutter-web

echo "Done! The application should be available at http://localhost:8081" 