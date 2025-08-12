import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';

class TravelServicesTab extends StatelessWidget {
  const TravelServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏨 Complete Travel Solutions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Premium services for executive travelers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          
          // Hotels Section
          ServiceCard(
            icon: Icons.hotel,
            title: 'Luxury Hotels & Accommodations',
            description: 'Book premium hotels worldwide with best price guarantee',
            color: Colors.blue,
            onTap: () => _launchURL('https://expedia.com/affiliate/AjmUZGx'),
          ),
          
          const SizedBox(height: 16),
          
          // VIP Transfers Section  
          ServiceCard(
            icon: Icons.directions_car,
            title: 'VIP Airport Transfers & Chauffeur',
            description: 'Blacklane premium chauffeur service in 250+ cities',
            color: Colors.black87,
            onTap: () => _launchURL('https://www.blacklane.com/en/'),
          ),
          
          const SizedBox(height: 16),
          
          // Travel Insurance Section
          ServiceCard(
            icon: Icons.security,
            title: 'Comprehensive Travel Insurance',
            description: 'Protect your trip with World Nomads & premium coverage',
            color: Colors.green,
            onTap: () => _showInsuranceOptions(context),
          ),
          
          const SizedBox(height: 16),
          
          // Private Jets Section
          ServiceCard(
            icon: Icons.flight_class,
            title: 'Private Jet Charter',
            description: 'On-demand private aviation for ultimate convenience',
            color: Colors.amber.shade800,
            onTap: () => _showPrivateJetOptions(context),
          ),
          
          const SizedBox(height: 16),
          
          // Car Rentals Section
          ServiceCard(
            icon: Icons.car_rental,
            title: 'Premium Car Rentals',
            description: 'Luxury and business car rentals worldwide',
            color: Colors.purple,
            onTap: () => _launchURL('https://expedia.com/affiliate/AjmUZGx'),
          ),
          
          const SizedBox(height: 24),
          
          // Partnership Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.handshake,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium Partner Services',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All services are provided through our trusted affiliate partners with competitive rates and excellent customer service.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showInsuranceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => InsuranceOptionsSheet(),
    );
  }

  void _showPrivateJetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => PrivateJetOptionsSheet(),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InsuranceOptionsSheet extends StatelessWidget {
  const InsuranceOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🛡️ Travel Insurance Options',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          InsuranceOptionTile(
            title: 'World Nomads',
            subtitle: 'Comprehensive coverage for adventurous travelers',
            onTap: () => _launchURL('https://www.worldnomads.com/?utm_source=wingfinder&utm_medium=affiliate'),
          ),
          
          InsuranceOptionTile(
            title: 'Insubuy',
            subtitle: 'Specialized international travel insurance',
            onTap: () => _launchURL('https://www.insubuy.com/?utm_source=wingfinder&utm_medium=affiliate'),
          ),
          
          InsuranceOptionTile(
            title: 'VisitorsCoverage',
            subtitle: 'Business travel and visitor insurance',
            onTap: () => _launchURL('https://www.visitorscoverage.com/?utm_source=wingfinder&utm_medium=affiliate'),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class PrivateJetOptionsSheet extends StatelessWidget {
  const PrivateJetOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🛩️ Private Jet Charter',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          InsuranceOptionTile(
            title: 'FXAir (PrivateFly)',
            subtitle: 'On-demand private jet charter worldwide',
            onTap: () => _launchURL('https://www.fxair.com/?utm_source=wingfinder&utm_medium=affiliate'),
          ),
          
          InsuranceOptionTile(
            title: 'NetJets',
            subtitle: 'Premium fractional jet ownership',
            onTap: () => _launchURL('https://www.netjets.com/?utm_source=wingfinder&utm_medium=referral'),
          ),
          
          InsuranceOptionTile(
            title: 'Flexjet',
            subtitle: 'Luxury private aviation solutions',
            onTap: () => _launchURL('https://www.flexjet.com/?utm_source=wingfinder&utm_medium=referral'),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class InsuranceOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const InsuranceOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: onTap,
    );
  }
}