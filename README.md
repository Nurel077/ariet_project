# 🍅 TOMATO - Food Ordering Platform (Production Ready)

> A full-stack MERN application for online food ordering with admin management system. **Ready for Railway deployment!**

[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](https://nodejs.org)
[![React Version](https://img.shields.io/badge/react-%3E%3D18.0.0-blue)](https://react.dev)
[![Docker](https://img.shields.io/badge/docker-ready-blue?logo=docker)](https://www.docker.com)
[![Railway](https://img.shields.io/badge/Railway-ready-blue)](#-railway-deployment)

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Running Locally](#-running-locally)
- [Railway Deployment](#-railway-deployment)
- [API Documentation](#-api-documentation)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### User Panel
- 🛒 Add products to cart
- 🛍️ Place and manage orders
- 👤 User authentication & profile
- 🔐 JWT-based sessions
- 📱 Responsive design
- 🔍 Filter and search products
- 💳 Stripe payment integration

### Admin Panel
- 📊 Dashboard with statistics
- 🍔 Manage food items (CRUD)
- 📦 Order management
- 📸 Image upload for products
- 👥 User management
- 📈 Analytics

### Backend
- 🔐 JWT Authentication
- 🔒 Password hashing with Bcrypt
- 🗄️ MongoDB with Mongoose
- ✅ Input validation
- 🛡️ CORS protection
- 📤 File upload handling
- 💳 Stripe integration

## 🛠️ Tech Stack

### Frontend & Admin
- **React 18** - UI library
- **Vite** - Build tool
- **React Router v6** - Routing
- **Axios** - HTTP client
- **CSS3** - Styling
- **React Toastify** - Notifications

### Backend
- **Node.js** - Runtime
- **Express.js** - API framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **Bcrypt** - Password hashing
- **Stripe** - Payment processing
- **Multer** - File uploads

### DevOps
- **Docker** - Containerization
- **Railway** - Deployment platform

## 📁 Project Structure

```
├── backend/                 # Node.js Express API
│   ├── config/             # Database configuration
│   ├── controllers/        # Route handlers
│   ├── models/             # MongoDB schemas
│   ├── routes/             # API routes
│   ├── middleware/         # Authentication & validation
│   ├── uploads/            # Uploaded files
│   ├── Dockerfile          # Production Docker config
│   ├── server.js           # Express app entry
│   └── package.json        # Dependencies
│
├── frontend/               # React SPA for users
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   ├── pages/          # Page components
│   │   ├── context/        # React context
│   │   ├── assets/         # Images & icons
│   │   └── App.jsx         # Main component
│   ├── Dockerfile          # Production Docker config
│   └── package.json        # Dependencies
│
├── admin/                  # React SPA for admin
│   ├── src/
│   │   ├── components/     # Admin components
│   │   ├── pages/          # Admin pages
│   │   ├── context/        # React context
│   │   └── App.jsx         # Main component
│   ├── Dockerfile          # Production Docker config
│   └── package.json        # Dependencies
│
├── docker-compose.yml      # Multi-container setup
├── .dockerignore            # Docker excludes
└── README.md               # This file
```

## 📋 Prerequisites

- **Node.js** >= 18.0.0
- **npm** or **yarn**
- **Docker** (optional, for containerization)
- **MongoDB** or **MongoDB Atlas** account
- **Stripe** account (for payments)

## 🚀 Installation

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/food-delivery
cd food-delivery
```

### 2. Quick Setup (Recommended)

**Windows:**
```bash
.\setup.bat
```

**macOS/Linux:**
```bash
bash setup.sh
```

### 3. Manual Setup

**Backend:**
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your credentials
```

**Frontend:**
```bash
cd frontend
npm install
cp .env.example .env
# Set VITE_API_URL=http://localhost:4000
```

**Admin:**
```bash
cd admin
npm install
cp .env.example .env
# Set VITE_API_URL=http://localhost:4000
```

## 🎯 Running Locally

### Option 1: Using Docker (Easiest)

```bash
# Start all services
docker-compose up --build

# Services will be available at:
# Frontend: http://localhost:5173
# Admin: http://localhost:5174
# Backend: http://localhost:4000
```

### Option 2: Running Services Individually

**Terminal 1 - Backend:**
```bash
cd backend
npm run server
# API running at http://localhost:4000
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
# Running at http://localhost:5173
```

**Terminal 3 - Admin:**
```bash
cd admin
npm run dev
# Running at http://localhost:5174
```

### Environment Variables

Create `.env` files based on `.env.example`:

**backend/.env:**
```env
NODE_ENV=development
PORT=4000
MONGO_URL=mongodb://localhost:27017/food-delivery
JWT_SECRET=your_jwt_secret
STRIPE_API_KEY=your_stripe_key
```

**frontend/.env:**
```env
VITE_API_URL=http://localhost:4000
```

**admin/.env:**
```env
VITE_API_URL=http://localhost:4000
```

## 🚂 Railway Deployment

This project is **fully configured for Railway deployment**! Follow the comprehensive guide:

### Quick Start

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Ready for Railway deployment"
   git push origin main
   ```

2. **Create Railway Project**
   - Go to [Railway.app](https://railway.app)
   - Click "New Project" → "Deploy from GitHub"
   - Select your repository

3. **Deploy Services**
   - Add backend service (root: `./backend`)
   - Add frontend service (root: `./frontend`)
   - Add admin service (root: `./admin`)
   - Add MongoDB (use Railway or MongoDB Atlas)

4. **Configure Environment Variables**
   - Set all variables from `.env.example` files
   - Update cross-service URLs

### Detailed Guide

See [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md) for complete step-by-step instructions.

### Deployment Checklist

Check [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) before deploying.

## 📡 API Documentation

### Base URL
```
http://localhost:4000
```

### Authentication
All protected routes require JWT token in headers:
```
Authorization: Bearer <token>
```

### Endpoints

#### User Routes
```
POST   /api/user/register    - Register new user
POST   /api/user/login       - Login user
GET    /api/user/profile     - Get user profile
```

#### Food Routes
```
GET    /api/food/list        - Get all food items
POST   /api/food/add         - Add food item (admin)
DELETE /api/food/:id         - Delete food item (admin)
```

#### Cart Routes
```
POST   /api/cart/add         - Add to cart
POST   /api/cart/remove      - Remove from cart
POST   /api/cart/get         - Get cart items
```

#### Order Routes
```
POST   /api/order/place      - Place order
GET    /api/order/userorders - Get user orders
GET    /api/order/list       - Get all orders (admin)
```

## 🐳 Docker Commands

```bash
# Build images
docker-compose build

# Start services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Remove volumes
docker-compose down -v
```

## 🔧 Development

### Project Setup
```bash
# Install dependencies for all services
npm install --workspaces

# Or setup individually
cd backend && npm install
cd ../frontend && npm install
cd ../admin && npm install
```

### Code Quality
```bash
# Lint frontend
cd frontend && npm run lint

# Format code (if configured)
prettier --write .
```

## 🐛 Troubleshooting

### MongoDB Connection Error
- Verify MongoDB is running (local or Atlas)
- Check connection string in `.env`
- Allow IP in MongoDB Atlas whitelist

### CORS Errors
- Ensure `FRONTEND_URL` is set in backend .env
- Check `VITE_API_URL` in frontend .env
- Restart services after changing env vars

### Build Failures
- Clear `node_modules` and reinstall: `rm -rf node_modules && npm install`
- Check Node.js version: `node --version`
- Review Docker logs: `docker-compose logs backend`

### Port Already in Use
```bash
# Kill process using port
lsof -ti:4000 | xargs kill -9  # Unix
netstat -ano | findstr :4000   # Windows
```

## 📚 Additional Resources

- [Vite Documentation](https://vitejs.dev)
- [Express.js Guide](https://expressjs.com)
- [MongoDB Docs](https://docs.mongodb.com)
- [Railway Documentation](https://docs.railway.app)
- [Stripe Documentation](https://stripe.com/docs)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

- **Original Developer**: [Mshandev](https://github.com/Mshandev)
- **Production Readiness**: Updated for Railway deployment

---

<div align="center">

**[Railway Deployment Guide](./RAILWAY_DEPLOYMENT.md)** • 
**[Deployment Checklist](./DEPLOYMENT_CHECKLIST.md)** • 
**[Project Demo](#-features)**

**Made with ❤️ for food lovers**

</div>
Go to the project directory

```bash
    cd Food-Delivery
```
Install dependencies (frontend)

```bash
    cd frontend
    npm install
```
Install dependencies (admin)

```bash
    cd admin
    npm install
```
Install dependencies (backend)

```bash
    cd backend
    npm install
```
Setup Environment Vaiables

```Make .env file in "backend" folder and store environment Variables
  JWT_SECRET=YOUR_SECRET_TEXT
  SALT=YOUR_SALT_VALUE
  MONGO_URL=YOUR_DATABASE_URL
  STRIPE_SECRET_KEY=YOUR_KEY
 ```

Setup the Frontend and Backend URL
   - App.jsx in Admin folder
      const url = YOUR_BACKEND_URL
     
  - StoreContext.js in Frontend folder
      const url = YOUR_BACKEND_URL

  - orderController in Backend folder
      const frontend_url = YOUR_FRONTEND_URL 

Start the Backend server

```bash
    nodemon server.js
```

Start the Frontend server

```bash
    npm start
```

Start the Backend server

```bash
    npm start
```
## Tech Stack
* [React](https://reactjs.org/)
* [Node.js](https://nodejs.org/en)
* [Express.js](https://expressjs.com/)
* [Mongodb](https://www.mongodb.com/)
* [Stripe](https://stripe.com/)
* [JWT-Authentication](https://jwt.io/introduction)
* [Multer](https://www.npmjs.com/package/multer)

## Deployment

The application is deployed on Render.

## Contributing

Contributions are always welcome!
Just raise an issue, and we will discuss it.

## Feedback

If you have any feedback, please reach out to me [here](https://www.linkedin.com/in/muhammad-shan-full-stack-developer/)
