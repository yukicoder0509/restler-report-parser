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

# Expose port 3000
EXPOSE 4321

# Create entrypoint script
RUN printf '%s\n' '#!/bin/sh' 'echo "Starting RESTler Report Parser..."' 'echo "Bug buckets directory: /app/src/assets/bug_buckets"' 'ls -la /app/src/assets/bug_buckets/ || echo "No files in bug_buckets yet."' 'echo "Rebuilding site with mounted data..."' 'pnpm build' 'echo "Starting web server on port 4321..."' 'exec pnpm preview --host 0.0.0.0 --port 4321' > /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

# Use the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
