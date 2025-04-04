# GitHub Workflow for Container Deployment

This repository demonstrates a GitHub Actions workflow that automates building a Docker container, pushing it to AWS ECR, and deploying it using System Initiative!

## Workflow Overview

The workflow performs these key tasks:
1. Builds a Docker container with the git commit SHA
2. Pushes the container to AWS ECR
3. Triggers a System Initiative deployment

## Setting Up the Workflow

### Required Secrets

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

| Secret Name | Description |
|-------------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key with ECR permissions |
| `AWS_SECRET_ACCESS_KEY` | Secret key for AWS IAM access key |
| `AWS_ACCOUNT_ID` | Your AWS account ID (e.g., `123456789012`) |
| `AWS_SESSION_TOKEN` | Required if using temporary AWS credentials |
| `SI_API_TOKEN` | System Initiative API token |

### Workflow File

Create a file at `.github/workflows/deploy.yml`:

```yaml
name: Build, Push and Deploy

on:
  push:
    branches:
      - main

# Ensures only one workflow runs at a time on main branch
concurrency:
  group: main-branch-deployment
  cancel-in-progress: false

jobs:
  build-push-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Build and Push to ECR
        uses: kciter/aws-ecr-action@v5
        with:
          access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          account_id: ${{ secrets.AWS_ACCOUNT_ID }}
          repo: your-repo-name/your-image-name
          region: us-west-2  # Change to your AWS region
          tags: latest,${{ github.sha }}
          extra_build_args: "--build-arg GIT_COMMIT=${{ github.sha }}"
          path: .
        env:
          AWS_SESSION_TOKEN: ${{ secrets.AWS_SESSION_TOKEN }}

      - name: Trigger System Initiative Deployment
        uses: systeminit/actions@v0.1
        with:
          changeSet: GHA-Deploy-${{ github.sha }}
          componentId: YOUR-COMPONENT-ID  # Replace with your SI component ID
          managementFunction: deployNewEcsTask  # Replace with your function name
          domain: |
            Image: ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-west-2.amazonaws.com/your-repo-name/your-image-name:${{ github.sha }}
          apiToken: ${{ secrets.SI_API_TOKEN }}
          waitForActions: true
          applyOnSuccess: force
```

### Dockerfile Requirements

Your Dockerfile should accept the git commit as a build argument:

```dockerfile
FROM nginx:alpine
WORKDIR /app
COPY . .
ARG GIT_COMMIT=unknown
RUN echo "Hello ${GIT_COMMIT}" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Key Configuration Points

1. **AWS ECR Action (kciter/aws-ecr-action)**
   - Handles both building and pushing the Docker image
   - Uses `extra_build_args` to pass the git SHA to the container build
   - Requires AWS credentials and region

2. **System Initiative Action (systeminit/actions)**
   - Deploys the container using the specified management function
   - Passes the full ECR image URL including the SHA tag
   - Uses `applyOnSuccess: force` to automatically approve changes

3. **GitHub Trigger**
   - Activates on push to the main branch
   - You can modify the branch or add other triggers as needed

4. **Concurrency Control**
   - Prevents multiple workflow runs from executing simultaneously
   - New workflows wait until current ones complete (with `cancel-in-progress: false`)
   - Ensures deployments happen sequentially on the main branch
