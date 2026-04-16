# 🚀 Railway Deployment Guide - Food Delivery App

## Prerequisites

- [Railway.app](https://railway.app) account (free tier available)
- Git repository (GitHub, GitLab, or Bitbucket)
- MongoDB Atlas account for database (or Railway MongoDB plugin)
- Docker images built and configured

---

## Step 1: Prepare Your Project

### 1.1 Environment Variables

Your project already has `.env.example` files configured. Railway will automatically read environment variables from the dashboard.

#### Backend Environment Variables Required:
```
NODE_ENV=production
PORT=4000
MONGO_URL=mongodb+srv://username:password@cluster.mongodb.net/food-delivery?retryWrites=true&w=majority
JWT_SECRET=your-very-secure-random-secret-key
STRIPE_API_KEY=your_stripe_key (if using payments)
FRONTEND_URL=https://your-frontend-domain.railway.app
ADMIN_URL=https://your-admin-domain.railway.app
```

#### Frontend Environment Variables:
```
VITE_API_URL=https://your-backend-domain.railway.app
```

#### Admin Environment Variables:
```
VITE_API_URL=https://your-backend-domain.railway.app
```

### 1.2 Database Setup

#### Option A: MongoDB Atlas (Recommended)
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account and cluster
3. Get your connection string: `mongodb+srv://username:password@cluster.mongodb.net/food-delivery?retryWrites=true&w=majority`
4. Add your Railway IPs to the IP whitelist (or allow all IPs: 0.0.0.0/0)

#### Option B: Railway MongoDB Plugin
1. In your Railway project, click "Create"
2. Select "Database" → "MongoDB"
3. Set the environment variable automatically

---

## Step 2: Deploy on Railway

### 2.1 Create Railway Project

1. Login to [Railway.app](https://railway.app)
2. Click **"+ New Project"**
3. Select **"Deploy from GitHub"**
4. Connect your GitHub repository

### 2.2 Deploy Services One by One

#### Deploy Backend (Node.js API)

1. Click **"+ Add Service"**
2. Select **"GitHub Repo"**
3. Choose your repository
4. In the settings, set **Root Directory** to `./backend`
5. Under **"Variables"**, add all the backend environment variables
6. Set **Build Command**: `npm ci`
7. Set **Start Command**: `node server.js`
8. Click **"Deploy"**

Once deployed:
- Copy the generated domain (e.g., `https://backend-production.up.railway.app`)
- Save it for frontend and admin configuration

#### Deploy Frontend (React + Vite)

1. Click **"+ Add Service"**
2. Select **"GitHub Repo"** (same repository)
3. In the settings, set **Root Directory** to `./frontend`
4. Add environment variable:
   ```
   VITE_API_URL=https://your-backend-domain.railway.app
   ```
5. Set **Build Command**: `npm ci && npm run build`
6. Set **Start Command**: `serve -s dist -l 5173`
7. Click **"Deploy"**

#### Deploy Admin (React + Vite)

1. Click **"+ Add Service"**
2. Select **"GitHub Repo"** (same repository)
3. In the settings, set **Root Directory** to `./admin`
4. Add environment variable:
   ```
   VITE_API_URL=https://your-backend-domain.railway.app
   ```
5. Set **Build Command**: `npm ci && npm run build`
6. Set **Start Command**: `serve -s dist -l 5174`
7. Click **"Deploy"**

### 2.3 Connect Services

1. In your project dashboard, go to each service
2. Under the service settings, add the domain URLs to other services' environment variables
3. Example:
   - Backend → Add `FRONTEND_URL` and `ADMIN_URL`
   - Frontend → Add `VITE_API_URL` pointing to backend
   - Admin → Add `VITE_API_URL` pointing to backend

---

## Step 3: Alternative: Deploy from Docker

If you prefer to use Docker directly:

### 3.1 Using Railway CLI

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Link to your Railway project
railway link

# Deploy
railway up
```

### 3.2 Using docker-compose.yml

Railway automatically detects and uses `docker-compose.yml`:

```bash
railway up --dockerCompose
```

---

## Step 4: Configure Custom Domains

1. Go to each service in Railway dashboard
2. Click on **"Settings"**
3. Under **"Domain"**, configure custom domains:
   - Backend: `api.yourdomain.com`
   - Frontend: `www.yourdomain.com` or `yourdomain.com`
   - Admin: `admin.yourdomain.com`
4. Update DNS records with the provided CNAME values

---

## Step 5: Verify Deployment

### Check Backend Health
```bash
curl https://your-backend-domain.railway.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### Check Frontend
Visit: `https://your-frontend-domain.railway.app`

### Check Admin
Visit: `https://your-admin-domain.railway.app`

---

## Step 6: Testing APIs

### Test User Registration
```bash
curl -X POST https://your-backend-domain.railway.app/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@example.com","password":"password123"}'
```

### Test Food List
```bash
curl https://your-backend-domain.railway.app/api/food/list
```

---

## Troubleshooting

### Issue: Backend fails to connect to MongoDB
**Solution**: 
- Verify `MONGO_URL` is correct
- Check IP whitelist in MongoDB Atlas (should include Railway's IPs)
- Check MongoDB user credentials

### Issue: Frontend shows CORS errors
**Solution**:
- Verify `FRONTEND_URL` is set correctly in backend
- Check CORS configuration in `server.js`
- Ensure frontend is using correct `VITE_API_URL`

### Issue: Build fails
**Solution**:
- Check logs in Railway dashboard
- Verify `package-lock.json` or `yarn.lock` is committed
- Ensure Node version is compatible (Node 18+)

### Issue: Service keeps restarting
**Solution**:
- Check the logs in Railway dashboard
- Verify environment variables are correctly set
- Check health check endpoint is responding

---

## Performance Optimization

1. **Enable Caching**
   - Set cache headers in frontend
   - Use CDN for static assets

2. **Database Optimization**
   - Create proper indexes in MongoDB
   - Use MongoDB Atlas Performance Advisor

3. **Monitoring**
   - Enable Railway monitoring
   - Set up alerts for errors
   - Monitor memory and CPU usage

---

## Useful Railway Commands

```bash
# View logs
railway logs

# View status
railway status

# Restart service
railway restart

# Scale service
railway scale web=2

# View environment variables
railway variables

# Push and deploy
railway up
```

---

## Security Checklist

- [ ] Set strong `JWT_SECRET` (use random generator)
- [ ] Enable MongoDB authentication
- [ ] Use HTTPS for all connections
- [ ] Set proper CORS origins
- [ ] Limit API rate limiting
- [ ] Enable environment variable encryption
- [ ] Use Railway's built-in integrations for secrets
- [ ] Keep dependencies updated

---

## Support & Resources

- [Railway Documentation](https://docs.railway.app)
- [Railway Community](https://railway.app/feedback)
- [MongoDB Atlas Help](https://www.mongodb.com/support)
- [Vite Configuration](https://vitejs.dev/config/)

---

## Quick Start Summary

```bash
# 1. Push code to GitHub
git push origin main

# 2. Connect Railway to your GitHub repo
# 3. Add environment variables in Railway dashboard
# 4. Deploy backend first
# 5. Get backend domain and add to frontend/admin vars
# 6. Deploy frontend and admin
# 7. Test all endpoints
# 8. Configure custom domains if needed
```

---

Generated: 2024
Prepared for: Food Delivery Application on Railway
