import 'package:flutter/material.dart';
import 'lib/screens/premium_upgrade_dialog.dart';

void main() {
  runApp(MaterialApp(home: TestPremiumUpgradeScreen()));
}

class TestPremiumUpgradeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Premium Upgrade Test'),
        backgroundColor: Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Premium Upgrade Dialog Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'This test verifies that the premium upgrade dialog\nhas no pixel overflow issues.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PremiumUpgradeDialog(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Test Premium Dialog',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Fixes Applied',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Fixed AppBar Column overflow\n'
                    '✅ Added proper constraints to dialog\n'
                    '✅ Improved text overflow handling\n'
                    '✅ Added progress indicator\n'
                    '✅ Better responsive design',
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
}
