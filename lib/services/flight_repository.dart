import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/services/flight_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Repository for managing real flight data from API aggregation backend
class FlightRepository {
  static final FlightRepository _instance = FlightRepository._internal();
  factory FlightRepository() => _instance;
  FlightRepository._internal();

  final Map<String, List<Flight>> _cache = {};
  final Duration _cacheExpiry = const Duration(minutes: 15);

  /// Search for flights via API aggregation backend
  Future<List<Flight>> searchFlights({
    required String from,
    required String to,
    required DateTime departureDate,
    DateTime? returnDate,
    String flightClass = 'Economy',
    bool forceLiveData = false,
  }) async {
    final cacheKey = _generateCacheKey(from, to, departureDate, returnDate, flightClass);
    
    // Return cached data if available and not expired (unless forcing live data)
    if (!forceLiveData && _cache.containsKey(cacheKey)) {
      final cachedFlights = _cache[cacheKey]!;
      if (cachedFlights.isNotEmpty && !cachedFlights.first.isStale) {
        print('FlightRepository: Returning cached results for $cacheKey');
        return cachedFlights;
      }
    }

    try {
      // Get live data from your backend API aggregation
      print('FlightRepository: Fetching live flight data from API backend');
      final liveFlights = await FlightApiService.searchFlights(
        from: from,
        to: to == 'any' ? null : to,
        departureDate: departureDate,
        cabinClass: flightClass.toLowerCase(),
      );

      if (liveFlights.isNotEmpty) {
        // Cache the results
        _cache[cacheKey] = liveFlights;
        await _persistCache();
        print('FlightRepository: Cached ${liveFlights.length} real flights from API');
        return liveFlights;
      } else {
        print('FlightRepository: API returned empty results - no flights found');
        return [];
      }
    } catch (e) {
      print('FlightRepository: API fetch failed: $e');
      return [];
    }
  }

  /// Get budget flights (Economy class under $400 one-way, $650 round-trip)
  Future<List<Flight>> getBudgetFlights({
    String? departureCode,
    String? arrivalCode,
    DateTime? departureDate,
    bool? directOnly,
    bool? visaFreeOnly,
    bool? mistakeFareOnly,
  }) async {
    final results = await searchFlights(
      from: departureCode ?? 'NRT',
      to: arrivalCode ?? 'any',
      departureDate: departureDate ?? DateTime.now().add(const Duration(days: 30)),
      flightClass: 'economy',
    );
    
    return _filterFlights(results, directOnly, visaFreeOnly, mistakeFareOnly)
        .where((f) => f.flightClass == 'Economy' && f.price < 400)
        .toList();
  }

  /// Get premium flights (Business, First, Private Jet)
  Future<List<Flight>> getPremiumFlights({
    String? departureCode,
    String? arrivalCode,
    DateTime? departureDate,
    bool? directOnly,
    bool? visaFreeOnly,
    String? flightClass,
  }) async {
    final searchClass = flightClass?.toLowerCase() ?? 'business';
    
    final results = await searchFlights(
      from: departureCode ?? 'NRT',
      to: arrivalCode ?? 'any',
      departureDate: departureDate ?? DateTime.now().add(const Duration(days: 30)),
      flightClass: searchClass,
    );
    
    return _filterFlights(results, directOnly, visaFreeOnly, null)
        .where((f) => f.isPremium)
        .toList();
  }

  /// Reprice a specific flight offer via backend
  Future<Flight?> repriceFlightOffer(Flight flight) async {
    try {
      final repriceResult = await FlightApiService.repriceOffer(flight.id);
      
      if (repriceResult != null && repriceResult['priceChanged'] == false) {
        // Price unchanged, return original flight
        return flight;
      } else if (repriceResult != null) {
        // TODO: Handle price changes - might need updated offer data
        print('Price changed for ${flight.id}: $repriceResult');
        return flight; // For now, return original
      }
    } catch (e) {
      print('FlightRepository: Reprice failed for ${flight.id}: $e');
    }

    return flight; // Return original if repricing fails
  }

