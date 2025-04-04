#!/bin/bash

set -e

# Configurable variables
ACCOUNT_ID="104640795146"
REGION="us-west-2"
REPO_NAME="adamhjk/demodeploy"
IMAGE_NAME="nginx-commit"

# Get the short Git SHA
GIT_SHA=$(git rev-parse --short HEAD)

# Full ECR URL
ECR_URL="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"

# Authenticate with ECR
#echo "🔐 Logging into ECR..."
#aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Tag images
echo "🏷️ Tagging images..."
docker tag $IMAGE_NAME:latest $ECR_URL:latest
docker tag $IMAGE_NAME:$GIT_SHA $ECR_URL:$GIT_SHA

# Push both tags
echo "📤 Pushing to ECR..."
docker push $ECR_URL:latest
docker push $ECR_URL:$GIT_SHA

echo "✅ Done! Pushed:"
echo "  - $ECR_URL:latest"
echo "  - $ECR_URL:$GIT_SHA"

