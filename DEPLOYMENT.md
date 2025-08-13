# MyWingsFinder Deployment Guide

## How It Works

This project uses **GitHub Actions** to automatically build and deploy the Flutter web app to **Firebase Hosting**.

## Workflow

1. **Push to main branch** triggers the workflow
2. **GitHub Actions** builds Flutter web in a clean Ubuntu environment
3. **Firebase** automatically deploys the new build

## Benefits

✅ **No more local build issues** - builds happen on GitHub's servers  
✅ **No more path conflicts** - clean environment every time  
✅ **Automatic deployment** - every push = new deployment  
✅ **Consistent builds** - same environment every time  
✅ **Firebase integration** - proper Flutter web hosting  

## Files

- `.github/workflows/deploy.yml` - Firebase deployment workflow

## Setup Required

### Firebase Setup:
- `FIREBASE_SERVICE_ACCOUNT` in GitHub Secrets
- Firebase project configured with hosting

## How to Use

1. **Push your code** to main branch
2. **GitHub Actions** automatically builds and deploys to Firebase
3. **No manual steps** required

## Troubleshooting

- Check GitHub Actions tab for build logs
- Ensure `FIREBASE_SERVICE_ACCOUNT` secret is configured
- Verify Firebase project hosting is enabled
