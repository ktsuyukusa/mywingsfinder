/**
 * GET /api/flights/search - Search flights across multiple providers
 */

import { VercelRequest, VercelResponse } from '@vercel/node';
import axios from 'axios';

// API Configuration - Set these in Vercel environment variables
const API_CONFIG = {
  tequila: {
    apiKey: process.env.TEQUILA_API_KEY || '',
    baseUrl: 'https://api.tequila.kiwi.com'
  },
  travelpayouts: {
    apiKey: process.env.TRAVELPAYOUTS_API_KEY || '',
    marker: process.env.TRAVELPAYOUTS_MARKER || '',
    baseUrl: 'https://api.travelpayouts.com'
  },
  duffel: {
    apiKey: process.env.DUFFEL_API_KEY || '',
    baseUrl: 'https://api.duffel.com'
  },
  amadeus: {
    apiKey: process.env.AMADEUS_API_KEY || '',
    apiSecret: process.env.AMADEUS_API_SECRET || '',
    baseUrl: 'https://api.amadeus.com'
  }
};

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

// Additional booking providers
const BOOKING_PROVIDERS = {
  expedia: {
    template: 'https://www.expedia.com/Flights-Search?trip=oneway&leg1=from:{origin},to:{destination},departure:{date}TANYT&passengers=adults:{adults}&options=cabinclass:{cabin_class}&affcid=AjmUZGx',
    name: 'Expedia'
  },
  tripcom: {
    template: 'https://www.trip.com/flights/{origin}-{destination}-tickets/?departure={date}&adult={adults}&cabin={cabin_class}&utm_source=wingfinder&utm_medium=affiliate',
    name: 'Trip.com'
  },
  ektainsurance: {
    template: 'https://ektatraveling.tpk.lv/2OPRDOIC?utm_source=wingfinder&utm_medium=affiliate',
    name: 'EKTA Travel Insurance'
  },
  gettransfer: {
    template: 'https://gettransfer.tpk.lv/oBw5OAO2?utm_source=wingfinder&utm_medium=affiliate',
    name: 'GetTransfer - Airport Transfers'
  },
  compensair: {
    template: 'https://compensair.tpk.lv/uR0TXuzc?utm_source=wingfinder&utm_medium=affiliate',
    name: 'Compensair - Flight Compensation'
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
  booking_urls: {
    direct?: string;
    expedia: string;
    tripcom: string;
    insurance: string;
    transfer: string;
    compensation: string;
  };
  provider: 'tequila' | 'travelpayouts' | 'duffel' | 'amadeus';
  valid_until: string;
}

// Helper function to generate booking URLs for multiple providers
function generateBookingUrls(offer: TOffer, adults: number = 1): { [key: string]: string } {
  const departureDate = offer.departure_time.split('T')[0];
  const cabinClass = offer.cabin_class === 'economy' ? 'economy' : 'business';
  
  const urls: { [key: string]: string } = {};
  
  // Check if airline has direct deeplink
  const carrier = CARRIER_DEEPLINKS[offer.airline];
  if (carrier) {
    urls.direct = carrier.template
      .replace('{origin}', offer.from)
      .replace('{destination}', offer.to)
      .replace('{date}', departureDate)
      .replace('{adults}', adults.toString());
  }
  
  // Generate URLs for all booking providers
  urls.expedia = BOOKING_PROVIDERS.expedia.template
    .replace('{origin}', offer.from)
    .replace('{destination}', offer.to)
    .replace('{date}', departureDate)
    .replace('{adults}', adults.toString())
    .replace('{cabin_class}', cabinClass);
    
  urls.tripcom = BOOKING_PROVIDERS.tripcom.template
    .replace('{origin}', offer.from)
    .replace('{destination}', offer.to)
    .replace('{date}', departureDate)
    .replace('{adults}', adults.toString())
    .replace('{cabin_class}', cabinClass);
    
  urls.insurance = BOOKING_PROVIDERS.ektainsurance.template;
  urls.transfer = BOOKING_PROVIDERS.gettransfer.template;
  urls.compensation = BOOKING_PROVIDERS.compensair.template;
  
  return urls;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type', Authorization, User-Agent');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { from, to, date, class: cabinClass } = req.query;
    
    console.log(`Flight search: ${from} → ${to} on ${date} (${cabinClass})`);

    // Check if we have Travelpayouts API key
    if (!API_CONFIG.travelpayouts.apiKey) {
      return res.status(500).json({ 
        error: 'Travelpayouts API key not configured',
        message: 'Please set TRAVELPAYOUTS_API_KEY in environment variables'
      });
    }

    // Real API call to Travelpayouts
    const searchParams = new URLSearchParams({
      origin: from as string,
      destination: to as string,
      depart_date: date as string,
      return_date: '', // One-way for now
      adults: '1',
      children: '0',
      infants: '0',
      currency: 'USD',
      locale: 'en',
      token: API_CONFIG.travelpayouts.apiKey
    });

    const travelpayoutsUrl = `${API_CONFIG.travelpayouts.baseUrl}/v1/prices/cheap?${searchParams}`;
    
    console.log('Calling Travelpayouts API:', travelpayoutsUrl);
    
    const response = await axios.get(travelpayoutsUrl, {
      timeout: 30000,
      headers: {
        'User-Agent': 'MyWingsFinder/1.0'
      }
    });

    if (!response.data || !response.data.data) {
      throw new Error('Invalid response from Travelpayouts API');
    }

    const flightData = response.data.data;
    const offers: TOffer[] = [];

    // Process real flight data from Travelpayouts
    for (const [route, routeData] of Object.entries(flightData)) {
      if (routeData && typeof routeData === 'object' && '0' in routeData) {
        const flight = routeData['0'];
        
        if (flight && flight.price) {
          const [origin, destination] = route.split('-');
          
          offers.push({
            id: `tp_${origin}_${destination}_${flight.airline}_${flight.flight_number}`,
            from: origin,
            to: destination,
            price: flight.price,
            currency: 'USD',
            departure_time: `${date}T${flight.departure_time}:00Z`,
            arrival_time: `${date}T${flight.arrival_time}:00Z`,
            duration_minutes: flight.duration || 0,
            airline: flight.airline || 'Unknown',
            flight_number: flight.flight_number || 'Unknown',
            aircraft: 'Unknown',
            cabin_class: 'economy',
            stops: flight.transfers || 0,
            route: [origin, destination],
            booking_urls: generateBookingUrls({
              id: '',
              from: origin,
              to: destination,
              price: flight.price,
              currency: 'USD',
              departure_time: `${date}T${flight.departure_time}:00Z`,
              arrival_time: `${date}T${flight.arrival_time}:00Z`,
              duration_minutes: flight.duration || 0,
              airline: flight.airline || 'Unknown',
              flight_number: flight.flight_number || 'Unknown',
              aircraft: 'Unknown',
              cabin_class: 'economy',
              stops: flight.transfers || 0,
              route: [origin, destination],
              booking_urls: {} as any,
              provider: 'travelpayouts',
              valid_until: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
            }, 1),
            provider: 'travelpayouts',
            valid_until: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
          });
        }
      }
    }

    if (offers.length === 0) {
      return res.status(200).json({
        message: 'No flights found for the specified criteria',
        offers: [],
        search_params: { from, to, date, cabinClass }
      });
    }

    console.log(`Found ${offers.length} real flights from Travelpayouts API`);
    res.status(200).json({
      offers,
      search_params: { from, to, date, cabinClass },
      total_found: offers.length,
      data_source: 'Travelpayouts API'
    });

  } catch (error) {
    console.error('Flight search error:', error);
    
    if (axios.isAxiosError(error)) {
      if (error.response?.status === 401) {
        return res.status(401).json({ 
          error: 'Invalid API key',
          message: 'Please check your Travelpayouts API key'
        });
      }
      if (error.response?.status === 429) {
        return res.status(429).json({ 
          error: 'Rate limit exceeded',
          message: 'Too many requests to Travelpayouts API'
        });
      }
    }
    
    res.status(500).json({ 
      error: 'Flight search failed',
      message: error instanceof Error ? error.message : 'Unknown error',
      timestamp: new Date().toISOString()
    });
  }
}