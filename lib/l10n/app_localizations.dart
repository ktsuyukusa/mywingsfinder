import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WingFinder - Japan to Europe Flights'**
  String get appTitle;

  /// No description provided for @budgetFlights.
  ///
  /// In en, this message translates to:
  /// **'💸 Budget Flights'**
  String get budgetFlights;

  /// No description provided for @premiumFlights.
  ///
  /// In en, this message translates to:
  /// **'🛫 Premium/VIP'**
  String get premiumFlights;

  /// No description provided for @departing.
  ///
  /// In en, this message translates to:
  /// **'Departing'**
  String get departing;

  /// No description provided for @arriving.
  ///
  /// In en, this message translates to:
  /// **'Arriving'**
  String get arriving;

  /// No description provided for @selectDeparture.
  ///
  /// In en, this message translates to:
  /// **'Select departure'**
  String get selectDeparture;

  /// No description provided for @selectArrival.
  ///
  /// In en, this message translates to:
  /// **'Select arrival'**
  String get selectArrival;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @searchFlights.
  ///
  /// In en, this message translates to:
  /// **'Search Flights'**
  String get searchFlights;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One-way'**
  String get oneWay;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round-trip'**
  String get roundTrip;

  /// No description provided for @budgetTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Budget flights under \$399 one-way / \$650 round-trip'**
  String get budgetTabDescription;

  /// No description provided for @premiumTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Premium flights, business class, and VIP options'**
  String get premiumTabDescription;

  /// No description provided for @airline.
  ///
  /// In en, this message translates to:
  /// **'Airline'**
  String get airline;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @nonstop.
  ///
  /// In en, this message translates to:
  /// **'Nonstop'**
  String get nonstop;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'stop'**
  String get stop;

  /// No description provided for @stops_plural.
  ///
  /// In en, this message translates to:
  /// **'stops'**
  String get stops_plural;

  /// No description provided for @directFlight.
  ///
  /// In en, this message translates to:
  /// **'Direct flight'**
  String get directFlight;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @flightClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get flightClass;

  /// No description provided for @economyClass.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economyClass;

  /// No description provided for @premiumEconomyClass.
  ///
  /// In en, this message translates to:
  /// **'Premium Economy'**
  String get premiumEconomyClass;

  /// No description provided for @businessClass.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get businessClass;

  /// No description provided for @firstClass.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get firstClass;

  /// No description provided for @privateJet.
  ///
  /// In en, this message translates to:
  /// **'Private Jet'**
  String get privateJet;

  /// No description provided for @aircraft.
  ///
  /// In en, this message translates to:
  /// **'Aircraft'**
  String get aircraft;

  /// No description provided for @availableSeats.
  ///
  /// In en, this message translates to:
  /// **'Available Seats'**
  String get availableSeats;

  /// No description provided for @baggageIncluded.
  ///
  /// In en, this message translates to:
  /// **'Baggage Included'**
  String get baggageIncluded;

  /// No description provided for @mealService.
  ///
  /// In en, this message translates to:
  /// **'Meal Service'**
  String get mealService;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// No description provided for @loungeAccess.
  ///
  /// In en, this message translates to:
  /// **'Lounge Access'**
  String get loungeAccess;

  /// No description provided for @priorityBoarding.
  ///
  /// In en, this message translates to:
  /// **'Priority Boarding'**
  String get priorityBoarding;

  /// No description provided for @refundable.
  ///
  /// In en, this message translates to:
  /// **'Refundable'**
  String get refundable;

  /// No description provided for @changeable.
  ///
  /// In en, this message translates to:
  /// **'Changeable'**
  String get changeable;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get included;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @flightsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} flights found'**
  String flightsFound(int count);

  /// No description provided for @updatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated 2h ago'**
  String get updatedAgo;

  /// No description provided for @noFlightsMatch.
  ///
  /// In en, this message translates to:
  /// **'No flights match your filters'**
  String get noFlightsMatch;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @premiumPrivateFlights.
  ///
  /// In en, this message translates to:
  /// **'Premium & Private Flights'**
  String get premiumPrivateFlights;

  /// No description provided for @businessFirstPrivateDeals.
  ///
  /// In en, this message translates to:
  /// **'Business, First Class & Private Jet deals'**
  String get businessFirstPrivateDeals;

  /// No description provided for @fromJapan.
  ///
  /// In en, this message translates to:
  /// **'From Japan'**
  String get fromJapan;

  /// No description provided for @toEurope.
  ///
  /// In en, this message translates to:
  /// **'To Europe'**
  String get toEurope;

  /// No description provided for @allJapaneseAirports.
  ///
  /// In en, this message translates to:
  /// **'All Japanese airports'**
  String get allJapaneseAirports;

  /// No description provided for @allEuropeanAirports.
  ///
  /// In en, this message translates to:
  /// **'All European airports'**
  String get allEuropeanAirports;

  /// No description provided for @allClasses.
  ///
  /// In en, this message translates to:
  /// **'All Classes'**
  String get allClasses;

  /// No description provided for @directFlightsOnly.
  ///
  /// In en, this message translates to:
  /// **'Direct flights only'**
  String get directFlightsOnly;

  /// No description provided for @premiumFlightsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} premium flights'**
  String premiumFlightsFound(int count);

  /// No description provided for @vipDeals.
  ///
  /// In en, this message translates to:
  /// **'VIP Deals'**
  String get vipDeals;

  /// No description provided for @noPremiumFlights.
  ///
  /// In en, this message translates to:
  /// **'No premium flights available'**
  String get noPremiumFlights;

  /// No description provided for @directOnly.
  ///
  /// In en, this message translates to:
  /// **'Direct only'**
  String get directOnly;

  /// No description provided for @visaFree.
  ///
  /// In en, this message translates to:
  /// **'Visa-free'**
  String get visaFree;

  /// No description provided for @mistakeFares.
  ///
  /// In en, this message translates to:
  /// **'🚨 Mistake fares'**
  String get mistakeFares;

  /// No description provided for @clearAllFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear all filters'**
  String get clearAllFilters;

  /// No description provided for @mistakeFare.
  ///
  /// In en, this message translates to:
  /// **'MISTAKE FARE'**
  String get mistakeFare;

  /// No description provided for @hiddenCity.
  ///
  /// In en, this message translates to:
  /// **'HIDDEN CITY'**
  String get hiddenCity;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
