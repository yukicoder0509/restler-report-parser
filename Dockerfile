# Use Node.js LTS as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* pnpm-lock.yaml* ./

# Install dependencies
RUN npm ci || (npm install -g pnpm && pnpm install) || npm install

# Copy source code
COPY . .

# Create bug_buckets directory for mounting
RUN mkdir -p /app/bug_buckets

# Build the static site
RUN pnpm run build

# Install a lightweight HTTP server
RUN pnpm add -g serve

# Expose port 3000
EXPOSE 3000

# Create entrypoint script
RUN echo '#!/bin/sh\n\
echo "Starting RESTler Report Parser..."\n\
echo "Bug buckets directory: /app/bug_buckets"\n\
ls -la /app/bug_buckets/\n\
echo "Rebuilding site with mounted data..."\n\
npm run build\n\
echo "Starting web server on port 3000..."\n\
serve -s dist -l 3000' > /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

# Use the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
