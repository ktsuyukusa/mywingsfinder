import 'package:mywingsfinder/models/flight.dart';

/// Sample flight data for development and fallback when API is unavailable
class MockFlights {
  static final List<Flight> _sampleBudgetFlights = [
    // Tokyo (NRT) to Europe - Budget Options
    Flight(
      id: 'sample_scoot_nrt_bud',
      departureCode: 'NRT',
      departureName: 'Tokyo Narita',
      arrivalCode: 'BUD',
      arrivalName: 'Budapest',
      airline: 'Scoot',
      departureDate: DateTime.now().add(Duration(days: 35)),
      price: 298.0,
      currency: 'USD',
      flightClass: 'Economy',
      isDirect: false,
      bookingUrl: 'https://www.flyscoot.com',
      isMistakeFare: true,
      layovers: ['SIN'],
    ),
    Flight(
      id: 'sample_air_asia_nrt_war',
      departureCode: 'NRT',
      departureName: 'Tokyo Narita',
      arrivalCode: 'WAW',
      arrivalName: 'Warsaw',
      airline: 'AirAsia X',
      departureDate: DateTime.now().add(Duration(days: 42)),
      price: 356.0,
      currency: 'USD',
      flightClass: 'Economy',
      isDirect: false,
      bookingUrl: 'https://www.airasia.com',
      layovers: ['KUL'],
    ),
    // Osaka (KIX) to Europe
    Flight(
      id: 'sample_jetstar_kix_bru',
      departureCode: 'KIX',
      departureName: 'Osaka Kansai',
      arrivalCode: 'BRU',
      arrivalName: 'Brussels',
      airline: 'Jetstar',
      departureDate: DateTime.now().add(Duration(days: 28)),
      price: 387.0,
      currency: 'USD',
      flightClass: 'Economy',
      isDirect: false,
      bookingUrl: 'https://www.jetstar.com',
      layovers: ['SIN'],
    ),
    // Nagoya (NGO) to Europe
    Flight(
      id: 'sample_cebu_ngo_fra',
      departureCode: 'NGO',
      departureName: 'Nagoya Chubu',
      arrivalCode: 'FRA',
      arrivalName: 'Frankfurt',
      airline: 'Cebu Pacific',
      departureDate: DateTime.now().add(Duration(days: 39)),
      price: 342.0,
      currency: 'USD',
      flightClass: 'Economy',
      isDirect: false,
      bookingUrl: 'https://www.cebupacificair.com',
      layovers: ['MNL', 'DXB'],
    ),
    // More budget flights from various Japanese cities
    Flight(
      id: 'sample_peach_fuk_vie',
      departureCode: 'FUK',
      departureName: 'Fukuoka',
      arrivalCode: 'VIE',
      arrivalName: 'Vienna',
      airline: 'Peach Aviation',
      departureDate: DateTime.now().add(Duration(days: 33)),
      price: 389.0,
      currency: 'USD',
      flightClass: 'Economy',
      isDirect: false,
      bookingUrl: 'https://www.flypeach.com',
      layovers: ['ICN', 'FRA'],
    ),
  ];

  static final List<Flight> _samplePremiumFlights = [
    // Business Class Options
    Flight(
      id: 'sample_qatar_nrt_doh_vie',
      departureCode: 'NRT',
      departureName: 'Tokyo Narita',
      arrivalCode: 'VIE',
      arrivalName: 'Vienna',
      airline: 'Qatar Airways',
      departureDate: DateTime.now().add(Duration(days: 31)),
      price: 2850.0,
      currency: 'USD',
      flightClass: 'Business',
      isDirect: false,
      bookingUrl: 'https://www.qatarairways.com',
      layovers: ['DOH'],
    ),
    Flight(
      id: 'sample_emirates_nrt_dxb_fra',
      departureCode: 'NRT',
      departureName: 'Tokyo Narita',
      arrivalCode: 'FRA',
      arrivalName: 'Frankfurt',
      airline: 'Emirates',
      departureDate: DateTime.now().add(Duration(days: 45)),
      price: 3200.0,
      currency: 'USD',
      flightClass: 'Business',
      isDirect: false,
      bookingUrl: 'https://www.emirates.com',
      layovers: ['DXB'],
    ),
    // First Class Options
    Flight(
      id: 'sample_lufthansa_nrt_muc_bud',
      departureCode: 'NRT',
      departureName: 'Tokyo Narita',
      arrivalCode: 'BUD',
      arrivalName: 'Budapest',
      airline: 'Lufthansa',
      departureDate: DateTime.now().add(Duration(days: 37)),
      price: 5800.0,
      currency: 'USD',
      flightClass: 'First',
      isDirect: false,
      bookingUrl: 'https://www.lufthansa.com',
      layovers: ['MUC'],
    ),
    // Private Jet Options
    Flight(
      id: 'sample_netjets_nrt_vie',
      departureCode: 'NRT',
      departureName: 'Tokyo Narita',
      arrivalCode: 'VIE',
      arrivalName: 'Vienna',
      airline: 'NetJets',
      departureDate: DateTime.now().add(Duration(days: 25)),
      price: 45000.0,
      currency: 'USD',
      flightClass: 'Private Jet',
      isDirect: true,
      bookingUrl: 'https://www.netjets.com',
      layovers: [],
    ),
  ];

  /// Get sample budget flights (under \$400 one-way)
  static List<Flight> getBudgetFlights() {
    return List.from(_sampleBudgetFlights);
  }

  /// Get sample premium flights (Business/First/Private)
  static List<Flight> getPremiumFlights() {
    return List.from(_samplePremiumFlights);
  }

  /// Get all sample flights
  static List<Flight> getAllFlights() {
    return [..._sampleBudgetFlights, ..._samplePremiumFlights];
  }
}