# Use Node.js LTS Debian slim base image with current security patches
FROM node:23-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* pnpm-lock.yaml* ./

# Install dependencies
RUN npm install -g pnpm && pnpm install

# Copy source code
COPY . .

# Create bug_buckets directory for mounting
RUN mkdir -p /app/src/assets/bug_buckets

# Create build command script
RUN printf '%s\n' '#!/bin/sh' 'echo "Starting RESTler Report Parser..."' 'echo "Bug buckets directory: /app/src/assets/bug_buckets"' 'ls -la /app/src/assets/bug_buckets/ || echo "No files in bug_buckets yet."' 'echo "Rebuilding site with mounted data..."' 'pnpm build' > /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

# Run the build command script
CMD ["/app/entrypoint.sh"]
