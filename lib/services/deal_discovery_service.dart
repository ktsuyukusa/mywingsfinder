import 'dart:async';
import 'dart:math';
import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/services/flight_api_service.dart';
import 'package:mywingsfinder/services/scraping_service.dart';
import 'package:mywingsfinder/services/alert_service.dart';

/// Continuous deal discovery service - the core of MyWingsFinder
/// Automatically finds surprise deals and mistake fares every 30-60 minutes
class DealDiscoveryService {
  static final DealDiscoveryService _instance = DealDiscoveryService._internal();
  factory DealDiscoveryService() => _instance;
  DealDiscoveryService._internal();

  Timer? _discoveryTimer;
  final List<Flight> _discoveredDeals = [];
  final Duration _discoveryInterval = const Duration(minutes: 45); // Every 45 minutes
  
  // Popular routes for continuous monitoring
  static const List<Map<String, String>> _monitoredRoutes = [
    {'from': 'NRT', 'to': 'EU', 'name': 'Japan to Europe'},
    {'from': 'NRT', 'to': 'US', 'name': 'Japan to USA'},
    {'from': 'NRT', 'to': 'AU', 'name': 'Japan to Australia'},
    {'from': 'SIN', 'to': 'EU', 'name': 'Singapore to Europe'},
    {'from': 'BKK', 'to': 'EU', 'name': 'Bangkok to Europe'},
    {'from': 'HKG', 'to': 'EU', 'name': 'Hong Kong to Europe'},
    {'from': 'ICN', 'to': 'EU', 'name': 'Seoul to Europe'},
    {'from': 'PEK', 'to': 'EU', 'name': 'Beijing to Europe'},
  ];

  /// Start continuous deal discovery
  void startDiscovery() {
    if (_discoveryTimer != null) return;
    
    print('🚀 Starting continuous deal discovery every ${_discoveryInterval.inMinutes} minutes');
    
    // Initial discovery
    _discoverDeals();
    
    // Set up recurring discovery
    _discoveryTimer = Timer.periodic(_discoveryInterval, (_) {
      _discoverDeals();
    });
  }

  /// Stop deal discovery
  void stopDiscovery() {
    _discoveryTimer?.cancel();
    _discoveryTimer = null;
    print('⏹️ Stopped deal discovery');
  }

  /// Get all discovered deals
  List<Flight> getDiscoveredDeals() {
    return List.from(_discoveredDeals);
  }

