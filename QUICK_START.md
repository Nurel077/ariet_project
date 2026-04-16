# ⚡ Railway Quick Start (5 Minutes)

Get your Food Delivery app live on Railway in 5 minutes!

## Prerequisites (2 mins)
- ✅ GitHub account with repository
- ✅ Railway account (free tier available)
- ✅ MongoDB Atlas account (free tier available)

## Step 1: Create MongoDB Connection (1 min)

1. Go to [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Create cluster and user
3. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/food-delivery?retryWrites=true&w=majority
   ```

## Step 2: Deploy on Railway (3 mins)

### 2.1 Connect GitHub
1. Login to [Railway.app](https://railway.app)
2. Click **"New Project"**
3. Select **"Deploy from GitHub"**
4. Connect your repository

### 2.2 Deploy Backend
1. Click **"+ Service"**
2. Select **"GitHub Repo"**
3. Root Directory: `./backend`
4. Add Environment Variables:
   ```
   NODE_ENV=production
   PORT=4000
   MONGO_URL=mongodb+srv://username:password@cluster.mongodb.net/food-delivery
   JWT_SECRET=your-random-secret-here
   ```
5. Click **"Deploy"**
6. Copy the generated domain (e.g., `backend-prod.railway.app`)

### 2.3 Deploy Frontend
1. Click **"+ Service"**
2. Select **"GitHub Repo"**
3. Root Directory: `./frontend`
4. Add Environment Variable:
   ```
   VITE_API_URL=https://backend-prod.railway.app
   ```
5. Click **"Deploy"**

### 2.4 Deploy Admin
1. Click **"+ Service"**
2. Select **"GitHub Repo"**
3. Root Directory: `./admin`
4. Add Environment Variable:
   ```
   VITE_API_URL=https://backend-prod.railway.app
   ```
5. Click **"Deploy"**

## Step 3: Verify Deployment (1 min)

```bash
# Check backend
curl https://backend-prod.railway.app/health

# Visit frontend
https://frontend-prod.railway.app

# Visit admin
https://admin-prod.railway.app
```

## ✅ Done! 🎉

Your app is now live on Railway!

---

## 📚 For More Details

- Full guide: [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)
- Checklist: [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)
- Production settings: [PRODUCTION_GUIDE.md](./PRODUCTION_GUIDE.md)

## 🆘 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails | Check logs in Railway dashboard |
| Can't connect to DB | Verify MONGO_URL and IP whitelist in MongoDB Atlas |
| CORS errors | Ensure FRONTEND_URL is set in backend env vars |
| Services restarting | Check environment variables are all set |

---

**Need the long version? Read [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)**
