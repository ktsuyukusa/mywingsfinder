/**
 * WingFinder Flight Search API
 * Vercel Serverless Functions backend
 * 
 * Main API router for all endpoints
 */

import { VercelRequest, VercelResponse } from '@vercel/node';
import cors from 'cors';
import express from 'express';

const app = express();

// Configure CORS for your app domain
const corsOptions = {
  origin: [
    'https://wingfinder.com',
    'https://www.wingfinder.com',
    'http://localhost:3000', // For development
    /\.wingfinder\.com$/ // Any subdomain
  ],
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'User-Agent']
};

app.use(cors(corsOptions));
app.use(express.json());

// GET /api - API information
app.get('/', (req, res) => {
  res.json({ 
    name: 'WingFinder API',
    version: '1.0.0',
    endpoints: [
      'GET /api/flights/search',
      'GET /api/flights/reprice', 
      'POST /api/leads/private-jet',
      'GET /api/health'
    ]
  });
});

// GET /api/health - API health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    platform: 'vercel',
    configured_apis: Object.keys(process.env).filter(key => 
      key.includes('API_KEY') && process.env[key] !== ''
    ).length
  });
});

// Handle all requests through Express app
export default function handler(req: VercelRequest, res: VercelResponse) {
  return new Promise((resolve) => {
    app(req, res, resolve);
  });
}