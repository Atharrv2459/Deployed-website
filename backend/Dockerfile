FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Remove .env if it exists (use Railway env vars instead)
RUN rm -f .env

# Expose port
EXPOSE 5000

# Start the application
CMD ["node", "index.js"]
