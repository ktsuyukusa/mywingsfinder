import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flight, size: 32, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'MyWingsFinder',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Premium Travel Services for Business Leaders',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Company Name Section
            _buildSection(
              'Company Information',
              [
                _buildInfoRow('Company Name', 'WaSanDo（和讃堂）'),
                _buildInfoRow('Service Brand', 'MyWingsFinder'),
                _buildInfoRow('Founded', '2024'),
                _buildInfoRow('Industry', 'Premium Travel Services'),
              ],
              theme,
            ),
            
            const SizedBox(height: 24),
            
            // Mission Section
            _buildSection(
              'Our Mission',
              [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Text(
                    'At MyWingsFinder, we specialize in providing comprehensive premium travel solutions for CEOs and business leaders traveling between Japan and Europe. Our platform offers curated flight options, luxury accommodations, VIP ground transfers, travel protection, and private aviation services.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.6,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
              theme,
            ),
            
            const SizedBox(height: 24),
            
            // Services Section
            _buildSection(
              'Our Services',
              [
                _buildServiceCard('✈️ Flight Search', 'Premium flights from Japan to Europe', theme),
                _buildServiceCard('🏨 Luxury Hotels', 'Curated accommodations for business travelers', theme),
                _buildServiceCard('🚗 VIP Transfers', 'Professional chauffeur services', theme),
                _buildServiceCard('🛡️ Travel Insurance', 'Comprehensive travel protection', theme),
                _buildServiceCard('🛩️ Private Jets', 'Exclusive private aviation options', theme),
              ],
              theme,
            ),
            
            const SizedBox(height: 24),
            
            // Contact Information
            _buildSection(
              'Contact Information',
              [
                _buildContactRow(Icons.location_on, 'Address', 
                    '1499-28 Kosato, Ueda, Nagano, 386-0005 Japan', theme),
                _buildContactRow(Icons.phone, 'WhatsApp', '+81 70 3782 2505', theme),
                _buildContactRow(Icons.email, 'Support', 'support@mywingsfinder.com', theme),
                _buildContactRow(Icons.language, 'Website', 'www.mywingsfinder.com', theme),
                _buildContactRow(Icons.person, 'CEO', 'Kazuyoshi Tsuyukusa 露草和賛', theme),
              ],
              theme,
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright, size: 16, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 8),
                  Text(
                    '2024 WaSanDo（和讃堂）- MyWingsFinder. All rights reserved.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServiceCard(String title, String description, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactRow(IconData icon, String label, String value, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}