# Build stage
FROM node:18-alpine AS build

WORKDIR /app

COPY package.json ./

RUN npm ci

COPY . .

# Build the Vite app
RUN npm run build

# Production stage - use serve for hosting
FROM node:18-alpine

WORKDIR /app

# Install serve globally
RUN npm install -g serve

# Copy built app from build stage
COPY --from=build /app/dist ./dist

EXPOSE 5173

# Serve the built app
CMD ["serve", "-s", "dist", "-l", "5173"]
