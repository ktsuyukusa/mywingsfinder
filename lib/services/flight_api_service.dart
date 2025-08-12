import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mywingsfinder/models/flight.dart';

/// Real API service for MyWingsFinder - connects to your backend
class FlightApiService {
  static final FlightApiService _instance = FlightApiService._internal();
  factory FlightApiService() => _instance;
  FlightApiService._internal();

  // TODO: Replace with your actual Cloud Function URL
  static const String baseUrl = 'https://your-cloud-function-url.cloudfunctions.net/api';
  
  /// Search flights using your backend API aggregation
  /// GET /flights/search?from=NRT&to=EU&date=2025-08-26&class=economy
  static Future<List<Flight>> searchFlights({
    required String from,
    String? to,
    DateTime? departureDate,
    String? cabinClass,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/flights/search').replace(queryParameters: {
        'from': from,
        'to': to ?? 'any',
        'date': departureDate?.toIso8601String().split('T')[0] ?? '',
        'class': cabinClass?.toLowerCase() ?? 'economy',
      });
      
      print('Searching flights: $uri');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'MyWingsFinder/1.0.0',
        },
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Found ${data.length} flight offers');
        return data.map((offer) => Flight.fromApiOffer(offer)).toList();
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error searching flights: $e');
      // Return empty list - no more mock data
      return [];
    }
  }

  /// Reprice a specific flight offer before booking
  /// GET /flights/reprice?id=teq_abc123
  static Future<Map<String, dynamic>?> repriceOffer(String offerId) async {
    try {
      final uri = Uri.parse('$baseUrl/flights/reprice').replace(queryParameters: {
        'id': offerId,
      });
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'MyWingsFinder/1.0.0',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Reprice failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error repricing offer: $e');
      return null;
    }
  }

  /// Submit private jet lead to brokers
  /// POST /leads/private-jet
  static Future<bool> submitPrivateJetLead(Map<String, dynamic> leadData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/leads/private-jet'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'MyWingsFinder/1.0.0',
        },
        body: json.encode(leadData),
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['ok'] == true;
      } else {
        throw Exception('Lead submission failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting private jet lead: $e');
      return false;
    }
  }

  /// Health check for the backend API
  static Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'User-Agent': 'MyWingsFinder/1.0.0'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('API health check failed: $e');
      return false;
    }
  }
}
