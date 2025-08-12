import 'package:mywingsfinder/models/flight.dart';

class Airports {
  static const List<Airport> japaneseAirports = [
    Airport(code: 'NRT', name: 'Narita International', city: 'Tokyo', country: 'Japan'),
    Airport(code: 'HND', name: 'Haneda Airport', city: 'Tokyo', country: 'Japan'),
    Airport(code: 'NGO', name: 'Chubu Centrair', city: 'Nagoya', country: 'Japan'),
    Airport(code: 'KIX', name: 'Kansai International', city: 'Osaka', country: 'Japan'),
    Airport(code: 'ITM', name: 'Osaka International', city: 'Osaka', country: 'Japan'),
    Airport(code: 'FUK', name: 'Fukuoka Airport', city: 'Fukuoka', country: 'Japan'),
    Airport(code: 'MMJ', name: 'Matsumoto Airport', city: 'Matsumoto', country: 'Japan'),
  ];

  static const List<Airport> europeanAirports = [
    Airport(code: 'WAW', name: 'Warsaw Chopin', city: 'Warsaw', country: 'Poland', isVisaFree: true),
    Airport(code: 'WRO', name: 'Wrocław Airport', city: 'Wrocław', country: 'Poland', isVisaFree: true),
    Airport(code: 'GDN', name: 'Gdańsk Lech Wałęsa', city: 'Gdańsk', country: 'Poland', isVisaFree: true),
    Airport(code: 'OTP', name: 'Henri Coandă', city: 'Bucharest', country: 'Romania', isVisaFree: true),
    Airport(code: 'BUD', name: 'Budapest Ferenc Liszt', city: 'Budapest', country: 'Hungary', isVisaFree: true),
    Airport(code: 'VIE', name: 'Vienna International', city: 'Vienna', country: 'Austria', isVisaFree: true),
    Airport(code: 'MXP', name: 'Milano Malpensa', city: 'Milan', country: 'Italy', isVisaFree: true),
    Airport(code: 'BRU', name: 'Brussels Airport', city: 'Brussels', country: 'Belgium', isVisaFree: true),
    Airport(code: 'FRA', name: 'Frankfurt am Main', city: 'Frankfurt', country: 'Germany', isVisaFree: true),
    Airport(code: 'BER', name: 'Berlin Brandenburg', city: 'Berlin', country: 'Germany', isVisaFree: true),
    Airport(code: 'LIS', name: 'Lisbon Airport', city: 'Lisbon', country: 'Portugal', isVisaFree: true),
    Airport(code: 'MAD', name: 'Madrid-Barajas', city: 'Madrid', country: 'Spain', isVisaFree: true),
    Airport(code: 'SOF', name: 'Sofia Airport', city: 'Sofia', country: 'Bulgaria', isVisaFree: true),
    Airport(code: 'PRG', name: 'Václav Havel Prague', city: 'Prague', country: 'Czech Republic', isVisaFree: true),
    Airport(code: 'ZAG', name: 'Zagreb Airport', city: 'Zagreb', country: 'Croatia', isVisaFree: true),
    Airport(code: 'TLL', name: 'Tallinn Airport', city: 'Tallinn', country: 'Estonia', isVisaFree: true),
    Airport(code: 'HEL', name: 'Helsinki-Vantaa', city: 'Helsinki', country: 'Finland', isVisaFree: true),
    Airport(code: 'ATH', name: 'Athens International', city: 'Athens', country: 'Greece', isVisaFree: true),
    Airport(code: 'IST', name: 'Istanbul Airport', city: 'Istanbul', country: 'Turkey'),
    Airport(code: 'DOH', name: 'Hamad International', city: 'Doha', country: 'Qatar'),
  ];

  static const List<String> budgetAirlines = [
    'Scoot', 'AirAsia X', 'VietJet Air', 'Ryanair', 'Wizz Air', 'Play',
    'easyJet', 'Vueling', 'Eurowings', 'Norwegian', 'Flydubai'
  ];

  static const List<String> premiumAirlines = [
    'LOT Polish Airlines', 'Turkish Airlines', 'Qatar Airways', 'Lufthansa',
    'Air China', 'ANA', 'Japan Airlines', 'EVA Air', 'Emirates', 'Singapore Airlines'
  ];

  static Airport? findAirportByCode(String code) {
    final allAirports = [...japaneseAirports, ...europeanAirports];
    try {
      return allAirports.firstWhere((airport) => airport.code == code);
    } catch (e) {
      return null;
    }
  }
}
