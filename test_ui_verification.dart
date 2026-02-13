import 'package:flutter/material.dart';

void main() {
  runApp(const UIVerificationApp());
}

class UIVerificationApp extends StatelessWidget {
  const UIVerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Verification Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const UIVerificationScreen(),
    );
  }
}

class UIVerificationScreen extends StatefulWidget {
  const UIVerificationScreen({super.key});

  @override
  State<UIVerificationScreen> createState() => _UIVerificationScreenState();
}

class _UIVerificationScreenState extends State<UIVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile UI Verification'),
        backgroundColor: Colors.blue.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Profile Form UI Changes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'If changes are not reflecting in the UI, try these steps:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            _buildStep(
              '1. Hot Restart',
              'Press Ctrl+Shift+F5 or cmd+shift+F5 to perform a hot restart',
            ),
            _buildStep(
              '2. Clean Build',
              'Run "flutter clean" then "flutter pub get"',
            ),
            _buildStep(
              '3. Full Rebuild',
              'Stop the app completely and restart it',
            ),
            _buildStep(
              '4. Check Navigation',
              'Ensure you\'re navigating to the updated CompanyProfileScreen',
            ),

            const SizedBox(height: 20),

            const Text(
              'Expected Changes in Company Profile:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            _buildFeature('✓ Mobile number field with digit-only input'),
            _buildFeature('✓ Industry dropdown with overlay selection'),
            _buildFeature('✓ State dropdown with proper styling'),
            _buildFeature('✓ District dropdown dependent on state'),
            _buildFeature('✓ All fields match registration form style'),
            _buildFeature('✓ Proper validation messages'),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Troubleshooting:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• If UI changes don\'t appear, the app might be using cached widgets\n'
                    '• Try hot restart instead of hot reload\n'
                    '• Check if you\'re on the correct screen/route\n'
                    '• Verify no compilation errors in the console',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(feature, style: const TextStyle(fontSize: 14)),
    );
  }
}
