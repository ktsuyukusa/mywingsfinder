/**
 * POST /api/leads/private-jet - Submit private jet lead to brokers
 */

import { VercelRequest, VercelResponse } from '@vercel/node';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, User-Agent');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const leadData = req.body;
    console.log('Private jet lead submitted:', leadData);

    // TODO: Implement email sending to private jet brokers
    // You can use services like:
    // - SendGrid
    // - Nodemailer with SMTP
    // - Resend
    // - EmailJS
    
    // For now, just log and return success
    
    res.status(200).json({ 
      ok: true, 
      message: 'Lead submitted to private jet brokers',
      lead_id: `pj_${Date.now()}`
    });
  } catch (error) {
    console.error('Private jet lead error:', error);
    res.status(500).json({ error: 'Lead submission failed' });
  }
}