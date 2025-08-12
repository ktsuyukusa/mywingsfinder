import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mywingsfinder/models/flight.dart';

/// Multi-platform alert service for MyWingsFinder
/// Sends deal alerts via Telegram, WhatsApp, and Line
class AlertService {
  static final AlertService _instance = AlertService._internal();
  factory AlertService() => _instance;
  AlertService._internal();

  // Configuration for different platforms
  static const Map<String, Map<String, dynamic>> _platforms = {
    'telegram': {
      'enabled': true,
      'bot_token': 'YOUR_TELEGRAM_BOT_TOKEN',
      'chat_id': 'YOUR_TELEGRAM_CHAT_ID',
      'api_url': 'https://api.telegram.org/bot{token}/sendMessage',
    },
    'whatsapp': {
      'enabled': true,
      'api_key': 'YOUR_WHATSAPP_API_KEY',
      'phone_number': 'YOUR_WHATSAPP_PHONE',
      'api_url': 'https://api.whatsapp.com/v1/messages',
    },
    'line': {
      'enabled': true,
      'channel_access_token': 'YOUR_LINE_CHANNEL_ACCESS_TOKEN',
      'user_id': 'YOUR_LINE_USER_ID',
      'api_url': 'https://api.line.me/v2/bot/message/push',
    },
    'email': {
      'enabled': false,
      'smtp_server': 'smtp.gmail.com',
      'smtp_port': 587,
      'username': 'your-email@gmail.com',
      'password': 'your-app-password',
    },
  };

  // Alert preferences
  static const Map<String, bool> _alertPreferences = {
    'mistake_fares': true,      // Always alert for mistake fares
    'budget_deals': true,       // Alert for deals under $400
    'premium_deals': true,      // Alert for premium deals under $1500
    'new_routes': true,         // Alert for new route discoveries
    'price_drops': true,        // Alert for significant price drops
  };

  // Minimum price thresholds for alerts
  static const Map<String, double> _priceThresholds = {
    'economy': 400.0,
    'business': 1500.0,
    'first': 3000.0,
  };

  /// Send alert for a new deal
  Future<bool> sendDealAlert(Flight deal, String alertType) async {
    if (!_shouldSendAlert(deal, alertType)) {
      return false;
    }

    final message = _formatDealMessage(deal, alertType);
    final success = <String, bool>{};

    // Send to all enabled platforms
    for (final platform in _platforms.entries) {
      if (platform.value['enabled'] == true) {
        try {
          final result = await _sendToPlatform(platform.key, message, deal);
          success[platform.key] = result;
          
          if (result) {
            print('✅ Alert sent to ${platform.key}');
          } else {
            print('❌ Failed to send alert to ${platform.key}');
          }
        } catch (e) {
          print('❌ Error sending alert to ${platform.key}: $e');
          success[platform.key] = false;
        }
      }
    }

    // Return true if at least one platform succeeded
    return success.values.any((s) => s);
  }

  /// Send bulk alert for multiple deals
  Future<bool> sendBulkDealAlert(List<Flight> deals, String alertType) async {
    if (deals.isEmpty) return false;

    final message = _formatBulkDealMessage(deals, alertType);
    final success = <String, bool>{};

    for (final platform in _platforms.entries) {
      if (platform.value['enabled'] == true) {
        try {
          final result = await _sendToPlatform(platform.key, message, deals.first);
          success[platform.key] = result;
        } catch (e) {
          print('❌ Error sending bulk alert to ${platform.key}: $e');
          success[platform.key] = false;
        }
      }
    }

    return success.values.any((s) => s);
  }

  /// Send daily summary alert
  Future<bool> sendDailySummary(List<Flight> todaysDeals) async {
    if (todaysDeals.isEmpty) return false;

    final message = _formatDailySummary(todaysDeals);
    final success = <String, bool>{};

    for (final platform in _platforms.entries) {
      if (platform.value['enabled'] == true) {
        try {
          final result = await _sendToPlatform(platform.key, message, todaysDeals.first);
          success[platform.key] = result;
        } catch (e) {
          print('❌ Error sending daily summary to ${platform.key}: $e');
          success[platform.key] = false;
        }
      }
    }

    return success.values.any((s) => s);
  }

  /// Determine if we should send an alert
  bool _shouldSendAlert(Flight deal, String alertType) {
    // Check alert preferences
    if (!_alertPreferences[alertType] ?? false) {
      return false;
    }

    // Check price thresholds
    final threshold = _priceThresholds[deal.flightClass.toLowerCase()] ?? double.infinity;
    if (deal.price > threshold) {
      return false;
    }

    // Always alert for mistake fares
    if (deal.isMistakeFare) {
      return true;
    }

    // Alert for significant deals
    return deal.price < threshold * 0.8; // 20% below normal price
  }

  /// Format deal message for different platforms
  String _formatDealMessage(Flight deal, String alertType) {
    final emoji = _getAlertEmoji(alertType);
    final urgency = deal.isMistakeFare ? '🚨 URGENT: ' : '';
    
    return '''
$emoji $urgency$alertType.toUpperCase() ALERT!

✈️ $deal.from → $deal.to
💰 \$${deal.price.toStringAsFixed(0)}
🏢 ${deal.airline}
🎫 ${deal.flightClass}
${deal.isDirect ? '🛫 Direct Flight' : '🔄 Connecting Flight'}
${deal.isMistakeFare ? '⚡ MISTAKE FARE!' : ''}

⏰ Found: ${_formatTimeAgo(deal.asOf)}
🔗 Book now: ${deal.bookingUrls['expedia'] ?? 'Check app for details'}

#MyWingsFinder #FlightDeals #${deal.from}${deal.to}
''';
  }

