// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ウィングファインダー - 日本からヨーロッパ便';

  @override
  String get budgetFlights => '💸 格安航空券';

  @override
  String get premiumFlights => '🛫 プレミアム/VIP';

  @override
  String get departing => '出発地';

  @override
  String get arriving => '到着地';

  @override
  String get selectDeparture => '出発地を選択';

  @override
  String get selectArrival => '到着地を選択';

  @override
  String get selectDate => '日付を選択';

  @override
  String get searchFlights => 'フライト検索';

  @override
  String get oneWay => '片道';

  @override
  String get roundTrip => '往復';

  @override
  String get budgetTabDescription => '片道\$399以下・往復\$650以下の格安航空券';

  @override
  String get premiumTabDescription => 'プレミアム航空券、ビジネスクラス、VIPオプション';

  @override
  String get airline => '航空会社';

  @override
  String get price => '料金';

  @override
  String get duration => '飛行時間';

  @override
  String get stops => '経由地';

  @override
  String get departure => '出発';

  @override
  String get arrival => '到着';

  @override
  String get nonstop => '直行便';

  @override
  String get stop => '経由';

  @override
  String get stops_plural => '経由';

  @override
  String get directFlight => '直行便';

  @override
  String get from => 'から';

  @override
  String get to => 'まで';

  @override
  String get flightClass => 'クラス';

  @override
  String get economyClass => 'エコノミー';

  @override
  String get premiumEconomyClass => 'プレミアムエコノミー';

  @override
  String get businessClass => 'ビジネス';

  @override
  String get firstClass => 'ファースト';

  @override
  String get privateJet => 'プライベートジェット';

  @override
  String get aircraft => '機材';

  @override
  String get availableSeats => '空席数';

  @override
  String get baggageIncluded => '手荷物込み';

  @override
  String get mealService => '機内食';

  @override
  String get entertainment => 'エンターテイメント';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get loungeAccess => 'ラウンジ利用';

  @override
  String get priorityBoarding => '優先搭乗';

  @override
  String get refundable => '返金可能';

  @override
  String get changeable => '変更可能';

  @override
  String get included => '込み';

  @override
  String get available => '利用可能';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String flightsFound(int count) {
    return '$count件のフライトが見つかりました';
  }

  @override
  String get updatedAgo => '2時間前に更新';

  @override
  String get noFlightsMatch => '条件に一致するフライトがありません';

  @override
  String get clearFilters => 'フィルターをクリア';

  @override
  String get premiumPrivateFlights => 'プレミアム・プライベート航空券';

  @override
  String get businessFirstPrivateDeals => 'ビジネス、ファーストクラス、プライベートジェット特価';

  @override
  String get fromJapan => '日本から';

  @override
  String get toEurope => 'ヨーロッパへ';

  @override
  String get allJapaneseAirports => '全ての日本の空港';

  @override
  String get allEuropeanAirports => '全てのヨーロッパの空港';

  @override
  String get allClasses => '全てのクラス';

  @override
  String get directFlightsOnly => '直行便のみ';

  @override
  String premiumFlightsFound(int count) {
    return '$count件のプレミアム航空券';
  }

  @override
  String get vipDeals => 'VIP特価';

  @override
  String get noPremiumFlights => 'プレミアム航空券はありません';

  @override
  String get directOnly => '直行便のみ';

  @override
  String get visaFree => 'ビザ不要';

  @override
  String get mistakeFares => '🚨 ミステイク運賃';

  @override
  String get clearAllFilters => '全てのフィルターをクリア';

  @override
  String get mistakeFare => 'ミステイク運賃';

  @override
  String get hiddenCity => '隠し都市';

  @override
  String get bookNow => '今すぐ予約';
}
