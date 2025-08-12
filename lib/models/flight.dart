class FlightLeg {
  final String from;
  final String to;
  final String carrier;
  final DateTime depart;
  final DateTime arrive;
  final String? aircraft;
  final String? flightNumber;

  const FlightLeg({
    required this.from,
    required this.to,
    required this.carrier,
    required this.depart,
    required this.arrive,
    this.aircraft,
    this.flightNumber,
  });

  Map<String, dynamic> toJson() => {
    'from': from,
    'to': to,
    'carrier': carrier,
    'depart': depart.toIso8601String(),
    'arrive': arrive.toIso8601String(),
    'aircraft': aircraft,
    'flightNumber': flightNumber,
  };

  factory FlightLeg.fromJson(Map<String, dynamic> json) => FlightLeg(
    from: json['from'],
    to: json['to'],
    carrier: json['carrier'] ?? '',
    depart: json['depart'] != null ? DateTime.parse(json['depart']) : DateTime.now(),
    arrive: json['arrive'] != null ? DateTime.parse(json['arrive']) : DateTime.now(),
    aircraft: json['aircraft'],
    flightNumber: json['flightNumber'],
  );
}

class Flight {
  final String id;
  final String departureCode;
  final String departureName;
  final String arrivalCode;
  final String arrivalName;
  final String airline;
  final DateTime departureDate;
  final DateTime? returnDate;
  final double price;
  final String currency;
  final String flightClass;
  final bool isDirect;
  final String bookingUrl;
  final List<String> layovers;
  final String strategy;
  final bool isMistakeFare;
  final bool isHiddenCity;
  
  // API Integration Fields
  final String apiSource;        // 'tequila', 'duffel', 'amadeus', 'travelpayouts', 'airline_deeplink'
  final String? deepLink;        // Affiliate booking URL with tracking
  final String fareType;         // 'oneway', 'roundtrip', 'hacker', 'split'
  final String? pivotAirport;    // Hub used for connections (SIN, DXB, etc.)
  final List<FlightLeg> legs;    // Detailed flight segments
  final DateTime asOf;           // Price timestamp
  final bool priceGuarantee;     // Whether price is guaranteed
  final Map<String, dynamic>? rawData;  // Store original API response
  final String? cityTo;          // Destination city name
  final List<String> airlines;   // All carriers involved

  Flight({
    required this.id,
    required this.departureCode,
    required this.departureName,
    required this.arrivalCode,
    required this.arrivalName,
    required this.airline,
    required this.departureDate,
    this.returnDate,
    required this.price,
    required this.currency,
    required this.flightClass,
    required this.isDirect,
    required this.bookingUrl,
    this.layovers = const [],
    this.strategy = '',
    this.isMistakeFare = false,
    this.isHiddenCity = false,
    // API Integration Fields
    this.apiSource = 'mock',
    this.deepLink,
    this.fareType = 'oneway',
    this.pivotAirport,
    this.legs = const [],
    DateTime? asOf,
    this.priceGuarantee = false,
    this.rawData,
    this.cityTo,
    this.airlines = const [],
  }) : asOf = asOf ?? DateTime.now();

  bool get isOneWay => returnDate == null;
  bool get isRoundTrip => returnDate != null;
  bool get isPremium => flightClass != 'Economy';
  bool get isAlert => isMistakeFare || (flightClass == 'Economy' && price < 300) || 
                     (flightClass == 'Business' && price < 1400);
  bool get isPrivateJetLead => flightClass == 'Private Jet' && apiSource == 'lead_capture';
  bool get isStale => DateTime.now().difference(asOf).inMinutes > 30;
  bool get isSplitTicket => fareType == 'hacker' || fareType == 'split';

