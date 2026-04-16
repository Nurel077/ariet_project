#!/bin/bash

# Setup script for Food Delivery Application
# This script prepares your environment for development or deployment

set -e

echo "🚀 Food Delivery App - Setup Script"
echo "===================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install it first.${NC}"
    exit 1
fi

NODE_VERSION=$(node -v)
echo -e "${GREEN}✅ Node.js ${NODE_VERSION} found${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker is not installed. You can still run locally without Docker.${NC}"
    DOCKER_INSTALLED=false
else
    echo -e "${GREEN}✅ Docker installed${NC}"
    DOCKER_INSTALLED=true
fi

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"

echo "Installing backend dependencies..."
cd backend
npm install
cd ..

echo "Installing frontend dependencies..."
cd frontend
npm install
cd ..

echo "Installing admin dependencies..."
cd admin
npm install
cd ..

echo -e "${GREEN}✅ Dependencies installed${NC}"

# Create environment files
echo -e "${YELLOW}🔧 Setting up environment variables...${NC}"

if [ ! -f "backend/.env" ]; then
    cp backend/.env.example backend/.env
    echo -e "${GREEN}✅ Created backend/.env${NC}"
else
    echo -e "${YELLOW}⚠️  backend/.env already exists${NC}"
fi

if [ ! -f "frontend/.env" ]; then
    cp frontend/.env.example frontend/.env
    echo -e "${GREEN}✅ Created frontend/.env${NC}"
else
    echo -e "${YELLOW}⚠️  frontend/.env already exists${NC}"
fi

if [ ! -f "admin/.env" ]; then
    cp admin/.env.example admin/.env
    echo -e "${GREEN}✅ Created admin/.env${NC}"
else
    echo -e "${YELLOW}⚠️  admin/.env already exists${NC}"
fi

# Create uploads directory
if [ ! -d "backend/uploads" ]; then
    mkdir -p backend/uploads
    touch backend/uploads/.gitkeep
    echo -e "${GREEN}✅ Created uploads directory${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"

echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Edit environment files (if needed):"
echo "   - backend/.env"
echo "   - frontend/.env"
echo "   - admin/.env"
echo ""

if [ "$DOCKER_INSTALLED" = true ]; then
    echo "2. Start Docker containers:"
    echo "   docker-compose up --build"
    echo ""
fi

echo "3. Or run services individually:"
echo "   - Backend: cd backend && npm run server"
echo "   - Frontend: cd frontend && npm run dev"
echo "   - Admin: cd admin && npm run dev"
echo ""
echo "4. For Railway deployment:"
echo "   - Read: RAILWAY_DEPLOYMENT.md"
echo "   - Check: DEPLOYMENT_CHECKLIST.md"
echo ""
echo "5. Visit URLs:"
echo "   - Frontend: http://localhost:5173"
echo "   - Admin: http://localhost:5174"
echo "   - Backend API: http://localhost:4000"
echo ""
