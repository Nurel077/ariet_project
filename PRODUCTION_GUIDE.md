# 🔒 Production Configuration Guide

This guide explains all production settings and best practices for deploying on Railway.

## Environment Variables

### Backend Environment Variables

#### **Required Variables**

```env
# Server
NODE_ENV=production          # Must be "production"
PORT=4000                    # Port number (Railway sets this automatically)

# Database
MONGO_URL=mongodb+srv://username:password@cluster.mongodb.net/food-delivery?retryWrites=true&w=majority

# Authentication
JWT_SECRET=your-very-long-random-secret-key-minimum-32-characters

# Frontend URLs (for CORS)
FRONTEND_URL=https://your-frontend-url.railway.app
ADMIN_URL=https://your-admin-url.railway.app
```

#### **Optional Variables**

```env
# Stripe Integration
STRIPE_API_KEY=sk_live_your_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_secret_here

# File Upload
UPLOAD_DIR=/app/uploads
MAX_FILE_SIZE=10485760    # 10MB in bytes

# Logging (if using external service)
LOG_LEVEL=info
LOG_SERVICE=your_logging_service
```

### Frontend Environment Variables

```env
VITE_API_URL=https://your-backend-domain.railway.app
VITE_ENV=production
```

### Admin Environment Variables

```env
VITE_API_URL=https://your-backend-domain.railway.app
VITE_ENV=production
```

## Database Configuration

### Option 1: MongoDB Atlas (Recommended)

Pros:
- Fully managed
- Automatic backups
- High availability
- Free tier available

Steps:
1. Create account at [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Create a new cluster
3. Create a database user with strong password
4. Get connection string: `mongodb+srv://username:password@cluster.mongodb.net/food-delivery?retryWrites=true&w=majority`
5. Add Railway IPs to whitelist (or allow all: 0.0.0.0/0)
6. Set as `MONGO_URL` environment variable

### Option 2: Railway MongoDB

Pros:
- Simple integration
- No external service needed

Steps:
1. In Railway project, click "Create"
2. Select "Database" → "MongoDB"
3. Connection string auto-populated
4. Connect to backend service

## Security Settings

### JWT Secret Generation

Generate a strong JWT secret:

```bash
# On macOS/Linux
openssl rand -base64 32

# Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Online generator (use with caution)
# https://generate-secret.now.sh/32
```

### Password Hashing

Backend uses `bcrypt` with salt rounds = 10. This is production-ready.

### CORS Configuration

The backend automatically configures CORS based on `FRONTEND_URL`:

```javascript
cors({
  origin: process.env.FRONTEND_URL || "*",
  credentials: true
})
```

Ensure `FRONTEND_URL` is set to your production domain.

## Performance Optimization

### 1. Database Indexes

MongoDB should have indexes on frequently queried fields:

```javascript
// Automatically created by Mongoose schemas
// Make sure these are defined:
db.foods.createIndex({ "category": 1 })
db.orders.createIndex({ "userId": 1, "createdAt": -1 })
db.users.createIndex({ "email": 1 }, { unique: true })
```

### 2. Build Optimization

Vite build is already optimized:
- Minified code
- Tree-shaking enabled
- Code splitting configured
- Source maps disabled in production

### 3. Docker Image Optimization

Current Dockerfiles use:
- Alpine Linux (smaller than full Node image)
- Multi-stage builds for frontend/admin
- Production-only dependencies in backend

Image sizes:
- Backend: ~150MB
- Frontend: ~100MB
- Admin: ~100MB

### 4. Caching Strategy

Set cache headers in production:
- Static assets: 30 days
- HTML: 1 hour
- API responses: no cache

## Monitoring & Logging

### Health Checks

Backend has two endpoints:

```bash
# Application health
GET /health
Response: { status: "healthy", timestamp: "2024-01-15T10:30:00Z" }

# API status
GET /
Response: { 
  status: "OK",
  message: "🚀 Food Delivery API is Running",
  timestamp: "2024-01-15T10:30:00Z"
}
```

### Logging

Configure in backend:

```javascript
// All endpoints log to console
// Railway captures logs automatically
console.log("✅ Message")   // Success
console.error("❌ Error")   // Error
console.warn("⚠️ Warning")  // Warning
```

### Error Tracking (Optional)

For production error tracking, integrate:
- Sentry
- LogRocket
- Rollbar
- New Relic

## Deployment Security Checklist

- [ ] No hardcoded secrets in code
- [ ] All secrets in environment variables
- [ ] JWT_SECRET is strong (32+ chars, random)
- [ ] MONGO_URL uses strong password
- [ ] HTTPS enforced on frontend
- [ ] CORS properly configured
- [ ] Rate limiting implemented (if needed)
- [ ] Input validation on all endpoints
- [ ] SQL injection protected (using Mongoose)
- [ ] XSS protection enabled
- [ ] CSRF tokens implemented (if needed)
- [ ] File upload size limited
- [ ] API keys rotated regularly

## Database Backup Strategy

### MongoDB Atlas Automatic Backups

- Enabled by default
- Retention: 7-90 days (depends on plan)
- Restore from snapshots anytime

### Manual Backup

```bash
# Export database
mongoexport --uri="mongodb+srv://user:pass@host/db" \
  --collection=foods \
  --out=foods_backup.json

# Import database
mongoimport --uri="mongodb+srv://user:pass@host/db" \
  --collection=foods \
  --file=foods_backup.json
```

## Scaling Strategy

### Vertical Scaling
- Increase Railway plan
- More CPU/Memory per instance

### Horizontal Scaling
```bash
railway scale backend=2  # 2 instances of backend
```

### Load Balancing
Railway automatically load-balances across instances.

## Disaster Recovery

### Backup Plan
1. Automated MongoDB backups
2. Git repository backup (on GitHub)
3. Weekly manual snapshot exports

### Recovery Process
1. Restore MongoDB from backup
2. Redeploy from git commit
3. Test all endpoints
4. Verify data integrity

## Cost Optimization

### Railway Pricing
- Free tier: 5 GB/month RAM
- Pay-as-you-go: $0.001/hour per GB
- Estimate: ~$5-10/month for basic setup

### Tips to Reduce Costs
- Use free MongoDB Atlas tier
- Scale down during low traffic
- Remove unused services
- Cache API responses
- Compress assets

## SSL/TLS Configuration

Railway automatically provides HTTPS with Let's Encrypt:
- Generated automatically
- Auto-renewal enabled
- No manual configuration needed

## Rate Limiting (Recommended)

Add rate limiting to prevent abuse:

```bash
npm install express-rate-limit
```

In backend server.js:
```javascript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use(limiter);
```

## API Key Rotation

### For Stripe
Keep secrets in environment variables. To rotate:
1. Generate new key in Stripe dashboard
2. Update Railway environment variable
3. Restart services

### For JWT
- Already uses environment variable
- To rotate: Generate new secret and update RAILWAY env var
- Existing tokens remain valid until expiry

## Troubleshooting Production Issues

### Service keeps restarting
```bash
# Check logs
railway logs

# Look for database connection errors
railway logs --service=backend
```

### Out of memory
```bash
# Increase Railway plan
# Or optimize code
# Check memory leaks: npm audit
```

### Slow responses
```bash
# Add database indexes
# Enable caching
# Optimize queries
# Check Railway metrics dashboard
```

## Monitoring Tools

### Railway Built-in
- Logs viewer
- Metrics dashboard
- Deployment history

### External Tools
- New Relic (APM)
- Datadog (Monitoring)
- PagerDuty (Alerts)
- Sentry (Error tracking)

---

**Last Updated**: 2024
**For Railway Deployment**: See [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)
