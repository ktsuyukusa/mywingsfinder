import 'package:flutter/material.dart';
import 'package:mywingsfinder/data/airports.dart';
import 'package:mywingsfinder/widgets/flight_card.dart';
import 'package:mywingsfinder/widgets/search_filters.dart';
import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/services/flight_repository.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';

class BudgetFlightsTab extends StatefulWidget {
  const BudgetFlightsTab({super.key});

  @override
  State<BudgetFlightsTab> createState() => _BudgetFlightsTabState();
}

class _BudgetFlightsTabState extends State<BudgetFlightsTab> {
  List<Flight> _flights = [];
  String? _selectedDeparture;
  String? _selectedArrival;
  bool _showOnlyDirect = false;
  bool _showOnlyVisaFree = false;
  bool _showOnlyMistakeFares = false;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() async {
    try {
      final repository = FlightRepository();
      final flights = await repository.getBudgetFlights(
        directOnly: _showOnlyDirect,
        visaFreeOnly: _showOnlyVisaFree,
        mistakeFareOnly: _showOnlyMistakeFares,
      );
      setState(() {
        _flights = flights;
      });
    } catch (e) {
      print('Error loading budget flights: $e');
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

    if (_showOnlyDirect) {
      filtered = filtered.where((f) => f.isDirect).toList();
    }

    if (_showOnlyVisaFree) {
      final visaFreeDestinations = Airports.europeanAirports
          .where((a) => a.isVisaFree)
          .map((a) => a.code);
      filtered = filtered.where((f) => visaFreeDestinations.contains(f.arrivalCode)).toList();
    }

    if (_showOnlyMistakeFares) {
      filtered = filtered.where((f) => f.isMistakeFare).toList();
    }

    filtered.sort((a, b) => a.price.compareTo(b.price));
    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _selectedDeparture = null;
      _selectedArrival = null;
      _showOnlyDirect = false;
      _showOnlyVisaFree = false;
      _showOnlyMistakeFares = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        SearchFilters(
          selectedDeparture: _selectedDeparture,
          selectedArrival: _selectedArrival,
          showOnlyDirect: _showOnlyDirect,
          showOnlyVisaFree: _showOnlyVisaFree,
          showOnlyMistakeFares: _showOnlyMistakeFares,
          onDepartureChanged: (value) => setState(() => _selectedDeparture = value),
          onArrivalChanged: (value) => setState(() => _selectedArrival = value),
          onDirectChanged: (value) => setState(() => _showOnlyDirect = value),
          onVisaFreeChanged: (value) => setState(() => _showOnlyVisaFree = value),
          onMistakeFaresChanged: (value) => setState(() => _showOnlyMistakeFares = value),
          onClearFilters: _clearFilters,
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.flightsFound(_filteredFlights.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.updatedAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
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
                        Icons.flight_takeoff,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noFlightsMatch,
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