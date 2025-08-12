import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mywingsfinder/models/flight.dart';

/// Multi-source scraping service for MyWingsFinder
/// Handles various data sources: APIs, web scraping, RSS feeds, etc.
class ScrapingService {
  static final ScrapingService _instance = ScrapingService._internal();
  factory ScrapingService() => _instance;
  ScrapingService._internal();

  // Data sources configuration
  static const Map<String, Map<String, dynamic>> _dataSources = {
    'travelpayouts': {
      'type': 'api',
      'url': 'https://api.travelpayouts.com/v1/prices/cheap',
      'headers': {'Authorization': 'Token YOUR_TOKEN'},
      'rate_limit': 100, // requests per hour
    },
    'skyscanner_rss': {
      'type': 'rss',
      'url': 'https://www.skyscanner.com/rss/',
      'rate_limit': 50,
    },
    'google_flights': {
      'type': 'scraping',
      'url': 'https://www.google.com/travel/flights',
      'rate_limit': 20,
      'requires_proxy': true,
    },
    'airline_websites': {
      'type': 'scraping',
      'sources': [
        'https://www.lufthansa.com',
        'https://www.klm.com',
        'https://www.airfrance.com',
        'https://www.swiss.com',
      ],
      'rate_limit': 30,
    },
    'travel_deal_sites': {
      'type': 'scraping',
      'sources': [
        'https://www.secretflying.com',
        'https://www.theflightdeal.com',
        'https://www.fly4free.com',
      ],
      'rate_limit': 25,
    },
  };

  // Proxy rotation for avoiding blocks
  static const List<String> _proxies = [
    // Add your proxy list here
    // 'http://proxy1:port',
    // 'http://proxy2:port',
  ];

  /// Scrape deals from multiple sources
  Future<List<Flight>> scrapeAllSources() async {
    final allDeals = <Flight>[];
    
    for (final source in _dataSources.entries) {
      try {
        print('🔍 Scraping ${source.key}...');
        
        List<Flight> deals;
        switch (source.value['type']) {
          case 'api':
            deals = await _scrapeApi(source.key, source.value);
            break;
          case 'rss':
            deals = await _scrapeRss(source.key, source.value);
            break;
          case 'scraping':
            deals = await _scrapeWebsites(source.key, source.value);
            break;
          default:
            print('❌ Unknown source type: ${source.value['type']}');
            continue;
        }
        
        if (deals.isNotEmpty) {
          print('✅ Found ${deals.length} deals from ${source.key}');
          allDeals.addAll(deals);
        }
        
        // Respect rate limits
        await _respectRateLimit(source.value['rate_limit']);
        
      } catch (e) {
        print('❌ Error scraping ${source.key}: $e');
      }
    }
    
    return allDeals;
  }

  /// Scrape API endpoints
  Future<List<Flight>> _scrapeApi(String sourceName, Map<String, dynamic> config) async {
    try {
      final response = await http.get(
        Uri.parse(config['url']),
        headers: config['headers'] ?? {},
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseApiResponse(data, sourceName);
      }
    } catch (e) {
      print('API scraping error for $sourceName: $e');
    }
    
    return [];
  }

  /// Scrape RSS feeds
  Future<List<Flight>> _scrapeRss(String sourceName, Map<String, dynamic> config) async {
    try {
      final response = await http.get(
        Uri.parse(config['url']),
        headers: {'User-Agent': 'MyWingsFinder/1.0.0'},
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        return _parseRssResponse(response.body, sourceName);
      }
    } catch (e) {
      print('RSS scraping error for $sourceName: $e');
    }
    
    return [];
  }

  /// Scrape websites using various methods
  Future<List<Flight>> _scrapeWebsites(String sourceName, Map<String, dynamic> config) async {
    final allDeals = <Flight>[];
    
    if (config['sources'] != null) {
      for (final url in config['sources']) {
        try {
          final deals = await _scrapeSingleWebsite(url, sourceName);
          allDeals.addAll(deals);
          
          // Small delay between requests
          await Future.delayed(const Duration(seconds: 2));
        } catch (e) {
          print('Error scraping $url: $e');
        }
      }
    } else if (config['url'] != null) {
      final deals = await _scrapeSingleWebsite(config['url'], sourceName);
      allDeals.addAll(deals);
    }
    
    return allDeals;
  }

