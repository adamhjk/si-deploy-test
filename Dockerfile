# Use an official lightweight nginx image
FROM nginx:alpine

# Set working directory
WORKDIR /app

# We don't need git in the image
# Copy only necessary files
COPY . .

# Create index.html with commit hash (provided as build arg)
ARG GIT_COMMIT=unknown
RUN echo "Hello ${GIT_COMMIT}" > /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx (default command already works)
CMD ["nginx", "-g", "daemon off;"]
