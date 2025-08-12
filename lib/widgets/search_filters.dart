import 'package:flutter/material.dart';
import 'package:mywingsfinder/data/airports.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';

class SearchFilters extends StatelessWidget {
  final String? selectedDeparture;
  final String? selectedArrival;
  final bool showOnlyDirect;
  final bool showOnlyVisaFree;
  final bool showOnlyMistakeFares;
  final ValueChanged<String?> onDepartureChanged;
  final ValueChanged<String?> onArrivalChanged;
  final ValueChanged<bool> onDirectChanged;
  final ValueChanged<bool> onVisaFreeChanged;
  final ValueChanged<bool> onMistakeFaresChanged;
  final VoidCallback onClearFilters;

  const SearchFilters({
    super.key,
    this.selectedDeparture,
    this.selectedArrival,
    required this.showOnlyDirect,
    required this.showOnlyVisaFree,
    required this.showOnlyMistakeFares,
    required this.onDepartureChanged,
    required this.onArrivalChanged,
    required this.onDirectChanged,
    required this.onVisaFreeChanged,
    required this.onMistakeFaresChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedDeparture,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.fromJapan,
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.flight_takeoff,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.allJapaneseAirports)),
                    ...Airports.japaneseAirports.map((airport) =>
                      DropdownMenuItem(
                        value: airport.code,
                        child: Text(
                          '${airport.code} - ${airport.city}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: onDepartureChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedArrival,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.toEurope,
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.flight_land,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.allEuropeanAirports)),
                    ...Airports.europeanAirports.map((airport) =>
                      DropdownMenuItem(
                        value: airport.code,
                        child: Text(
                          '${airport.code} - ${airport.city}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: onArrivalChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: Text(l10n.directOnly),
                selected: showOnlyDirect,
                onSelected: onDirectChanged,
                avatar: Icon(
                  Icons.trending_flat,
                  size: 18,
                  color: showOnlyDirect 
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              FilterChip(
                label: Text(l10n.visaFree),
                selected: showOnlyVisaFree,
                onSelected: onVisaFreeChanged,
                avatar: Icon(
                  Icons.verified_user,
                  size: 18,
                  color: showOnlyVisaFree 
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              FilterChip(
                label: Text(l10n.mistakeFares),
                selected: showOnlyMistakeFares,
                onSelected: onMistakeFaresChanged,
                avatar: Icon(
                  Icons.bolt,
                  size: 18,
                  color: showOnlyMistakeFares 
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          if (selectedDeparture != null || selectedArrival != null || showOnlyDirect || showOnlyVisaFree || showOnlyMistakeFares)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onClearFilters,
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    l10n.clearAllFilters,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