  /// Scrape a single website
  Future<List<Flight>> _scrapeSingleWebsite(String url, String sourceName) async {
    try {
      // Use proxy if required
      final client = config['requires_proxy'] == true 
          ? _getHttpClientWithProxy()
          : http.Client();
      
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate',
          'Connection': 'keep-alive',
        },
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        return _parseHtmlResponse(response.body, sourceName, url);
      }
    } catch (e) {
      print('Website scraping error for $url: $e');
    }
    
    return [];
  }

  /// Parse API responses
  List<Flight> _parseApiResponse(dynamic data, String source) {
    final deals = <Flight>[];
    
    try {
      switch (source) {
        case 'travelpayouts':
          deals.addAll(_parseTravelpayoutsResponse(data));
          break;
        default:
          print('No parser for API source: $source');
      }
    } catch (e) {
      print('Error parsing API response from $source: $e');
    }
    
    return deals;
  }

  /// Parse RSS responses
  List<Flight> _parseRssResponse(String xmlContent, String source) {
    final deals = <Flight>[];
    
    try {
      // Basic RSS parsing - you might want to use a proper XML parser
      if (xmlContent.contains('flight') || xmlContent.contains('deal')) {
        // Extract flight information from RSS content
        // This is a simplified parser - you'd want to implement proper XML parsing
        deals.addAll(_extractDealsFromText(xmlContent, source));
      }
    } catch (e) {
      print('Error parsing RSS response from $source: $e');
    }
    
    return deals;
  }

  /// Parse HTML responses
  List<Flight> _parseHtmlResponse(String htmlContent, String source, String url) {
    final deals = <Flight>[];
    
    try {
      // Extract deals from HTML content
      deals.addAll(_extractDealsFromText(htmlContent, source));
    } catch (e) {
      print('Error parsing HTML response from $source: $e');
    }
    
    return deals;
  }

  /// Extract deals from text content (HTML, RSS, etc.)
  List<Flight> _extractDealsFromText(String content, String source) {
    final deals = <Flight>[];
    
    try {
      // Look for price patterns
      final pricePattern = RegExp(r'\$(\d{1,3}(?:,\d{3})*)', caseSensitive: false);
      final priceMatches = pricePattern.allMatches(content);
      
      // Look for airport codes
      final airportPattern = RegExp(r'\b([A-Z]{3})\s*[-→]\s*([A-Z]{3})\b');
      final airportMatches = airportPattern.allMatches(content);
      
      // Look for airline names
      final airlinePattern = RegExp(r'\b(Lufthansa|KLM|Air France|Swiss|British Airways|Emirates|Qatar|Singapore Airlines)\b', caseSensitive: false);
      final airlineMatches = airlinePattern.allMatches(content);
      
      // Create flight objects from extracted data
      for (int i = 0; i < priceMatches.length && i < airportMatches.length; i++) {
        final price = int.tryParse(priceMatches.elementAt(i).group(1)?.replaceAll(',', '') ?? '0') ?? 0;
        final from = airportMatches.elementAt(i).group(1) ?? '';
        final to = airportMatches.elementAt(i).group(2) ?? '';
        
        if (price > 0 && from.isNotEmpty && to.isNotEmpty) {
          final airline = airlineMatches.isNotEmpty && i < airlineMatches.length 
              ? airlineMatches.elementAt(i).group(1) ?? 'Unknown'
              : 'Unknown';
          
          deals.add(Flight(
            id: 'scraped_${source}_${i}_${DateTime.now().millisecondsSinceEpoch}',
            from: from,
            to: to,
            departureTime: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
            arrivalTime: DateTime.now().add(const Duration(days: 30, hours: 12)).toIso8601String(),
            price: price.toDouble(),
            airline: airline,
            flightClass: 'Economy',
            isDirect: true,
            isMistakeFare: price < 400,
            asOf: DateTime.now(),
            bookingUrls: {
              'direct': 'https://www.google.com/travel/flights?q=$from-$to',
              'expedia': 'https://www.expedia.com/Flights-Search?trip=oneway&leg1=from:$from,to:$to',
              'tripcom': 'https://www.trip.com/flights/$from-$to-tickets/',
              'insurance': 'https://ektatraveling.tpk.lv/2OPRDOIC?utm_source=wingfinder&utm_medium=affiliate',
              'transfer': 'https://gettransfer.tpk.lv/oBw5OAO2?utm_source=wingfinder&utm_medium=affiliate',
              'compensation': 'https://compensair.tpk.lv/uR0TXuzc?utm_source=wingfinder&utm_medium=affiliate',
              'esim': 'https://airalo.tpk.lv/OEGVySUX?utm_source=wingfinder&utm_medium=affiliate',
            },
          ));
        }
      }
    } catch (e) {
      print('Error extracting deals from text: $e');
    }
    
    return deals;
  }

  /// Parse Travelpayouts specific response
  List<Flight> _parseTravelpayoutsResponse(dynamic data) {
    final deals = <Flight>[];
    
    try {
      if (data is Map<String, dynamic> && data.containsKey('offers')) {
        final offers = data['offers'] as List;
        for (final offer in offers) {
          if (offer is Map<String, dynamic>) {
            // Parse according to your existing Flight.fromApiOffer method
            // This would need to be implemented based on your Flight model
          }
        }
      }
    } catch (e) {
      print('Error parsing Travelpayouts response: $e');
    }
    
    return deals;
  }

  /// Get HTTP client with proxy
  http.Client _getHttpClientWithProxy() {
    if (_proxies.isNotEmpty) {
      final randomProxy = _proxies[DateTime.now().millisecond % _proxies.length];
      // Configure proxy - this is a simplified version
      // You'd want to implement proper proxy configuration
    }
    return http.Client();
  }

  /// Respect rate limits
  Future<void> _respectRateLimit(int requestsPerHour) async {
    final delay = (3600 / requestsPerHour).round(); // seconds between requests
    await Future.delayed(Duration(seconds: delay));
  }

  /// Get scraping statistics
  Map<String, dynamic> getScrapingStats() {
    return {
      'total_sources': _dataSources.length,
      'api_sources': _dataSources.values.where((s) => s['type'] == 'api').length,
      'rss_sources': _dataSources.values.where((s) => s['type'] == 'rss').length,
      'scraping_sources': _dataSources.values.where((s) => s['type'] == 'scraping').length,
      'proxies_available': _proxies.length,
    };
  }
}
