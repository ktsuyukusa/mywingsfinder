import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
                  Icon(Icons.gavel, color: theme.primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of Service',
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
            
            _buildSection('1. Acceptance of Terms', [
              'By accessing and using MyWingsFinder ("Service"), you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, you may not use our Service.',
              '',
              'These terms apply to all users, including business travelers, corporate clients, and individual consumers.',
            ], theme),
            
            _buildSection('2. Description of Service', [
              'MyWingsFinder is a premium travel platform that provides:',
              '• Flight search and comparison services',
              '• Luxury hotel booking assistance',
              '• VIP ground transportation arrangements',
              '• Travel insurance options',
              '• Private jet charter information',
              '',
              'We facilitate connections between travelers and travel service providers but do not directly provide transportation or accommodation services.',
            ], theme),
            
            _buildSection('3. User Accounts and Registration', [
              'To access certain features, you may need to create an account. You agree to:',
              '• Provide accurate and complete registration information',
              '• Maintain the confidentiality of your account credentials',
              '• Update your information when necessary',
              '• Notify us immediately of unauthorized account use',
              '• Accept responsibility for all activities under your account',
            ], theme),
            
            _buildSection('4. Booking and Payment Terms', [
              'When making bookings through our affiliated partners:',
              '• Prices are subject to change until booking confirmation',
              '• Payment is processed by third-party providers (Expedia, airlines, hotels)',
              '• Booking confirmations are subject to partner availability',
              '• Cancellation and refund policies are determined by service providers',
              '• MyWingsFinder acts as an intermediary and is not responsible for service delivery',
            ], theme),
            
            _buildSection('5. Affiliate Relationships', [
              'MyWingsFinder participates in affiliate programs with:',
              '• Expedia Partner Solutions',
              '• Various airlines and travel providers',
              '• Ground transportation companies',
              '• Insurance providers',
              '',
              'We may receive commissions from completed bookings, which helps us provide free search services to users.',
            ], theme),
            
            _buildSection('6. User Conduct', [
              'You agree not to:',
              '• Use the Service for illegal or unauthorized purposes',
              '• Interfere with or disrupt the Service or servers',
              '• Attempt to gain unauthorized access to any part of the Service',
              '• Use automated systems to access the Service without permission',
              '• Provide false or misleading information',
              '• Violate any applicable laws or regulations',
            ], theme),
            
            _buildSection('7. Intellectual Property', [
              'MyWingsFinder and its content are protected by intellectual property laws. You may not:',
              '• Reproduce, distribute, or create derivative works',
              '• Use our trademarks or branding without permission',
              '• Reverse engineer or decompile any part of the Service',
              '• Remove or alter copyright notices',
              '',
              'All rights not expressly granted are reserved by WaSanDo（和讃堂）.',
            ], theme),
            
            _buildSection('8. Privacy and Data Protection', [
              'Your privacy is important to us. Our Privacy Policy explains:',
              '• What information we collect and why',
              '• How we use and protect your data',
              '• Your rights regarding personal information',
              '• How to contact us about privacy concerns',
              '',
              'By using our Service, you consent to data processing as described in our Privacy Policy.',
            ], theme),
            
            _buildSection('9. Disclaimers and Limitations', [
              'MyWingsFinder provides the Service "as is" without warranties of any kind. We disclaim:',
              '• Accuracy of flight schedules, prices, or availability',
              '• Quality of services provided by third-party partners',
              '• Uninterrupted or error-free service operation',
              '• Fitness for any particular purpose',
              '',
              'We are not liable for indirect, incidental, or consequential damages.',
            ], theme),
            
            _buildSection('10. Third-Party Services', [
              'Our Service integrates with third-party providers who have their own terms:',
              '• Airlines and their booking policies',
              '• Hotel chains and accommodation providers',
              '• Ground transportation companies',
              '• Payment processors and financial institutions',
              '',
              'You are subject to these third-party terms when using their services.',
            ], theme),
            
            _buildSection('11. Force Majeure', [
              'MyWingsFinder is not liable for delays or failures caused by:',
              '• Natural disasters or extreme weather',
              '• Government regulations or travel restrictions',
              '• Pandemics or public health emergencies',
              '• Strikes, labor disputes, or supplier issues',
              '• Technical failures beyond our control',
            ], theme),
            
            _buildSection('12. Termination', [
              'We may terminate or suspend your access if you:',
              '• Violate these Terms of Service',
              '• Engage in fraudulent or illegal activities',
              '• Abuse or misuse the Service',
              '',
              'You may terminate your account at any time by contacting support.',
            ], theme),
            
            _buildSection('13. Governing Law', [
              'These Terms are governed by the laws of Japan. Any disputes will be resolved in the courts of Nagano Prefecture, Japan.',
              '',
              'If you are a consumer in the European Union, you may also have rights under local consumer protection laws.',
            ], theme),
            
            _buildSection('14. Changes to Terms', [
              'We may update these Terms periodically. Significant changes will be communicated through:',
              '• In-app notifications',
              '• Email to registered users',
              '• Updates to our website',
              '',
              'Continued use after changes constitutes acceptance of new terms.',
            ], theme),
            
            _buildSection('15. Contact Information', [
              'For questions about these Terms of Service:',
              '',
              'WaSanDo（和讃堂）',
              '1499-28 Kosato, Ueda, Nagano, 386-0005 Japan',
              'Email: support@mywingsfinder.com',
              'WhatsApp: +81 70 3782 2505',
              'Website: www.mywingsfinder.com',
              '',
              'Business hours: Monday-Friday, 9:00-17:00 JST',
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
                'These Terms of Service constitute the entire agreement between you and MyWingsFinder regarding use of the Service.',
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
