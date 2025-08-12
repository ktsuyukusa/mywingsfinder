import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  bool get isJapanese => locale.languageCode == 'ja';

  // App Title
  String get appTitle => isJapanese ? 'ウィングファインダー - 日本からヨーロッパ便' : 'WingFinder - Japan to Europe Flights';
  
  // Tab titles
  String get budgetFlights => isJapanese ? '💸 格安航空券' : '💸 Budget Flights';
  String get premiumFlights => isJapanese ? '🛫 プレミアム/VIP' : '🛫 Premium/VIP';
  
  // Search labels
  String get departing => isJapanese ? '出発地' : 'Departing';
  String get arriving => isJapanese ? '到着地' : 'Arriving';
  String get selectDeparture => isJapanese ? '出発地を選択' : 'Select departure';
  String get selectArrival => isJapanese ? '到着地を選択' : 'Select arrival';
  String get selectDate => isJapanese ? '日付を選択' : 'Select date';
  String get searchFlights => isJapanese ? 'フライト検索' : 'Search Flights';
  String get oneWay => isJapanese ? '片道' : 'One-way';
  String get roundTrip => isJapanese ? '往復' : 'Round-trip';
  
  // Filter labels
  String get fromJapan => isJapanese ? '日本から' : 'From Japan';
  String get toEurope => isJapanese ? 'ヨーロッパへ' : 'To Europe';
  String get allJapaneseAirports => isJapanese ? '全ての日本の空港' : 'All Japanese airports';
  String get allEuropeanAirports => isJapanese ? '全てのヨーロッパの空港' : 'All European airports';
  String get directOnly => isJapanese ? '直行便のみ' : 'Direct only';
  String get visaFree => isJapanese ? 'ビザ不要' : 'Visa-free';
  String get mistakeFares => isJapanese ? '🚨 ミステイク運賃' : '🚨 Mistake fares';
  String get clearAllFilters => isJapanese ? '全てのフィルターをクリア' : 'Clear all filters';
  String get clearFilters => isJapanese ? 'フィルターをクリア' : 'Clear filters';
  
  // Flight classes
  String get flightClass => isJapanese ? 'クラス' : 'Class';
  String get economyClass => isJapanese ? 'エコノミー' : 'Economy';
  String get premiumEconomyClass => isJapanese ? 'プレミアムエコノミー' : 'Premium Economy';
  String get businessClass => isJapanese ? 'ビジネス' : 'Business';
  String get firstClass => isJapanese ? 'ファースト' : 'First';
  String get privateJet => isJapanese ? 'プライベートジェット' : 'Private Jet';
  String get allClasses => isJapanese ? '全てのクラス' : 'All Classes';
  
  // Flight details
  String get airline => isJapanese ? '航空会社' : 'Airline';
  String get price => isJapanese ? '料金' : 'Price';
  String get duration => isJapanese ? '飛行時間' : 'Duration';
  String get stops => isJapanese ? '経由地' : 'Stops';
  String get departure => isJapanese ? '出発' : 'Departure';
  String get arrival => isJapanese ? '到着' : 'Arrival';
  String get nonstop => isJapanese ? '直行便' : 'Nonstop';
  String get directFlight => isJapanese ? '直行便' : 'Direct flight';
  String get directFlightsOnly => isJapanese ? '直行便のみ' : 'Direct flights only';
  
  // Premium section
  String get premiumPrivateFlights => isJapanese ? 'プレミアム・プライベート航空券' : 'Premium & Private Flights';
  String get businessFirstPrivateDeals => isJapanese ? 'ビジネス、ファーストクラス、プライベートジェット特価' : 'Business, First Class & Private Jet deals';
  
  // Status messages
  String flightsFound(int count) => isJapanese ? '${count}件のフライトが見つかりました' : '$count flights found';
  String premiumFlightsFound(int count) => isJapanese ? '${count}件のプレミアム航空券' : '$count premium flights';
  String get updatedAgo => isJapanese ? '2時間前に更新' : 'Updated 2h ago';
  String get noFlightsMatch => isJapanese ? '条件に一致するフライトがありません' : 'No flights match your filters';
  String get noPremiumFlights => isJapanese ? 'プレミアム航空券はありません' : 'No premium flights available';
  String get vipDeals => isJapanese ? 'VIP特価' : 'VIP Deals';
  
  // Labels and buttons
  String get mistakeFare => isJapanese ? 'ミステイク運賃' : 'MISTAKE FARE';
  String get hiddenCity => isJapanese ? '隠し都市' : 'HIDDEN CITY';
  String get bookNow => isJapanese ? '今すぐ予約' : 'Book Now';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}