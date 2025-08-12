import 'package:flutter/material.dart';
import 'package:mywingsfinder/data/airports.dart';
import 'package:mywingsfinder/widgets/flight_card.dart';
import 'package:mywingsfinder/widgets/search_filters.dart';
import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/services/flight_repository.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';

class PremiumFlightsTab extends StatefulWidget {
  const PremiumFlightsTab({super.key});

  @override
  State<PremiumFlightsTab> createState() => _PremiumFlightsTabState();
}

class _PremiumFlightsTabState extends State<PremiumFlightsTab> {
  List<Flight> _flights = [];
  String? _selectedDeparture;
  String? _selectedArrival;
  String _selectedClass = 'All';
  bool _showOnlyDirect = false;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() async {
    try {
      final repository = FlightRepository();
      final flights = await repository.getPremiumFlights(
        flightClass: _selectedClass == 'All' ? null : _selectedClass,
      );
      setState(() {
        _flights = flights;
      });
    } catch (e) {
      print('Error loading premium flights: $e');
      setState(() {
        _flights = [];
      });
    }
  }

  List<Flight> get _filteredFlights {
    var filtered = _flights;

    if (_selectedDeparture != null) {
      filtered = filtered.where((f) => f.departureCode == _selectedDeparture).toList();
    }

    if (_selectedArrival != null) {
      filtered = filtered.where((f) => f.arrivalCode == _selectedArrival).toList();
    }

    if (_selectedClass != 'All') {
      filtered = filtered.where((f) => f.flightClass == _selectedClass).toList();
    }

    if (_showOnlyDirect) {
      filtered = filtered.where((f) => f.isDirect).toList();
    }

    filtered.sort((a, b) => a.price.compareTo(b.price));
    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _selectedDeparture = null;
      _selectedArrival = null;
      _selectedClass = 'All';
      _showOnlyDirect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.premiumPrivateFlights,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.businessFirstPrivateDeals,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDeparture,
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
                      onChanged: (value) => setState(() => _selectedDeparture = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedArrival,
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
                      onChanged: (value) => setState(() => _selectedArrival = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedClass,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.flightClass,
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.airline_seat_flat,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                      ),
                      items: [
                        DropdownMenuItem(value: 'All', child: Text(l10n.allClasses)),
                        DropdownMenuItem(value: 'Business', child: Text(l10n.businessClass)),
                        DropdownMenuItem(value: 'First', child: Text(l10n.firstClass)),
                        DropdownMenuItem(value: 'Private', child: Text(l10n.privateJet)),
                      ],
                      onChanged: (value) => setState(() => _selectedClass = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: _showOnlyDirect,
                          onChanged: (value) => setState(() => _showOnlyDirect = value!),
                        ),
                        Expanded(
                          child: Text(
                            l10n.directFlightsOnly,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_selectedDeparture != null || _selectedArrival != null || _selectedClass != 'All' || _showOnlyDirect)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                      label: Text(l10n.clearFilters),
                    ),
                  ),
                ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.premiumFlightsFound(_filteredFlights.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.vipDeals,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: _filteredFlights.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flight_class,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noPremiumFlights,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text(l10n.clearFilters),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredFlights.length,
                  itemBuilder: (context, index) {
                    final flight = _filteredFlights[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FlightCard(flight: flight),
                    );
                  },
                ),
        ),
      ],
    );
  }
}