# Build stage
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

# Build the Vite app
RUN npm run build

# Production stage - use nginx for serving
FROM node:18-alpine

WORKDIR /app

# Install simple-http-server or use node/express to serve built files
RUN npm install -g serve

# Copy built app from build stage
COPY --from=build /app/dist ./dist

EXPOSE 5173

# Serve the built app
CMD ["serve", "-s", "dist", "-l", "5173"]
