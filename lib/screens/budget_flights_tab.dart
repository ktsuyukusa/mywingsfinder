import 'package:flutter/material.dart';
import 'package:mywingsfinder/widgets/flight_card.dart';
import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/services/deal_discovery_service.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';
import 'dart:async'; // Added for Timer

/// Budget Flights Tab - Shows automatically discovered deals
class BudgetFlightsTab extends StatefulWidget {
  const BudgetFlightsTab({super.key});

  @override
  State<BudgetFlightsTab> createState() => _BudgetFlightsTabState();
}

class _BudgetFlightsTabState extends State<BudgetFlightsTab> {
  List<Flight> _discoveredDeals = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  final DealDiscoveryService _dealService = DealDiscoveryService();

  @override
  void initState() {
    super.initState();
    _loadDiscoveredDeals();
    
    // Refresh deals every 30 seconds to show new discoveries
    Timer.periodic(const Duration(seconds: 30), (_) {
      _loadDiscoveredDeals();
    });
  }

  Future<void> _loadDiscoveredDeals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get all discovered deals
      final deals = _dealService.getDiscoveredDeals();
      
      // Apply filter
      List<Flight> filteredDeals;
      switch (_selectedFilter) {
        case 'mistake_fares':
          filteredDeals = _dealService.getDealsByCategory('mistake_fares');
          break;
        case 'budget':
          filteredDeals = _dealService.getDealsByCategory('budget');
          break;
        case 'direct':
          filteredDeals = _dealService.getDealsByCategory('direct');
          break;
        case 'latest':
          filteredDeals = _dealService.getLatestDeals();
          break;
        default:
          filteredDeals = deals;
      }

      setState(() {
        _discoveredDeals = filteredDeals;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading discovered deals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadDiscoveredDeals();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Header with deal discovery status
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🚀 Deal Discovery Active',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Icon(
                    Icons.radar,
                    color: Colors.green,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Finding deals every 45 minutes • ${_discoveredDeals.length} deals discovered',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

        // Filter buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'All Deals', Icons.flight),
                const SizedBox(width: 8),
                _buildFilterChip('mistake_fares', 'Mistake Fares', Icons.bolt),
                const SizedBox(width: 8),
                _buildFilterChip('budget', 'Budget (<\$400)', Icons.attach_money),
                const SizedBox(width: 8),
                _buildFilterChip('direct', 'Direct Only', Icons.flight_takeoff),
                const SizedBox(width: 8),
                _buildFilterChip('latest', 'Latest (24h)', Icons.access_time),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Results count and refresh button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_discoveredDeals.length} deals found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Updated ${_getTimeAgo()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _loadDiscoveredDeals,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh deals',
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Deals list
        Expanded(
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Discovering amazing deals...'),
                    ],
                  ),
                )
              : _discoveredDeals.isEmpty
                  ? _buildEmptyState()
                  : _buildDealsList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String filter, String label, IconData icon) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (_) => _onFilterChanged(filter),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No deals found yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our deal hunters are searching continuously.\nCheck back soon for amazing offers!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadDiscoveredDeals,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildDealsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _discoveredDeals.length,
      itemBuilder: (context, index) {
        final deal = _discoveredDeals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FlightCard(flight: deal),
        );
      },
    );
  }

  String _getTimeAgo() {
    if (_discoveredDeals.isEmpty) return 'never';
    
    final now = DateTime.now();
    final latestDeal = _discoveredDeals.first;
    final difference = now.difference(latestDeal.asOf);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
