import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.privacy_tip, color: theme.primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          'Last updated: ${DateTime.now().year}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSection('1. Information We Collect', [
              'We collect information you provide directly to us when using MyWingsFinder services:',
              '• Personal information (name, email, phone number)',
              '• Travel preferences and search history',
              '• Booking information and payment details (processed securely by third parties)',
              '• Device information and usage analytics',
              '• Location data (with your permission) to provide relevant flight options',
            ], theme),
            
            _buildSection('2. How We Use Your Information', [
              'We use the information we collect to:',
              '• Provide and improve our travel search services',
              '• Process bookings and facilitate transactions with travel partners',
              '• Send you booking confirmations and travel updates',
              '• Personalize your experience and show relevant travel options',
              '• Comply with legal obligations and prevent fraud',
              '• Communicate about service updates and promotional offers (with consent)',
            ], theme),
            
            _buildSection('3. Information Sharing and Disclosure', [
              'We may share your information with:',
              '• Travel partners (airlines, hotels, transfer services) to process bookings',
              '• Affiliate partners (Expedia, Blacklane, etc.) for service fulfillment',
              '• Service providers who assist our operations (analytics, customer support)',
              '• Legal authorities when required by law or to protect our rights',
              '',
              'We do not sell your personal information to third parties.',
            ], theme),
            
            _buildSection('4. Data Security', [
              'We implement appropriate security measures to protect your information:',
              '• Encryption of sensitive data in transit and at rest',
              '• Secure data centers and regular security audits',
              '• Limited access to personal information on a need-to-know basis',
              '• Regular security training for our employees',
              '',
              'However, no method of transmission over the internet is 100% secure.',
            ], theme),
            
            _buildSection('5. Data Retention', [
              'We retain your information for as long as:',
              '• Your account remains active',
              '• Required to provide our services',
              '• Necessary to comply with legal obligations',
              '• Required for legitimate business purposes',
              '',
              'You may request deletion of your account and personal data at any time.',
            ], theme),
            
            _buildSection('6. Your Rights', [
              'You have the right to:',
              '• Access and review your personal information',
              '• Correct inaccurate or incomplete data',
              '• Delete your account and personal information',
              '• Object to processing of your personal information',
              '• Withdraw consent for marketing communications',
              '• Data portability (receive a copy of your data)',
            ], theme),
            
            _buildSection('7. International Data Transfers', [
              'MyWingsFinder is based in Japan. Your information may be transferred to and processed in:',
              '• Japan (our primary operations)',
              '• Europe (for European travel services)',
              '• United States (for certain technology services)',
              '',
              'We ensure appropriate safeguards are in place for international transfers.',
            ], theme),
            
            _buildSection('8. Cookies and Tracking', [
              'We use cookies and similar technologies to:',
              '• Remember your preferences and settings',
              '• Analyze website usage and improve our services',
              '• Provide personalized content and advertisements',
              '• Enable social media features and affiliate tracking',
              '',
              'You can control cookies through your browser settings.',
            ], theme),
            
            _buildSection('9. Third-Party Services', [
              'Our app integrates with third-party services including:',
              '• Expedia (flight and hotel bookings)',
              '• Blacklane (ground transportation)',
              '• Insurance providers (travel protection)',
              '• Payment processors (secure transactions)',
              '',
              'These services have their own privacy policies governing data use.',
            ], theme),
            
            _buildSection('10. Children\'s Privacy', [
              'MyWingsFinder is designed for business travelers and is not intended for children under 16. We do not knowingly collect personal information from children under 16.',
            ], theme),
            
            _buildSection('11. Changes to Privacy Policy', [
              'We may update this Privacy Policy periodically. We will notify you of significant changes by:',
              '• Posting the updated policy in our app',
              '• Sending email notifications to registered users',
              '• Updating the "Last updated" date at the top of this policy',
            ], theme),
            
            _buildSection('12. Contact Information', [
              'If you have questions about this Privacy Policy or our data practices, contact us:',
              '',
              'WaSanDo（和讃堂）',
              '1499-28 Kosato, Ueda, Nagano, 386-0005 Japan',
              'Email: support@mywingsfinder.com',
              'WhatsApp: +81 70 3782 2505',
              '',
              'Data Protection Officer: Kazuyoshi Tsuyukusa',
            ], theme),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'This Privacy Policy is effective as of the date stated above and applies to all information collected by MyWingsFinder.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.textTheme.bodySmall?.color,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, List<String> content, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((text) {
                if (text.isEmpty) return const SizedBox(height: 8);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}