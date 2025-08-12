import 'package:flutter/material.dart';
import 'package:mywingsfinder/screens/budget_flights_tab.dart';
import 'package:mywingsfinder/screens/premium_flights_tab.dart';
import 'package:mywingsfinder/screens/travel_services_tab.dart';
import 'package:mywingsfinder/screens/about_page.dart';
import 'package:mywingsfinder/screens/privacy_policy_page.dart';
import 'package:mywingsfinder/screens/terms_page.dart';
import 'package:mywingsfinder/screens/eula_page.dart';
import 'package:mywingsfinder/l10n/app_localizations_simple.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flight_takeoff,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              'MyWingsFinder',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          tabs: [
            Tab(
              text: l10n.budgetFlights,
              icon: const Icon(Icons.flight),
            ),
            Tab(
              text: l10n.premiumFlights,
              icon: const Icon(Icons.flight_class),
            ),
            const Tab(
              text: 'Services',
              icon: Icon(Icons.business_center),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BudgetFlightsTab(),
          PremiumFlightsTab(),
          TravelServicesTab(),
        ],
      ),
    );
  }
  
  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.flight_takeoff, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'MyWingsFinder',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium Travel Services',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: theme.primaryColor),
                  title: Text('About Us', style: GoogleFonts.inter()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: theme.primaryColor),
                  title: Text('Privacy Policy', style: GoogleFonts.inter()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.gavel_outlined, color: theme.primaryColor),
                  title: Text('Terms of Service', style: GoogleFonts.inter()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.description_outlined, color: theme.primaryColor),
                  title: Text('EULA', style: GoogleFonts.inter()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EulaPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.language, color: theme.primaryColor),
                  title: Text('www.mywingsfinder.com', style: GoogleFonts.inter(fontSize: 14)),
                  subtitle: Text('Visit our website', style: GoogleFonts.inter(fontSize: 12)),
                ),
                ListTile(
                  leading: Icon(Icons.email, color: theme.primaryColor),
                  title: Text('support@mywingsfinder.com', style: GoogleFonts.inter(fontSize: 14)),
                  subtitle: Text('Contact support', style: GoogleFonts.inter(fontSize: 12)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '© 2024 WaSanDo（和讃堂）\nMyWingsFinder',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
