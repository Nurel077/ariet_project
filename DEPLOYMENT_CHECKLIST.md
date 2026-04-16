# Production deployment checklist for Railway

## Pre-Deployment Checklist

### Code Quality
- [ ] All code is committed and pushed to main branch
- [ ] No console.log() statements left for sensitive data
- [ ] Environment variables are properly configured
- [ ] All dependencies are listed in package.json

### Backend Configuration
- [ ] `.env.example` has all required variables documented
- [ ] MongoDB connection string is prepared
- [ ] JWT_SECRET is strong (minimum 32 characters)
- [ ] CORS is configured correctly
- [ ] Error handling is in place
- [ ] Health check endpoint is working
- [ ] File upload limits are set appropriately

### Frontend Configuration
- [ ] `.env.example` has API URL template
- [ ] Build output is optimized
- [ ] No hardcoded API URLs
- [ ] Error boundary is implemented
- [ ] Loading states are handled

### Docker Configuration
- [ ] Dockerfiles are production-ready
- [ ] .dockerignore files are created for each service
- [ ] Build process completes without errors
- [ ] Images are small and optimized

### Security
- [ ] No credentials in code
- [ ] All secrets are in environment variables
- [ ] HTTPS is enforced
- [ ] CORS is properly configured
- [ ] Rate limiting is implemented
- [ ] Input validation is in place

### Database
- [ ] MongoDB connection tested
- [ ] Database indexes are created
- [ ] Backup strategy is in place
- [ ] Database user has minimal required permissions

### Monitoring & Logging
- [ ] Logging is configured
- [ ] Error tracking is set up
- [ ] Health checks are working
- [ ] Performance monitoring is enabled

## Deployment Steps

1. **Prepare Environment**
   ```bash
   # Ensure all changes are committed
   git add .
   git commit -m "Prepare for Railway deployment"
   git push origin main
   ```

2. **Create Railway Project**
   - Login to Railway.app
   - Connect GitHub repository
   - Authorize Railway to access your repo

3. **Configure Services**
   - Add backend service (set root directory to ./backend)
   - Add frontend service (set root directory to ./frontend)
   - Add admin service (set root directory to ./admin)
   - Add MongoDB (or use MongoDB Atlas)

4. **Set Environment Variables**
   - Backend:
     ```
     NODE_ENV=production
     MONGO_URL=mongodb+srv://user:password@cluster.mongodb.net/food-delivery
     JWT_SECRET=your_strong_secret_here
     PORT=4000
     ```
   - Frontend:
     ```
     VITE_API_URL=https://your-backend-domain.railway.app
     ```
   - Admin:
     ```
     VITE_API_URL=https://your-backend-domain.railway.app
     ```

5. **Deploy Services**
   - Deploy backend first
   - Wait for successful deployment
   - Get the domain URL
   - Update frontend and admin environment variables
   - Deploy frontend and admin

6. **Verify Deployment**
   - Test health endpoint
   - Test API endpoints
   - Check frontend loads correctly
   - Check admin loads correctly

7. **Configure Domains**
   - Set up custom domains in Railway
   - Update DNS records
   - Test HTTPS connections

## Post-Deployment

- [ ] Monitor logs for errors
- [ ] Test all critical user flows
- [ ] Check performance metrics
- [ ] Verify email sending (if applicable)
- [ ] Test payment processing
- [ ] Monitor database performance
- [ ] Set up alerts for errors

## Rollback Plan

If deployment fails:
```bash
# Switch to previous working version
railway rollback

# Or redeploy from previous commit
git revert <commit-hash>
git push
```

## Common Commands

```bash
# View logs
railway logs

# Check service status
railway status

# View environment variables
railway variables

# Restart a service
railway restart <service-name>

# Scale a service
railway scale backend=2
```

## Support

- Railway Docs: https://docs.railway.app
- GitHub Issues: Check if anyone has reported similar issues
- Railway Community: https://railway.app/feedback
