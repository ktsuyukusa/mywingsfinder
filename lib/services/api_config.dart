/// API configuration for flight search providers
class ApiConfig {
  static const String _tequilaApiKey = 'YOUR_TEQUILA_API_KEY';
  static const String _duffelApiKey = 'YOUR_DUFFEL_API_KEY';
  static const String _amadeusApiKey = 'YOUR_AMADEUS_API_KEY';
  static const String _amadeusApiSecret = 'YOUR_AMADEUS_API_SECRET';
  static const String _travelpayoutsApiKey = 'c8c4f4e274494e419c77414827284ae9';
  static const String _travelpayoutsMarker = '664457';
  static const String _kiwiAffiliateLink = 'https://kiwi.tpk.lv/mmaLqE7K';

  // API Endpoints
  static const Map<String, String> endpoints = {
    'tequila_search': 'https://api.tequila.kiwi.com/v2/search',
    'tequila_locations': 'https://api.tequila.kiwi.com/locations/query',
    'duffel_offers': 'https://api.duffel.com/air/offer_requests',
    'duffel_search': 'https://api.duffel.com/air/offers/search',
    'amadeus_search': 'https://api.amadeus.com/v2/shopping/flight-offers',
    'amadeus_token': 'https://api.amadeus.com/v1/security/oauth2/token',
    'travelpayouts_search': 'https://api.travelpayouts.com/aviasales/v3/prices_for_dates',
    'travelpayouts_popular': 'https://api.travelpayouts.com/aviasales/v3/get_popular_routes_from_city',
  };

  // Japan origin airports (IATA codes)
  static const List<String> japanAirports = [
    'NRT', // Tokyo Narita
    'HND', // Tokyo Haneda
    'NGO', // Nagoya Chubu Centrair
    'KIX', // Osaka Kansai
    'FUK', // Fukuoka
    'MMJ', // Matsumoto
  ];

  // European destination airports (major hubs and visa-free options)
  static const List<String> europeanAirports = [
    // Major European Hubs
    'AMS', // Amsterdam
    'HEL', // Helsinki
    'PRG', // Prague
    'MUC', // Munich
    'FCO', // Rome Fiumicino
    'ZRH', // Zurich
    'VIE', // Vienna
    'WAW', // Warsaw
    'WRO', // Wrocław
    'GDN', // Gdańsk
    'KRK', // Krakow
    'BUD', // Budapest
    'BRU', // Brussels
    'FRA', // Frankfurt
    'CPH', // Copenhagen
    'ARN', // Stockholm
    'OSL', // Oslo
    'BTS', // Bratislava
    'OTP', // Bucharest
    'SOF', // Sofia
    'TLL', // Tallinn
    'ATH', // Athens
    'LIS', // Lisbon
    'MAD', // Madrid
    'ZAG', // Zagreb
  ];

