#!/usr/bin/env node

/**
 * Simple API testing script for WingFinder backend
 * 
 * Usage:
 *   node test-api.js http://localhost:3000
 *   node test-api.js https://your-project.vercel.app
 */

const https = require('https');
const http = require('http');

const BASE_URL = process.argv[2] || 'http://localhost:3000';

console.log(`🧪 Testing WingFinder API at: ${BASE_URL}`);

function makeRequest(path, method = 'GET', data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const isHttps = url.protocol === 'https:';
    const client = isHttps ? https : http;

    const options = {
      hostname: url.hostname,
      port: url.port || (isHttps ? 443 : 80),
      path: url.pathname + url.search,
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WingFinder-API-Test/1.0'
      }
    };

    if (data) {
      const jsonData = JSON.stringify(data);
      options.headers['Content-Length'] = Buffer.byteLength(jsonData);
    }

    const req = client.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => body += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(body);
          resolve({ status: res.statusCode, data: json });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });

    req.on('error', reject);
    
    if (data) {
      req.write(JSON.stringify(data));
    }
    
    req.end();
  });
}

async function testAPI() {
  const tests = [
    {
      name: 'Health Check',
      path: '/api/health',
      method: 'GET'
    },
    {
      name: 'API Root',
      path: '/api',
      method: 'GET'
    },
    {
      name: 'Flight Search',
      path: '/api/flights/search?from=NRT&to=PRG&date=2025-08-26&class=economy',
      method: 'GET'
    },
    {
      name: 'Flight Reprice',
      path: '/api/flights/reprice?id=teq_nrt_prg_001',
      method: 'GET'
    },
    {
      name: 'Private Jet Lead',
      path: '/api/leads/private-jet',
      method: 'POST',
      data: {
        name: 'Test User',
        email: 'test@example.com',
        from: 'JFK',
        to: 'LAX',
        date: '2025-09-01',
        passengers: 4,
        message: 'Test private jet inquiry'
      }
    }
  ];

  for (const test of tests) {
    try {
      console.log(`\\n📡 ${test.name}...`);
      const result = await makeRequest(test.path, test.method, test.data);
      
      if (result.status >= 200 && result.status < 300) {
        console.log(`✅ Success (${result.status})`);
        if (typeof result.data === 'object') {
          console.log('📄 Response:', JSON.stringify(result.data, null, 2));
        } else {
          console.log('📄 Response:', result.data);
        }
      } else {
        console.log(`❌ Failed (${result.status})`);
        console.log('📄 Response:', result.data);
      }
    } catch (error) {
      console.log(`💥 Error: ${error.message}`);
    }
  }

  console.log('\\n🎯 API testing complete!');
}

testAPI().catch(console.error);