  /// Submit private jet lead to brokers
  Future<bool> submitPrivateJetLead(Map<String, dynamic> leadData) async {
    try {
      return await FlightApiService.submitPrivateJetLead(leadData);
    } catch (e) {
      print('FlightRepository: Private jet lead submission failed: $e');
      return false;
    }
  }

  /// Check backend API health
  Future<bool> checkApiHealth() async {
    return await FlightApiService.checkApiHealth();
  }

  /// Filter flights based on criteria
  List<Flight> _filterFlights(List<Flight> flights, bool? directOnly, 
      bool? visaFreeOnly, bool? mistakeFareOnly) {
    var filtered = flights;

    if (directOnly == true) {
      filtered = filtered.where((f) => f.isDirect).toList();
    }

    if (mistakeFareOnly == true) {
      filtered = filtered.where((f) => f.isMistakeFare).toList();
    }

    // TODO: Implement visa-free filtering with airport data
    if (visaFreeOnly == true) {
      // This would require integration with airport/visa data
    }

    return filtered;
  }

  /// Generate cache key for flight search
  String _generateCacheKey(String from, String to, DateTime departureDate, 
      DateTime? returnDate, String flightClass) {
    final returnStr = returnDate?.toIso8601String() ?? 'oneway';
    return '${from}_${to}_${departureDate.toIso8601String().split('T')[0]}_${returnStr}_$flightClass';
  }

  /// Update a specific flight in cache
  void _updateFlightInCache(Flight updatedFlight) {
    for (final cacheEntry in _cache.entries) {
      final flights = cacheEntry.value;
      for (int i = 0; i < flights.length; i++) {
        if (flights[i].id == updatedFlight.id) {
          flights[i] = updatedFlight;
          break;
        }
      }
    }
  }

  /// Persist cache to local storage
  Future<void> _persistCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = <String, dynamic>{};
      
      for (final entry in _cache.entries) {
        cacheJson[entry.key] = entry.value.map((f) => f.toJson()).toList();
      }
      
      await prefs.setString('flight_cache', json.encode(cacheJson));
    } catch (e) {
      print('FlightRepository: Cache persistence failed: $e');
    }
  }

  /// Load cache from local storage
  Future<void> loadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheString = prefs.getString('flight_cache');
      
      if (cacheString != null) {
        final cacheJson = json.decode(cacheString) as Map<String, dynamic>;
        
        for (final entry in cacheJson.entries) {
          final flightsList = (entry.value as List)
              .map((json) => Flight.fromJson(json as Map<String, dynamic>))
              .toList();
          _cache[entry.key] = flightsList;
        }
        
        print('FlightRepository: Loaded ${_cache.length} cached searches');
      }
    } catch (e) {
      print('FlightRepository: Cache loading failed: $e');
    }
  }

  /// Clear expired cache entries
  void clearExpiredCache() {
    final now = DateTime.now();
    _cache.removeWhere((key, flights) {
      if (flights.isEmpty) return true;
      
      final cacheAge = now.difference(flights.first.asOf);
      return cacheAge > _cacheExpiry;
    });
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getCacheStats() {
    int totalFlights = 0;
    int expiredFlights = 0;
    final now = DateTime.now();

    for (final flights in _cache.values) {
      totalFlights += flights.length;
      for (final flight in flights) {
        if (now.difference(flight.asOf) > _cacheExpiry) {
          expiredFlights++;
        }
      }
    }

    return {
      'cached_searches': _cache.length,
      'total_flights': totalFlights,
      'expired_flights': expiredFlights,
      'cache_hit_rate': _cache.length > 0 ? '${((_cache.length - expiredFlights) / _cache.length * 100).toStringAsFixed(1)}%' : '0%',
    };
  }
}
