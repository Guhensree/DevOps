# Use an official, lightweight Node.js image for security and performance
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first to leverage Docker layer caching
COPY package*.json ./

# Install only production dependencies for a smaller, safer image
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Requirement: Configuration via environment variables
ENV PORT=3000

# Production Best Practice: Run the application as a non-root user
USER node

# Expose the port the app runs on
EXPOSE $PORT

# Requirement: Built-in Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:$PORT/health || exit 1

# Command to start the application
CMD ["node", "index.js"]
