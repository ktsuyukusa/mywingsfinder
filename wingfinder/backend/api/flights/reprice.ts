/**
 * GET /api/flights/reprice - Reprice specific offer before booking
 */

import { VercelRequest, VercelResponse } from '@vercel/node';

// Carrier deeplink templates for direct booking
const CARRIER_DEEPLINKS: { [key: string]: { template: string; supports_roundtrip: boolean } } = {
  'Ryanair': {
    template: 'https://www.ryanair.com/en/booking/home/{origin}/{destination}/{date}?adults={adults}&utm_source=wingfinder&utm_medium=affiliate',
    supports_roundtrip: true
  },
  'Wizz Air': {
    template: 'https://wizzair.com/en-GB/select-flight/from/{origin}/to/{destination}/on/{date}?passengers={adults}&utm_source=wingfinder&utm_medium=affiliate',
    supports_roundtrip: true
  },
  'Scoot': {
    template: 'https://www.flyscoot.com/en/book-a-trip/select-flight?origin={origin}&destination={destination}&departure={date}&adults={adults}&utm_source=wingfinder&utm_medium=affiliate',
    supports_roundtrip: true
  },
  'Turkish Airlines': {
    template: 'https://www.turkishairlines.com/en-int/flights/booking?origin={origin}&destination={destination}&departureDate={date}&passengerCount={adults}&utm_source=wingfinder&utm_medium=affiliate',
    supports_roundtrip: true
  },
  'Qatar Airways': {
    template: 'https://qatarairways.com/booking?origin={origin}&destination={destination}&departureDate={date}&adults={adults}&utm_source=wingfinder&utm_medium=affiliate',
    supports_roundtrip: true
  }
};

interface TOffer {
  id: string;
  from: string;
  to: string;
  price: number;
  currency: string;
  departure_time: string;
  arrival_time: string;
  duration_minutes: number;
  airline: string;
  flight_number: string;
  aircraft: string;
  cabin_class: 'economy' | 'premium_economy' | 'business' | 'first';
  stops: number;
  route: string[];
  deeplink_url?: string;
  provider: 'tequila' | 'travelpayouts' | 'duffel' | 'amadeus';
  valid_until: string;
}

// Helper function to generate booking URL
function generateBookingUrl(offer: TOffer, adults: number = 1): string {
  const carrier = CARRIER_DEEPLINKS[offer.airline];
  if (!carrier) {
    // Fallback to generic booking URL
    return `https://www.expedia.com/Flights-Search?trip=oneway&leg1=from:${offer.from},to:${offer.to},departure:${offer.departure_time.split('T')[0]}TANYT&passengers=adults:${adults}&options=cabinclass:${offer.cabin_class}&affcid=AjmUZGx`;
  }

  const departureDate = offer.departure_time.split('T')[0];
  return carrier.template
    .replace('{origin}', offer.from)
    .replace('{destination}', offer.to)
    .replace('{date}', departureDate)
    .replace('{adults}', adults.toString());
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, User-Agent');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { id } = req.query;
    console.log(`Repricing offer: ${id}`);

    // TODO: Implement real repricing logic with API providers
    // For now, return demo data
    
    const demoOffer: TOffer = {
      id: id as string,
      from: 'NRT',
      to: 'PRG', 
      price: 312,
      currency: 'USD',
      departure_time: '2025-08-26T14:30:00Z',
      arrival_time: '2025-08-27T08:15:00Z',
      duration_minutes: 1065,
      airline: 'Turkish Airlines',
      flight_number: 'TK 198',
      aircraft: 'Boeing 787-9',
      cabin_class: 'economy',
      stops: 1,
      route: ['NRT', 'IST', 'PRG'],
      provider: 'tequila',
      valid_until: '2025-08-26T12:00:00Z'
    };

    res.status(200).json({
      id: id,
      status: 'available',
      current_price: 312,
      currency: 'USD',
      valid_until: '2025-08-26T15:00:00Z',
      deeplink_url: generateBookingUrl(demoOffer)
    });
  } catch (error) {
    console.error('Reprice error:', error);
    res.status(500).json({ error: 'Repricing failed' });
  }
}