#!/bin/bash

# Exit on error
set -e

# Get the latest Git commit SHA (short version)
GIT_SHA=$(git rev-parse --short HEAD)

# Define image name
IMAGE_NAME="nginx-commit"

# Build the Docker image and tag with both "latest" and the Git SHA
# Pass the git commit SHA as a build argument
docker build \
  --build-arg GIT_COMMIT=$GIT_SHA \
  -t $IMAGE_NAME:latest \
  -t $IMAGE_NAME:$GIT_SHA \
  .

echo "✅ Built image:"
echo "  - $IMAGE_NAME:latest"
echo "  - $IMAGE_NAME:$GIT_SHA"

