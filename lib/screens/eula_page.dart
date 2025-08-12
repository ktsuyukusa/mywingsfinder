import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EulaPage extends StatelessWidget {
  const EulaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'End User License Agreement',
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
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: theme.primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End User License Agreement',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          'MyWingsFinder Mobile Application',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w500,
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
            
            _buildSection('1. License Grant', [
              'WaSanDo（和讃堂）grants you a limited, non-exclusive, non-transferable license to:',
              '• Download and install MyWingsFinder on your devices',
              '• Use the application for personal or business travel purposes',
              '• Access our travel search and booking services',
              '',
              'This license is contingent upon your compliance with this Agreement.',
            ], theme),
            
            _buildSection('2. Permitted Uses', [
              'You may use MyWingsFinder to:',
              '• Search for flights between Japan and Europe',
              '• Compare prices and travel options',
              '• Access luxury hotel and transfer services',
              '• Obtain travel insurance information',
              '• Research private jet options',
              '• Make bookings through our affiliate partners',
            ], theme),
            
            _buildSection('3. Restrictions', [
              'You may NOT:',
              '• Reverse engineer, decompile, or disassemble the application',
              '• Create derivative works or modifications',
              '• Distribute, sell, lease, or sublicense the application',
              '• Remove or alter proprietary notices or labels',
              '• Use the application for commercial resale purposes',
              '• Extract or reuse data for competing services',
              '• Circumvent security or authentication measures',
            ], theme),
            
            _buildSection('4. Intellectual Property Rights', [
              'MyWingsFinder and all related intellectual property are owned by WaSanDo（和讃堂）:',
              '• Application source code and architecture',
              '• User interface design and graphics',
              '• Trademarks, logos, and branding',
              '• Database structures and algorithms',
              '• Content and documentation',
              '',
              'No ownership rights are transferred to you under this license.',
            ], theme),
            
            _buildSection('5. Data and Privacy', [
              'Your use of MyWingsFinder involves data processing:',
              '• Personal information for account management',
              '• Search and booking history for service improvement',
              '• Device and usage analytics for optimization',
              '• Location data for relevant travel options',
              '',
              'Data handling is governed by our Privacy Policy, which is incorporated by reference.',
            ], theme),
            
            _buildSection('6. Third-Party Components', [
              'MyWingsFinder includes third-party software components:',
              '• Flutter framework (Google)',
              '• Google Fonts and Material Design',
              '• Various open-source packages',
              '• Integration APIs from travel partners',
              '',
              'These components are subject to their respective licenses.',
            ], theme),
            
            _buildSection('7. Updates and Modifications', [
              'We may provide updates to MyWingsFinder that:',
              '• Add new features or functionality',
              '• Fix bugs or security vulnerabilities',
              '• Improve performance or user experience',
              '• Update third-party integrations',
              '',
              'Updates may be delivered automatically through app stores or require manual installation.',
            ], theme),
            
            _buildSection('8. Termination', [
              'This license terminates automatically if you:',
              '• Violate any terms of this Agreement',
              '• Fail to comply with applicable laws',
              '• Engage in prohibited activities',
              '',
              'Upon termination, you must cease using and delete all copies of MyWingsFinder.',
            ], theme),
            
            _buildSection('9. Disclaimer of Warranties', [
              'MyWingsFinder is provided "AS IS" without warranties:',
              '• No guarantee of uninterrupted or error-free operation',
              '• No warranty regarding data accuracy or completeness',
              '• No assurance of compatibility with all devices',
              '• No guarantee of third-party service availability',
              '',
              'Your use is at your own risk.',
            ], theme),
            
            _buildSection('10. Limitation of Liability', [
              'WaSanDo（和讃堂）\'s liability is limited to the maximum extent permitted by law:',
              '• No liability for indirect, incidental, or consequential damages',
              '• No responsibility for third-party service failures',
              '• No liability for data loss or corruption',
              '• Total liability limited to fees paid (if any)',
            ], theme),
            
            _buildSection('11. Export Compliance', [
              'You acknowledge that MyWingsFinder may be subject to export control laws:',
              '• You will not export or re-export to prohibited countries',
              '• You will comply with applicable export regulations',
              '• You are not located in an embargoed jurisdiction',
              '• You are not on any government restricted party list',
            ], theme),
            
            _buildSection('12. Support and Maintenance', [
              'WaSanDo（和讃堂）may provide support services:',
              '• Technical assistance via email and WhatsApp',
              '• Documentation and user guides',
              '• Bug fixes and security updates',
              '',
              'Support is provided on a best-effort basis and may be discontinued.',
            ], theme),
            
            _buildSection('13. Governing Law', [
              'This Agreement is governed by Japanese law:',
              '• Disputes will be resolved in Nagano Prefecture courts',
              '• Japanese law applies to interpretation and enforcement',
              '• Consumer protection laws may provide additional rights',
            ], theme),
            
            _buildSection('14. Contact Information', [
              'For questions about this EULA:',
              '',
              'WaSanDo（和讃堂）',
              '1499-28 Kosato, Ueda, Nagano, 386-0005 Japan',
              'Email: support@mywingsfinder.com',
              'WhatsApp: +81 70 3782 2505',
              'Website: www.mywingsfinder.com',
              '',
              'Legal Representative: Kazuyoshi Tsuyukusa 露草和賛',
            ], theme),
            
            const SizedBox(height: 32),
            
            // Acceptance Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: theme.primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Agreement Acceptance',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'By installing, accessing, or using MyWingsFinder, you acknowledge that you have read, understood, and agree to be bound by this End User License Agreement.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color,
                      height: 1.5,
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
