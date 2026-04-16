# 🔧 Railway Deployment Troubleshooting Guide

Comprehensive troubleshooting for common Railway deployment issues.

---

## 🚨 Build Failures

### Issue: "npm install" fails
**Symptoms:**
- Build stuck at npm install
- Error about missing dependencies
- Lock file conflicts

**Solutions:**
```bash
# Regenerate lock file locally
rm package-lock.json
npm install
git add -A
git commit -m "Update lock file"
git push

# Or in Railway settings:
# Set Build Command: npm ci --prefer-offline
```

### Issue: "Module not found" error
**Symptoms:**
- Error: Cannot find module 'x'
- Missing dependency warning

**Solutions:**
```bash
# Ensure package.json has all deps
npm install missing-package-name

# Rebuild lock file
npm ci

# Push changes
git add package*.json
git commit -m "Add missing dependencies"
git push
```

### Issue: "Port already in use" during build
**Symptoms:**
- EADDRINUSE: address already in use :::4000

**Solution:**
- This shouldn't happen in Railway as it assigns ports
- Check if you're running multiple instances
- Look at build logs for port conflicts

---

## 🔗 Connection Issues

### Issue: Cannot connect to MongoDB
**Symptoms:**
```
❌ MongoDB Connection Error
MongoNetworkError: connect ECONNREFUSED
```

**Solutions:**

1. **Verify connection string format:**
   ```
   mongodb+srv://username:password@cluster.mongodb.net/food-delivery?retryWrites=true&w=majority
   ```

2. **Check MongoDB username/password:**
   - Go to MongoDB Atlas → Database Access
   - Verify username and password
   - Ensure password doesn't have special chars (or URL-encode them)

3. **IP Whitelist in MongoDB Atlas:**
   ```
   - Go to Network Access
   - Add Railway IPs OR 0.0.0.0/0 (allow all)
   - Wait 5-10 minutes for changes to take effect
   ```

4. **Test connection locally first:**
   ```bash
   # Install mongosh
   npm install -g db
   
   # Connect
   mongosh "mongodb+srv://username:password@cluster.mongodb.net/test"
   ```

5. **Check environment variable:**
   ```bash
   # Railway logs should show MONGO_URL value
   railway logs backend | grep MONGO_URL
   ```

**If Issue Persists:**
- Go to MongoDB Atlas → Clusters
- Click "Connect"
- Choose "Drivers"
- Copy connection string again
- Update Railway environment variable
- Redeploy

---

## 🌐 CORS & API Errors

### Issue: Frontend shows CORS errors
**Symptoms:**
```
Access to XMLHttpRequest at 'https://...' from origin 'https://...' 
has been blocked by CORS policy
```

**Solutions:**

1. **Set FRONTEND_URL in backend .env:**
   ```env
   FRONTEND_URL=https://your-frontend-domain.railway.app
   ADMIN_URL=https://your-admin-domain.railway.app
   ```

2. **Update Railway environment variables:**
   - Go to backend service
   - Settings → Variables
   - Add/update FRONTEND_URL
   - Restart service

3. **Check frontend API URL:**
   ```env
   # frontend/.env
   VITE_API_URL=https://your-backend-domain.railway.app
   ```

4. **Rebuild and redeploy:**
   ```bash
   git add .
   git commit -m "Fix CORS configuration"
   git push  # Triggers automatic redeploy
   ```

### Issue: "API_URL is undefined"
**Symptoms:**
- Frontend can't reach backend
- API requests to undefined URL
- Console shows "undefined/api/food/list"

**Solution:**
```javascript
// Check in browser console (F12)
console.log(import.meta.env.VITE_API_URL)

// Should output: https://your-backend-domain.railway.app
// If undefined, rebuild frontend with correct env var
```

---

## 🐳 Docker Issues

### Issue: "Dockerfile not found"
**Symptoms:**
```
Error: Dockerfile not found in context
```

**Solution:**
1. Set **Root Directory** to `./backend` (for backend service)
2. Toggle off "Dockerfile Scan"
3. Ensure Dockerfile exists in that directory

### Issue: Image too large
**Symptoms:**
- Build taking too long
- Memory issues during build

**Solution:**
- Ensure .dockerignore is present and correct
- Remove node_modules before building: `rm -rf node_modules`
- Use Alpine Linux (already configured)
- Minimize code/dependencies

---

## 💾 Database Issues

### Issue: "Cannot write to database"
**Symptoms:**
- 403 Forbidden errors
- Write operations fail
- Can read but not create

**Solution:**
1. Check MongoDB user permissions:
   ```
   MongoDB Atlas → Database Access
   Edit user → Check roles
   Should have "dbOwner" or "readWriteAnyDatabase"
   ```

2. Check IP whitelist:
   ```
   MongoDB Atlas → Network Access
   Ensure 0.0.0.0/0 or your Railway IPs are whitelisted
   ```

3. Check if database exists:
   ```bash
   mongosh "mongodb+srv://user:pass@host/food-delivery"
   ```

