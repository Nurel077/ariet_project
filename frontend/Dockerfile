# Build stage
FROM node:18-alpine AS build

WORKDIR /app

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ .

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
CMD npx serve -s dist -l tcp://0.0.0.0:${PORT:-5173}
