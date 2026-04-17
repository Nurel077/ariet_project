FROM node:18-alpine

WORKDIR /app

# Set Node environment to production
ENV NODE_ENV=production

# Copy package files FIRST
COPY package*.json ./

# Install dependencies with correct npm flag
RUN npm ci --omit=dev

# Copy the rest of the app
COPY . .

EXPOSE 4000

# Use node directly for production (not nodemon)
CMD ["node", "server.js"]
