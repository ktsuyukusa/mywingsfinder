// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WingFinder - Japan to Europe Flights';

  @override
  String get budgetFlights => '💸 Budget Flights';

  @override
  String get premiumFlights => '🛫 Premium/VIP';

  @override
  String get departing => 'Departing';

  @override
  String get arriving => 'Arriving';

  @override
  String get selectDeparture => 'Select departure';

  @override
  String get selectArrival => 'Select arrival';

  @override
  String get selectDate => 'Select date';

  @override
  String get searchFlights => 'Search Flights';

  @override
  String get oneWay => 'One-way';

  @override
  String get roundTrip => 'Round-trip';

  @override
  String get budgetTabDescription =>
      'Budget flights under \$399 one-way / \$650 round-trip';

  @override
  String get premiumTabDescription =>
      'Premium flights, business class, and VIP options';

  @override
  String get airline => 'Airline';

  @override
  String get price => 'Price';

  @override
  String get duration => 'Duration';

  @override
  String get stops => 'Stops';

  @override
  String get departure => 'Departure';

  @override
  String get arrival => 'Arrival';

  @override
  String get nonstop => 'Nonstop';

  @override
  String get stop => 'stop';

  @override
  String get stops_plural => 'stops';

  @override
  String get directFlight => 'Direct flight';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get flightClass => 'Class';

  @override
  String get economyClass => 'Economy';

  @override
  String get premiumEconomyClass => 'Premium Economy';

  @override
  String get businessClass => 'Business';

  @override
  String get firstClass => 'First';

  @override
  String get privateJet => 'Private Jet';

  @override
  String get aircraft => 'Aircraft';

  @override
  String get availableSeats => 'Available Seats';

  @override
  String get baggageIncluded => 'Baggage Included';

  @override
  String get mealService => 'Meal Service';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get wifi => 'WiFi';

  @override
  String get loungeAccess => 'Lounge Access';

  @override
  String get priorityBoarding => 'Priority Boarding';

  @override
  String get refundable => 'Refundable';

  @override
  String get changeable => 'Changeable';

  @override
  String get included => 'Included';

  @override
  String get available => 'Available';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String flightsFound(int count) {
    return '$count flights found';
  }

  @override
  String get updatedAgo => 'Updated 2h ago';

  @override
  String get noFlightsMatch => 'No flights match your filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get premiumPrivateFlights => 'Premium & Private Flights';

  @override
  String get businessFirstPrivateDeals =>
      'Business, First Class & Private Jet deals';

  @override
  String get fromJapan => 'From Japan';

  @override
  String get toEurope => 'To Europe';

  @override
  String get allJapaneseAirports => 'All Japanese airports';

  @override
  String get allEuropeanAirports => 'All European airports';

  @override
  String get allClasses => 'All Classes';

  @override
  String get directFlightsOnly => 'Direct flights only';

  @override
  String premiumFlightsFound(int count) {
    return '$count premium flights';
  }

  @override
  String get vipDeals => 'VIP Deals';

  @override
  String get noPremiumFlights => 'No premium flights available';

  @override
  String get directOnly => 'Direct only';

  @override
  String get visaFree => 'Visa-free';

  @override
  String get mistakeFares => '🚨 Mistake fares';

  @override
  String get clearAllFilters => 'Clear all filters';

  @override
  String get mistakeFare => 'MISTAKE FARE';

  @override
  String get hiddenCity => 'HIDDEN CITY';

  @override
  String get bookNow => 'Book Now';
}
