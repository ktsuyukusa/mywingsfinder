import 'package:flutter/material.dart';
import 'package:mywingsfinder/widgets/flight_card.dart';
import 'package:mywingsfinder/models/flight.dart';
import 'package:mywingsfinder/services/deal_discovery_service.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';
import 'dart:async';

/// Premium Flights Tab - Shows automatically discovered premium deals
class PremiumFlightsTab extends StatefulWidget {
  const PremiumFlightsTab({super.key});

  @override
  State<PremiumFlightsTab> createState() => _PremiumFlightsTabState();
}

class _PremiumFlightsTabState extends State<PremiumFlightsTab> {
  List<Flight> _premiumDeals = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  final DealDiscoveryService _dealService = DealDiscoveryService();

  @override
  void initState() {
    super.initState();
    _loadPremiumDeals();
    
    // Refresh deals every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (_) {
      _loadPremiumDeals();
    });
  }

  Future<void> _loadPremiumDeals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get premium deals
      final deals = _dealService.getDealsByCategory('premium');
      
      // Apply additional filters
      List<Flight> filteredDeals;
      switch (_selectedFilter) {
        case 'business':
          filteredDeals = deals.where((f) => f.flightClass == 'Business').toList();
          break;
        case 'first':
          filteredDeals = deals.where((f) => f.flightClass == 'First').toList();
          break;
        case 'luxury':
          filteredDeals = deals.where((f) => f.price > 2000).toList();
          break;
        case 'latest':
          filteredDeals = _dealService.getLatestDeals()
              .where((f) => f.isPremium)
              .toList();
          break;
        default:
          filteredDeals = deals;
      }

      setState(() {
        _premiumDeals = filteredDeals;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading premium deals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadPremiumDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Premium deals header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
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
                    '💎 Premium Deal Discovery',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.diamond,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Luxury flights at unbeatable prices • ${_premiumDeals.length} premium deals',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),

        // Filter chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'All Premium', Icons.flight_class),
                const SizedBox(width: 8),
                _buildFilterChip('business', 'Business', Icons.business),
                const SizedBox(width: 8),
                _buildFilterChip('first', 'First Class', Icons.king_bed),
                const SizedBox(width: 8),
                _buildFilterChip('luxury', 'Luxury (>\\\$2K)', Icons.workspace_premium),
                const SizedBox(width: 8),
                _buildFilterChip('latest', 'Latest (24h)', Icons.access_time),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_premiumDeals.length} premium deals found',
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
                    onPressed: _loadPremiumDeals,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh premium deals',
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
                      Text('Discovering premium deals...'),
                    ],
                  ),
                )
              : _premiumDeals.isEmpty
                  ? _buildEmptyState()
                  : _buildPremiumDealsList(),
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
            Icons.flight_class,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No premium deals found yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our premium deal hunters are searching for luxury offers.\nCheck back soon for exclusive deals!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadPremiumDeals,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumDealsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _premiumDeals.length,
      itemBuilder: (context, index) {
        final deal = _premiumDeals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FlightCard(flight: deal),
        );
      },
    );
  }

  String _getTimeAgo() {
    if (_premiumDeals.isEmpty) return 'never';
    
    final now = DateTime.now();
    final latestDeal = _premiumDeals.first;
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