  /// Get deals by category
  List<Flight> getDealsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'mistake_fares':
        return _discoveredDeals.where((f) => f.isMistakeFare).toList();
      case 'budget':
        return _discoveredDeals.where((f) => f.price < 400).toList();
      case 'premium':
        return _discoveredDeals.where((f) => f.isPremium).toList();
      case 'direct':
        return _discoveredDeals.where((f) => f.isDirect).toList();
      default:
        return _discoveredDeals;
    }
  }

  /// Get latest deals (last 24 hours)
  List<Flight> getLatestDeals() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return _discoveredDeals
        .where((f) => f.asOf.isAfter(cutoff))
        .toList();
  }

  /// Get deals by departure airport
  List<Flight> getDealsFromAirport(String airportCode) {
    return _discoveredDeals
        .where((f) => f.departureCode == airportCode)
        .toList();
  }

  /// Get deals by destination region
  List<Flight> getDealsToRegion(String region) {
    return _discoveredDeals
        .where((f) => f.arrivalCode.startsWith(region))
        .toList();
  }

  /// Main discovery logic - runs automatically
  Future<void> _discoverDeals() async {
    print('🔍 Starting deal discovery cycle at ${DateTime.now()}');
    
    final newDeals = <Flight>[];
    
    // 1. API-based discovery (Travelpayouts, etc.)
    print('🔍 Phase 1: API-based discovery...');
    for (final route in _monitoredRoutes) {
      try {
        print('🔍 Searching ${route['name']} (${route['from']} → ${route['to']})');
        
        final deals = await FlightApiService.searchFlights(
          from: route['from']!,
          to: route['to']!,
          departureDate: DateTime.now().add(const Duration(days: 30)),
          cabinClass: 'economy',
        );
        
        // Filter for actual deals (not just regular flights)
        final dealFlights = deals.where((f) => _isDeal(f)).toList();
        
        if (dealFlights.isNotEmpty) {
          print('💰 Found ${dealFlights.length} deals for ${route['name']}');
          newDeals.addAll(dealFlights);
        }
        
        // Also search for premium deals
        final premiumDeals = await FlightApiService.searchFlights(
          from: route['from']!,
          to: route['to']!,
          departureDate: DateTime.now().add(const Duration(days: 30)),
          cabinClass: 'business',
        );
        
        final premiumDealFlights = premiumDeals.where((f) => _isDeal(f)).toList();
        if (premiumDealFlights.isNotEmpty) {
          print('💎 Found ${premiumDealFlights.length} premium deals for ${route['name']}');
          newDeals.addAll(premiumDealFlights);
        }
        
        // Random delay to avoid API rate limits
        await Future.delayed(Duration(seconds: Random().nextInt(5) + 2));
        
      } catch (e) {
        print('❌ Error discovering deals for ${route['name']}: $e');
      }
    }
    
    // 2. Web scraping discovery (beyond APIs)
    print('🔍 Phase 2: Web scraping discovery...');
    try {
      final scrapingService = ScrapingService();
      final scrapedDeals = await scrapingService.scrapeAllSources();
      
      if (scrapedDeals.isNotEmpty) {
        print('🌐 Found ${scrapedDeals.length} deals from web scraping');
        newDeals.addAll(scrapedDeals);
      }
    } catch (e) {
      print('❌ Error during web scraping: $e');
    }
    
    // Add new deals to the collection
    if (newDeals.isNotEmpty) {
      _addNewDeals(newDeals);
      print('🎉 Discovery cycle complete: found ${newDeals.length} new deals');
      
      // Send alerts for new deals
      await _sendDealAlerts(newDeals);
    } else {
      print('😔 No new deals found in this cycle');
    }
    
    // Clean up old deals (older than 7 days)
    _cleanupOldDeals();
  }

  /// Determine if a flight is actually a deal
  bool _isDeal(Flight flight) {
    // Mistake fares are always deals
    if (flight.isMistakeFare) return true;
    
    // Economy deals: under $400 for long-haul
    if (flight.flightClass == 'Economy' && flight.price < 400) return true;
    
    // Premium deals: under $1500 for business class
    if (flight.isPremium && flight.price < 1500) return true;
    
    // Direct flight deals: significant price advantage
    if (flight.isDirect && flight.price < 600) return true;
    
    return false;
  }

  /// Add new deals to the collection
  void _addNewDeals(List<Flight> newDeals) {
    for (final deal in newDeals) {
      // Check if we already have this deal
      final existingIndex = _discoveredDeals.indexWhere((d) => d.id == deal.id);
      
      if (existingIndex >= 0) {
        // Update existing deal with latest info
        _discoveredDeals[existingIndex] = deal;
      } else {
        // Add new deal
        _discoveredDeals.add(deal);
      }
    }
    
    // Sort by price (best deals first)
    _discoveredDeals.sort((a, b) => a.price.compareTo(b.price));
  }

  /// Remove old deals
  void _cleanupOldDeals() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    _discoveredDeals.removeWhere((f) => f.asOf.isBefore(cutoff));
  }

  /// Send alerts for new deals
  Future<void> _sendDealAlerts(List<Flight> newDeals) async {
    try {
      final alertService = AlertService();
      
      // Send individual alerts for mistake fares (urgent)
      final mistakeFares = newDeals.where((f) => f.isMistakeFare).toList();
      for (final deal in mistakeFares) {
        await alertService.sendDealAlert(deal, 'mistake_fares');
      }
      
      // Send bulk alerts for other deals
      final otherDeals = newDeals.where((f) => !f.isMistakeFare).toList();
      if (otherDeals.isNotEmpty) {
        final category = otherDeals.first.isPremium ? 'premium_deals' : 'budget_deals';
        await alertService.sendBulkDealAlert(otherDeals, category);
      }
      
      print('📢 Sent alerts for ${newDeals.length} new deals');
    } catch (e) {
      print('❌ Error sending deal alerts: $e');
    }
  }

  /// Get discovery statistics
  Map<String, dynamic> getDiscoveryStats() {
    return {
      'total_deals': _discoveredDeals.length,
      'mistake_fares': _discoveredDeals.where((f) => f.isMistakeFare).length,
      'budget_deals': _discoveredDeals.where((f) => f.price < 400).length,
      'premium_deals': _discoveredDeals.where((f) => f.isPremium).length,
      'latest_update': _discoveredDeals.isNotEmpty 
          ? _discoveredDeals.first.asOf.toString()
          : 'Never',
      'discovery_interval_minutes': _discoveryInterval.inMinutes,
      'monitored_routes': _monitoredRoutes.length,
      'scraping_enabled': true,
      'alerts_enabled': true,
    };
  }
}
