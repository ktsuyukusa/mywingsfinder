import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';
import 'package:mywingsfinder/services/api_config.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;

  const FlightCard({super.key, required this.flight});

  String _formatDate(DateTime date) => DateFormat('MMM dd').format(date);

  String _getClassIcon(String flightClass) {
    switch (flightClass) {
      case 'Business': return '💼';
      case 'First': return '👑';
      case 'Private': return '🛩️';
      default: return '✈️';
    }
  }

  Color _getClassColor(BuildContext context, String flightClass) {
    switch (flightClass) {
      case 'Business': return Theme.of(context).colorScheme.tertiary;
      case 'First': return const Color(0xFFFFD700);
      case 'Private': return Theme.of(context).colorScheme.secondary;
      default: return Theme.of(context).colorScheme.primary;
    }
  }

  String _getLocalizedClass(AppLocalizations l10n, String flightClass) {
    switch (flightClass) {
      case 'Business': return l10n.businessClass;
      case 'First': return l10n.firstClass;
      case 'Private': return l10n.privateJet;
      case 'Economy': return l10n.economyClass;
      case 'Premium Economy': return l10n.premiumEconomyClass;
      default: return flightClass;
    }
  }

  String _generateBookingUrl(Flight flight) {
    final airline = flight.airline.toLowerCase();
    
    // Private jets use specific charter service
    if (airline.contains('privatefly')) {
      return 'https://www.fxair.com/en-us';
    }
    
    // For all other flights, use Kiwi affiliate link with flight parameters
    final depDate = DateFormat('dd/MM/yyyy').format(flight.departureDate);
    final retDate = flight.isRoundTrip 
        ? DateFormat('dd/MM/yyyy').format(flight.returnDate!)
        : '';
    
    // Build Kiwi.com booking URL with affiliate tracking
    String kiwiUrl = ApiConfig.getKiwiAffiliateLink();
    
    // Add search parameters to the Kiwi affiliate link
    kiwiUrl += '?adults=1';
    kiwiUrl += '&flyFrom=${flight.departureCode}';
    kiwiUrl += '&to=${flight.arrivalCode}';
    kiwiUrl += '&dateFrom=${Uri.encodeComponent(depDate)}';
    
    if (flight.isRoundTrip) {
      kiwiUrl += '&typeFlight=round';
      kiwiUrl += '&dateTo=${Uri.encodeComponent(retDate)}';
    } else {
      kiwiUrl += '&typeFlight=oneway';
    }
    
    // Add cabin class preference
    switch (flight.flightClass) {
      case 'Business':
        kiwiUrl += '&selectedCabins=C';
        break;
      case 'First':
        kiwiUrl += '&selectedCabins=F';
        break;
      default:
        kiwiUrl += '&selectedCabins=M'; // Economy
    }
    
    // Add tracking parameters
    kiwiUrl += '&utm_source=mywingsfinder';
    kiwiUrl += '&utm_medium=affiliate';
    kiwiUrl += '&utm_campaign=flight_search';
    
    return kiwiUrl;
  }

  Future<void> _launchUrl(Flight flight) async {
    final url = _generateBookingUrl(flight);
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getClassColor(context, flight.flightClass).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getClassIcon(flight.flightClass)),
                      const SizedBox(width: 4),
                      Text(
                        _getLocalizedClass(l10n, flight.flightClass),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getClassColor(context, flight.flightClass),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (flight.isMistakeFare)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt,
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.mistakeFare,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (flight.isHiddenCity)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility_off,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.hiddenCity,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.departureCode,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        flight.departureName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Column(
                  children: [
                    Icon(
                      flight.isDirect ? Icons.trending_flat : Icons.connecting_airports,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    if (!flight.isDirect && flight.layovers.isNotEmpty)
                      Text(
                        flight.layovers.join(', '),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        flight.arrivalCode,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        flight.arrivalName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  flight.isRoundTrip 
                    ? '${_formatDate(flight.departureDate)} - ${_formatDate(flight.returnDate!)}'
                    : _formatDate(flight.departureDate),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.business,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  flight.airline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            
            if (flight.strategy.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        flight.strategy,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${flight.currency} ${flight.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: flight.isAlert 
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      flight.isRoundTrip ? l10n.roundTrip : l10n.oneWay,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(flight),
                  icon: Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    l10n.bookNow,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