### Issue: "Duplicate key error"
**Symptoms:**
```
E11000 duplicate key error
```

**Solution:**
```javascript
// This happens when unique index data is duplicated
// Check before deployment

// Drop index:
db.users.dropIndex({ email: 1 })

// Or clear database and restart
db.dropDatabase()
```

---

## 🚀 Performance Issues

### Issue: "Service crashes after 20-30 seconds"
**Symptoms:**
- Service restarts repeatedly
- Crash loop visible in logs

**Solution:**
```bash
# Check Railway logs for errors
railway logs backend

# Common causes:
# 1. MongoDB connection failing
# 2. Required env vars missing
# 3. Memory exceeded
# 4. Port conflicts

# Fix env vars and restart
railway restart backend
```

### Issue: "Extremely slow API responses"
**Symptoms:**
- APIs take 10+ seconds
- Timeouts on requests

**Solution:**
1. Check database performance:
   ```bash
   mongosh "mongodb+srv://user:pass@host/food-delivery"
   db.foods.find().explain("executionStats")
   ```

2. Add database indexes:
   ```bash
   db.foods.createIndex({ category: 1 })
   db.orders.createIndex({ userId: 1, createdAt: -1 })
   ```

3. Check Railway metrics:
   - CPU usage
   - Memory usage
   - Network I/O

4. Upgrade if needed (Railway settings → Upgrade plan)

---

## 🔑 Environment & Secrets

### Issue: "Environment variables not loading"
**Symptoms:**
- VITE_API_URL is undefined in frontend
- API URL shows "undefined"

**Solution:**
1. **For Vite (Frontend/Admin):**
   ```javascript
   // Must start with VITE_
   // CORRECT: VITE_API_URL
   // WRONG: API_URL
   ```

2. **Add variable in Railway:**
   - Service → Settings → Variables
   - Name: `VITE_API_URL`
   - Value: `https://backend-domain.railway.app`
   - Redeploy

3. **Rebuild to load new vars:**
   ```bash
   # Trigger rebuild
   git add .
   git commit -m "Trigger rebuild"
   git push
   ```

### Issue: "Cannot find JWT_SECRET"
**Symptoms:**
- JWT authentication fails
- "Error: JWT_SECRET not found"

**Solution:**
```bash
# Generate new secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Add to Railway backend service
DEPLOY_HOOK: Trigger rebuild for secret to load
```

---

## 📊 Monitoring & Logs

### How to Read Railway Logs

**Backend logs:**
```bash
railway logs backend -n 100  # Last 100 lines
```

**Frontend logs:**
```bash
railway logs frontend -n 100
```

**Real-time logging:**
```bash
railway logs backend -f  # Follow logs
```

**Search in logs:**
```bash
railway logs backend | grep "error"
railway logs backend | grep "MONGO"
```

---

## 🔄 Redeployment

### Force Redeploy
```bash
# Option 1: Push empty commit
git commit --allow-empty -m "Force redeploy"
git push

# Option 2: Using Railway CLI
railway up --force

# Option 3: In Railway dashboard
# Service → Deployment History → Redeploy
```

### Rollback to Previous Version
```bash
# Option 1: Via git
git log
git revert <commit-hash>
git push

# Option 2: Via Railway (if available)
# Deployment History → Rollback button
```

---

## 📞 Getting Help

**Railway Support:**
- Dashboard → Help → Support
- Email: support@railway.app
- Community: https://railway.app/feedback

**Useful Commands:**
```bash
# View status
railway status

# View all services
railway list

# View service details
railway service backend

# View all environment variables
railway variables

# Pull current env vars
railway variables > .env.local
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Health check endpoint returns 200
  ```bash
  curl https://backend-domain.railway.app/health
  ```

- [ ] API endpoints respond
  ```bash
  curl https://backend-domain.railway.app/api/food/list
  ```

- [ ] Frontend loads
  ```
  Visit https://frontend-domain.railway.app
  ```

- [ ] Admin loads
  ```
  Visit https://admin-domain.railway.app
  ```

- [ ] Can create user (test registration)

- [ ] Can login

- [ ] API calls work from frontend

- [ ] Images display correctly

---

## 🆘 Emergency Steps

If everything is broken:

1. **Stop services (if necessary):**
   ```bash
   railway service stop backend
   ```

2. **Check recent changes:**
   ```bash
   git log -5
   ```

3. **Revert last commit:**
   ```bash
   git revert HEAD
   git push
   ```

4. **Clear Railway cache:**
   - Service → Settings → Clear Build Cache
   - Trigger rebuild

5. **Contact Railway Support:**
   - Dashboard → Help → Support
   - Include: Error message, logs, environment setup

---

## 📚 Additional Resources

- [Railway Docs - Troubleshooting](https://docs.railway.app/troubleshooting)
- [MongoDB Atlas Support](https://www.mongodb.com/support)
- [Express.js Documentation](https://expressjs.com)
- [Vite Documentation](https://vitejs.dev)

---

**Last Updated**: January 2024
**For Deployment**: See [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)
