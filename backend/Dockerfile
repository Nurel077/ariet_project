FROM node:18-alpine

WORKDIR /app

# Set Node environment to production
ENV NODE_ENV=production

COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

COPY . .

EXPOSE 4000

# Use node directly for production (not nodemon)
CMD ["node", "server.js"]
