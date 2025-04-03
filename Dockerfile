# Use an official lightweight image with git and nginx
FROM nginx:alpine

# Install git
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Copy the git repo into the image (assumes Dockerfile is in the repo root)
COPY . .

# Get the latest git commit hash and create index.html
RUN git_commit=$(git rev-parse HEAD) && \
    echo "Hello ${git_commit}" > /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx (default command already works)
CMD ["nginx", "-g", "daemon off;"]
