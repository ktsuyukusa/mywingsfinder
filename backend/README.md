# WingFinder API Backend

Vercel Serverless Functions backend for the WingFinder flight search app.

## 🚀 Quick Deploy to Vercel

### 1. **Install Vercel CLI**
```bash
npm install -g vercel
```

### 2. **Login to Vercel**
```bash
vercel login
```

### 3. **Install Dependencies**
```bash
cd backend/
npm install
```

### 4. **Set Environment Variables**
Copy the example environment file and fill in your API keys:
```bash
cp .env.example .env
# Edit .env with your actual API keys
```

### 5. **Deploy to Vercel**
```bash
vercel --prod
```

After deployment, you'll get a URL like:
`https://your-project-name.vercel.app`

### 6. **Configure Environment Variables in Vercel Dashboard**
In your Vercel dashboard, add the following environment variables:
- `TEQUILA_API_KEY`
- `TRAVELPAYOUTS_API_KEY` 
- `TRAVELPAYOUTS_MARKER`
- `DUFFEL_API_KEY`
- `AMADEUS_API_KEY`
- `AMADEUS_API_SECRET`

## 🛠 **Local Development**
```bash
# Install dependencies
npm install

# Start development server
npm run dev
# or
vercel dev
```

Your API will be available at `http://localhost:3000`

## 📋 **API Endpoints**

- `GET /flights/search` - Search flights across providers
- `GET /flights/reprice` - Reprice specific offer  
- `POST /leads/private-jet` - Submit private jet lead
- `GET /health` - Health check

## 🔑 **Getting API Keys**

### Tequila/Kiwi API
1. Sign up at https://partners.kiwi.com/
2. Apply for API access
3. Get your API key from dashboard

### Travelpayouts API  
1. Register at https://www.travelpayouts.com/
2. Go to API section
3. Get API key and affiliate marker

### Duffel API (Optional)
1. Sign up at https://duffel.com/
2. Get API key from dashboard
3. Note: Requires business verification

### Amadeus API (Optional)
1. Register at https://developers.amadeus.com/
2. Create app to get API key & secret
3. Start with Self-Service tier