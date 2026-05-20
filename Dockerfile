# Use the official Node.js 20 image as the base
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies deterministically
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Expose port 3000 to the host environment
EXPOSE 3000

# Start the application
CMD [ "npm", "start" ]
