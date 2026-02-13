import 'package:flutter/material.dart';
import 'lib/screens/terms_conditions_screen.dart';
import 'lib/screens/privacy_policy_screen.dart';

void main() {
  runApp(const TestNativeTermsPrivacyApp());
}

class TestNativeTermsPrivacyApp extends StatelessWidget {
  const TestNativeTermsPrivacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Terms & Privacy Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Terms & Privacy Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Test Native Text Implementation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.description),
              label: const Text('Terms & Conditions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.privacy_tip),
              label: const Text('Privacy Policy'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF0EA5E9)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF0EA5E9), size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Native Implementation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No more webview dependency!\nFaster loading, better performance',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF0369A1)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