  Map<String, dynamic> toJson() => {
    'id': id,
    'departureCode': departureCode,
    'departureName': departureName,
    'arrivalCode': arrivalCode,
    'arrivalName': arrivalName,
    'airline': airline,
    'departureDate': departureDate.toIso8601String(),
    'returnDate': returnDate?.toIso8601String(),
    'price': price,
    'currency': currency,
    'flightClass': flightClass,
    'isDirect': isDirect,
    'bookingUrl': bookingUrl,
    'layovers': layovers,
    'strategy': strategy,
    'isMistakeFare': isMistakeFare,
    'isHiddenCity': isHiddenCity,
    // API Integration Fields
    'apiSource': apiSource,
    'deepLink': deepLink,
    'fareType': fareType,
    'pivotAirport': pivotAirport,
    'legs': legs.map((leg) => leg.toJson()).toList(),
    'asOf': asOf.toIso8601String(),
    'priceGuarantee': priceGuarantee,
    'rawData': rawData,
    'cityTo': cityTo,
    'airlines': airlines,
  };

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
    id: json['id'],
    departureCode: json['departureCode'],
    departureName: json['departureName'],
    arrivalCode: json['arrivalCode'],
    arrivalName: json['arrivalName'],
    airline: json['airline'],
    departureDate: DateTime.parse(json['departureDate']),
    returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
    price: json['price'].toDouble(),
    currency: json['currency'],
    flightClass: json['flightClass'],
    isDirect: json['isDirect'],
    bookingUrl: json['bookingUrl'],
    layovers: List<String>.from(json['layovers'] ?? []),
    strategy: json['strategy'] ?? '',
    isMistakeFare: json['isMistakeFare'] ?? false,
    isHiddenCity: json['isHiddenCity'] ?? false,
    // API Integration Fields
    apiSource: json['apiSource'] ?? 'mock',
    deepLink: json['deepLink'],
    fareType: json['fareType'] ?? 'oneway',
    pivotAirport: json['pivotAirport'],
    legs: json['legs'] != null ? 
      (json['legs'] as List).map((leg) => FlightLeg.fromJson(leg)).toList() : [],
    asOf: json['asOf'] != null ? DateTime.parse(json['asOf']) : DateTime.now(),
    priceGuarantee: json['priceGuarantee'] ?? false,
    rawData: json['rawData'],
    cityTo: json['cityTo'],
    airlines: List<String>.from(json['airlines'] ?? []),
  );

  /// Create Flight from your backend API offer schema
  /// Matches the normalized TOffer schema from your TypeScript backend
  factory Flight.fromApiOffer(Map<String, dynamic> offer) {
    final legs = (offer['legs'] as List? ?? [])
        .map((legJson) => FlightLeg.fromJson(legJson))
        .toList();
    
    final airlines = List<String>.from(offer['airlines'] ?? []);
    final mainAirline = airlines.isNotEmpty ? airlines.first : 'Unknown';
    
    // Map API class to display class
    String mapClass(String apiClass) {
      switch (apiClass.toLowerCase()) {
        case 'economy': return 'Economy';
        case 'business': return 'Business';
        case 'first': return 'First';
        case 'private': return 'Private Jet';
        default: return 'Economy';
      }
    }
    
    // Determine if flight is direct
    final isDirect = legs.length <= 1;
    final layovers = legs.length > 1 
        ? legs.sublist(0, legs.length - 1).map((leg) => leg.to).toList()
        : <String>[];

    return Flight(
      id: offer['id'] ?? '',
      departureCode: offer['origin'] ?? '',
      departureName: offer['origin'] ?? '',  // TODO: Map to airport names
      arrivalCode: offer['destination'] ?? '',
      arrivalName: offer['city_to'] ?? offer['destination'] ?? '',
      airline: mainAirline,
      departureDate: legs.isNotEmpty && legs.first.depart != null 
          ? legs.first.depart 
          : DateTime.now(),
      price: (offer['price']?['amount'] ?? 0).toDouble(),
      currency: offer['price']?['currency'] ?? 'USD',
      flightClass: mapClass(offer['class'] ?? 'economy'),
      isDirect: isDirect,
      bookingUrl: offer['deep_link'] ?? '',
      layovers: layovers,
      // API Integration Fields  
      apiSource: offer['source'] ?? 'api',
      deepLink: offer['deep_link'],
      fareType: offer['fare_type'] ?? 'oneway',
      pivotAirport: offer['pivot_airport'],
      legs: legs,
      asOf: offer['as_of'] != null ? DateTime.parse(offer['as_of']) : DateTime.now(),
      priceGuarantee: offer['price_guarantee'] ?? false,
      rawData: offer['meta'],
      cityTo: offer['city_to'],
      airlines: airlines,
    );
  }
}

class Airport {
  final String code;
  final String name;
  final String city;
  final String country;
  final bool isVisaFree;

  const Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
    this.isVisaFree = false,
  });
}