  /// Format bulk deal message
  String _formatBulkDealMessage(List<Flight> deals, String alertType) {
    final emoji = _getAlertEmoji(alertType);
    final count = deals.length;
    
    String message = '''
$emoji $alertType.toUpperCase() ALERT!

🎉 Found $count new deals!

''';

    // Show top 3 deals
    for (int i = 0; i < 3 && i < deals.length; i++) {
      final deal = deals[i];
      message += '''
${i + 1}. ${deal.from} → ${deal.to} - \$${deal.price.toStringAsFixed(0)} (${deal.airline})
''';
    }

    if (deals.length > 3) {
      message += '\n... and ${deals.length - 3} more deals!';
    }

    message += '''

🔗 View all deals in the MyWingsFinder app
#MyWingsFinder #FlightDeals #BulkAlert
''';

    return message;
  }

  /// Format daily summary
  String _formatDailySummary(List<Flight> deals) {
    final totalDeals = deals.length;
    final mistakeFares = deals.where((d) => d.isMistakeFare).length;
    final budgetDeals = deals.where((d) => d.price < 400).length;
    final premiumDeals = deals.where((d) => d.isPremium).length;

    return '''
📊 DAILY DEAL SUMMARY

🎯 Total Deals Found: $totalDeals
⚡ Mistake Fares: $mistakeFares
💰 Budget Deals (<\$400): $budgetDeals
💎 Premium Deals: $premiumDeals

🏆 Best Deal of the Day:
${deals.isNotEmpty ? '${deals.first.from} → ${deals.first.to} - \$${deals.first.price.toStringAsFixed(0)}' : 'No deals found'}

🔗 View all deals in the MyWingsFinder app
#MyWingsFinder #DailySummary #FlightDeals
''';
  }

  /// Get emoji for alert type
  String _getAlertEmoji(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'mistake_fares':
        return '⚡';
      case 'budget_deals':
        return '💰';
      case 'premium_deals':
        return '💎';
      case 'new_routes':
        return '🆕';
      case 'price_drops':
        return '📉';
      default:
        return '✈️';
    }
  }

  /// Format time ago
  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Send message to specific platform
  Future<bool> _sendToPlatform(String platform, String message, Flight deal) async {
    switch (platform) {
      case 'telegram':
        return await _sendToTelegram(message);
      case 'whatsapp':
        return await _sendToWhatsApp(message);
      case 'line':
        return await _sendToLine(message);
      case 'email':
        return await _sendToEmail(message, deal);
      default:
        print('❌ Unknown platform: $platform');
        return false;
    }
  }

  /// Send to Telegram
  Future<bool> _sendToTelegram(String message) async {
    try {
      final config = _platforms['telegram']!;
      final url = config['api_url'].toString().replaceAll('{token}', config['bot_token']);
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chat_id': config['chat_id'],
          'text': message,
          'parse_mode': 'HTML',
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Telegram error: $e');
      return false;
    }
  }

  /// Send to WhatsApp
  Future<bool> _sendToWhatsApp(String message) async {
    try {
      final config = _platforms['whatsapp']!;
      
      final response = await http.post(
        Uri.parse(config['api_url']),
        headers: {
          'Authorization': 'Bearer ${config['api_key']}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'messaging_product': 'whatsapp',
          'to': config['phone_number'],
          'type': 'text',
          'text': {'body': message},
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('WhatsApp error: $e');
      return false;
    }
  }

  /// Send to Line
  Future<bool> _sendToLine(String message) async {
    try {
      final config = _platforms['line']!;
      
      final response = await http.post(
        Uri.parse(config['api_url']),
        headers: {
          'Authorization': 'Bearer ${config['channel_access_token']}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'to': config['user_id'],
          'messages': [
            {
              'type': 'text',
              'text': message,
            },
          ],
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Line error: $e');
      return false;
    }
  }

  /// Send to Email
  Future<bool> _sendToEmail(String message, Flight deal) async {
    // This would require a proper email library like mailer
    // For now, just return false
    print('Email alerts not implemented yet');
    return false;
  }

  /// Get alert statistics
  Map<String, dynamic> getAlertStats() {
    return {
      'platforms_enabled': _platforms.values.where((p) => p['enabled'] == true).length,
      'total_platforms': _platforms.length,
      'alert_preferences': _alertPreferences,
      'price_thresholds': _priceThresholds,
    };
  }

  /// Update platform configuration
  void updatePlatformConfig(String platform, Map<String, dynamic> config) {
    if (_platforms.containsKey(platform)) {
      _platforms[platform]!.addAll(config);
      print('✅ Updated $platform configuration');
    }
  }

  /// Enable/disable platform
  void setPlatformEnabled(String platform, bool enabled) {
    if (_platforms.containsKey(platform)) {
      _platforms[platform]!['enabled'] = enabled;
      print('${enabled ? '✅' : '❌'} ${enabled ? 'Enabled' : 'Disabled'} $platform');
    }
  }
}
