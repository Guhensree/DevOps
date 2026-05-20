FROM node:20-alpine

# Set to production environment
ENV NODE_ENV production

# Create app directory
WORKDIR /usr/src/app

# Copy dependency files
# Note: package-lock.json is required for npm ci
COPY package*.json ./

# Install dependencies deterministically
RUN npm ci --only=production

# Copy application code
COPY . .

# Run as non-root user
USER node

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