  // Carrier deeplink templates for direct booking
  static const Map<String, Map<String, dynamic>> carrierConfigs = {
    'Ryanair': {
      'deeplink_template': 'https://www.ryanair.com/en/booking/home/{origin}/{destination}/{date}?adults={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {'promoCode': ''},
    },
    'Wizz Air': {
      'deeplink_template': 'https://wizzair.com/en-GB/select-flight/from/{origin}/to/{destination}/on/{date}?passengers={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
    'Scoot': {
      'deeplink_template': 'https://www.flyscoot.com/en/book-a-trip/select-flight?origin={origin}&destination={destination}&departure={date}&adults={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
    'AirAsia': {
      'deeplink_template': 'https://www.airasia.com/booking/select-flight?origin={origin}&destination={destination}&departureDate={date}&adult={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
    'Turkish Airlines': {
      'deeplink_template': 'https://www.turkishairlines.com/en-int/flights/booking?origin={origin}&destination={destination}&departureDate={date}&passengerCount={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
    'Qatar Airways': {
      'deeplink_template': 'https://qatarairways.com/booking?origin={origin}&destination={destination}&departureDate={date}&adults={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
    'Emirates': {
      'deeplink_template': 'https://www.emirates.com/flight-search?origin={origin}&destination={destination}&departureDate={date}&adultCount={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
    'Lufthansa': {
      'deeplink_template': 'https://www.lufthansa.com/flight/offer?origin={origin}&destination={destination}&outboundDate={date}&adultCount={adults}&utm_source=mywingsfinder&utm_medium=affiliate',
      'supports_roundtrip': true,
      'currency_param': 'currency',
      'extra_params': {},
    },
  };

  // API Headers for different providers
  static Map<String, String> getTequilaHeaders() => {
    'apikey': _tequilaApiKey,
    'Content-Type': 'application/json',
  };

  static Map<String, String> getDuffelHeaders() => {
    'Authorization': 'Bearer $_duffelApiKey',
    'Content-Type': 'application/json',
    'Duffel-Version': 'v1',
  };

  static Map<String, String> getAmadeusHeaders(String accessToken) => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  static Map<String, String> getTravelpayoutsHeaders() => {
    'X-Access-Token': _travelpayoutsApiKey,
    'Content-Type': 'application/json',
  };

  // Affiliate tracking parameters
  static Map<String, String> getAffiliateParams() => {
    'marker': _travelpayoutsMarker,
    'sub_id': 'mywingsfinder',
    'utm_source': 'mywingsfinder',
    'utm_medium': 'affiliate',
    'utm_campaign': 'flight_search',
  };

  // Kiwi affiliate link getter
  static String getKiwiAffiliateLink() => _kiwiAffiliateLink;

  // Rate limiting configuration
  static const Map<String, Map<String, int>> rateLimits = {
    'tequila': {'requests_per_minute': 100, 'requests_per_hour': 2000},
    'duffel': {'requests_per_minute': 300, 'requests_per_hour': 10000},
    'amadeus': {'requests_per_minute': 100, 'requests_per_hour': 2000},
    'travelpayouts': {'requests_per_minute': 100, 'requests_per_hour': 1000},
  };

  // Cache TTL settings by API
  static const Map<String, Duration> cacheTtl = {
    'tequila': Duration(minutes: 15),      // Fast changing LCC prices
    'duffel': Duration(minutes: 30),       // More stable traditional airline prices
    'amadeus': Duration(minutes: 30),      // GDS data is more stable
    'travelpayouts': Duration(minutes: 20), // Meta search results
  };

  // Timeout settings by API
  static const Map<String, Duration> timeouts = {
    'tequila': Duration(seconds: 15),
    'duffel': Duration(seconds: 20),
    'amadeus': Duration(seconds: 25),
    'travelpayouts': Duration(seconds: 10),
  };

  // Pricing thresholds for different classes
  static const Map<String, Map<String, double>> pricingThresholds = {
    'budget': {
      'economy_max': 399.0,
      'mistake_fare_max': 250.0,
      'alert_threshold': 300.0,
    },
    'premium': {
      'business_min': 800.0,
      'first_min': 2500.0,
      'private_jet_min': 5000.0,
    },
  };

  // Demo mode configuration (when APIs are unavailable)
  static const bool demoMode = false; // Set to false in production with real API keys
  
  // Visa-free destinations for Japanese passport holders (90 days or less)
  static const List<String> visaFreeAirports = [
    'HEL', 'PRG', 'MUC', 'ZRH', 'VIE', 'WAW', 'WRO', 'GDN', 'KRK', 'BUD',
    'BRU', 'FRA', 'CPH', 'ARN', 'OSL', 'BTS', 'TLL', 'ATH', 'LIS', 'MAD',
    'AMS', 'FCO', 'ZAG', // Most Schengen and EU countries
  ];

  // Private jet broker contacts (for lead generation)
  static const Map<String, Map<String, String>> privateJetBrokers = {
    'NetJets': {
      'email': 'sales@netjets.com',
      'phone': '+1-800-356-5823',
      'region': 'Global',
    },
    'Flexjet': {
      'email': 'sales@flexjet.com', 
      'phone': '+1-216-261-3200',
      'region': 'Global',
    },
    'FXAir': {
      'email': 'charter@fxair.com',
      'phone': '+44-207-100-8000',
      'region': 'Europe/Asia',
    },
    'Japan Premium Jet': {
      'email': 'info@japanpremiumjet.com',
      'phone': '+81-3-6434-7455',
      'region': 'Japan/Asia',
    },
  };

  // Validation methods
  static bool isValidApiKey(String key) => key.isNotEmpty && key != 'YOUR_API_KEY';
  
  static bool areApiKeysConfigured() {
    return isValidApiKey(_tequilaApiKey) ||
           isValidApiKey(_duffelApiKey) ||
           isValidApiKey(_amadeusApiKey) ||
           isValidApiKey(_travelpayoutsApiKey);
  }

  static List<String> getConfiguredApis() {
    final configured = <String>[];
    if (isValidApiKey(_tequilaApiKey)) configured.add('tequila');
    if (isValidApiKey(_duffelApiKey)) configured.add('duffel');
    if (isValidApiKey(_amadeusApiKey)) configured.add('amadeus');
    if (isValidApiKey(_travelpayoutsApiKey)) configured.add('travelpayouts');
    return configured;
  }
}
