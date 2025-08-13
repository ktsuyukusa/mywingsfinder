# MyWingsFinder Deployment Guide

## How It Works

This project uses **GitHub Actions** to automatically build and deploy the Flutter web app.

## Workflow

1. **Push to main branch** triggers the workflow
2. **GitHub Actions** builds Flutter web in a clean Ubuntu environment
3. **Build files** are automatically committed back to the repository
4. **Vercel** (or other hosting) automatically deploys the new build

## Benefits

✅ **No more local build issues** - builds happen on GitHub's servers  
✅ **No more path conflicts** - clean environment every time  
✅ **Automatic deployment** - every push = new deployment  
✅ **Consistent builds** - same environment every time  

## Files

- `.github/workflows/build-and-deploy.yml` - Main workflow
- `.github/workflows/deploy.yml` - Alternative Firebase workflow

## Setup Required

### For Vercel (Current):
- `VERCEL_TOKEN` in GitHub Secrets
- `ORG_ID` in GitHub Secrets  
- `PROJECT_ID` in GitHub Secrets

### For Firebase (Alternative):
- `FIREBASE_SERVICE_ACCOUNT` in GitHub Secrets

## How to Use

1. **Push your code** to main branch
2. **GitHub Actions** automatically builds and deploys
3. **No manual steps** required

## Troubleshooting

- Check GitHub Actions tab for build logs
- Ensure secrets are properly configured
- Verify hosting service integration
