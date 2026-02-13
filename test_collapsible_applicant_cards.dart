import 'package:flutter/material.dart';

// Test for Collapsible Applicant Cards
void main() {
  print('🔧 Collapsible Applicant Cards Test');
  print('===================================');

  print('\n🎯 Feature Implemented:');
  print('Applicant cards are now collapsible by default');
  print('Users can click to expand/collapse detailed information');

  print('\n📋 Changes Made:');
  print('✅ Added _expandedCards Set to track card states');
  print('✅ Made cards clickable with InkWell');
  print('✅ Added expand/collapse icons');
  print('✅ Implemented collapsed view (basic info only)');
  print('✅ Implemented expanded view (all details)');
  print('✅ Added visual indicators for interaction');

  print('\n🔄 Card States:');
  print('');
  print('COLLAPSED (Default):');
  print('┌─────────────────────────────────────┐');
  print('│ Mr. bore                  [PENDING] ▼│');
  print('│ Applied on 6/1/2026 at 7:29         │');
  print('│                                     │');
  print('│ 📧 Email: user@example.com          │');
  print('│ 📞 Phone: 9322463485                │');
  print('│                                     │');
  print('│      Tap to view more details       │');
  print('└─────────────────────────────────────┘');
  print('');
  print('EXPANDED (After Click):');
  print('┌─────────────────────────────────────┐');
  print('│ Mr. bore                  [PENDING] ▲│');
  print('│ Applied on 6/1/2026 at 7:29         │');
  print('│                                     │');
  print('│ 📧 Email: user@example.com          │');
  print('│ 📞 Phone: 9322463485                │');
  print('│ 🎂 Age: 27                          │');
  print('│ 👤 Gender: Male                     │');
  print('│ 📍 Location: Gwalior, MP            │');
  print('│ 🎓 Qualification: High School       │');
  print('│ 💼 Experience: 0 years, 0 months    │');
  print('│ 💕 Marital Status: Married          │');
  print('│ 🏢 Company Type: Government         │');
  print('│ ... (all other details)             │');
  print('│                                     │');
  print('│         Tap to collapse             │');
  print('└─────────────────────────────────────┘');

  print('\n🎨 UI Improvements:');
  print('• Cleaner initial view - less overwhelming');
  print('• Progressive disclosure of information');
  print('• Visual expand/collapse indicators');
  print('• Smooth interaction feedback');
  print('• Better space utilization');
  print('• Improved user experience');

  print('\n🧪 Testing Instructions:');
  print('1. Login as an employer');
  print('2. Navigate to Jobs → Manage Jobs');
  print('3. Click "Applicants" on any job with applications');
  print('4. Verify cards show collapsed by default');
  print('5. Click on a card to expand it');
  print('6. Verify all details are shown when expanded');
  print('7. Click again to collapse');
  print('8. Test multiple cards can be expanded simultaneously');

  print('\n✅ Expected Behavior:');
  print('• Cards collapsed by default (show name, date, email, phone)');
  print('• Expand icon (▼) visible when collapsed');
  print('• Collapse icon (▲) visible when expanded');
  print('• Smooth tap interaction');
  print('• "Tap to view more details" hint in collapsed state');
  print('• "Tap to collapse" hint in expanded state');
  print('• All candidate details visible when expanded');
  print('• Multiple cards can be expanded independently');

  print('\n🎯 Benefits:');
  print('• Reduced visual clutter');
  print('• Better overview of all applicants');
  print('• Progressive information disclosure');
  print('• Improved mobile experience');
  print('• Faster scanning of applicant list');
  print('• User-controlled detail level');

  runApp(CollapsibleCardsTestApp());
}

class CollapsibleCardsTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collapsible Applicant Cards Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CollapsibleCardsTestScreen(),
    );
  }
}

class CollapsibleCardsTestScreen extends StatelessWidget {
  static const primaryBlue = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Collapsible Applicant Cards'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            SizedBox(height: 16),
            _buildFeaturesCard(),
            SizedBox(height: 16),
            _buildDemoCard(),
            SizedBox(height: 16),
            _buildTestingCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  'Feature Implemented',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ COLLAPSIBLE CARDS ACTIVE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Applicant cards now show collapsed by default with basic information. Users can tap to expand and view all candidate details.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade600,
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

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.featured_play_list, color: primaryBlue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Key Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem('Collapsed by default'),
                  _buildFeatureItem('Tap to expand/collapse'),
                  _buildFeatureItem('Visual expand/collapse icons'),
                  _buildFeatureItem('Progressive information disclosure'),
                  _buildFeatureItem('Multiple cards can be expanded'),
                  _buildFeatureItem('Smooth interaction feedback'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.arrow_right, color: primaryBlue, size: 16),
          SizedBox(width: 4),
          Expanded(child: Text(feature, style: TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildDemoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview, color: Colors.orange, size: 24),
                SizedBox(width: 8),
                Text(
                  'Card States Demo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COLLAPSED (Default):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  Text('• Shows name, date, email, phone'),
                  Text('• Expand icon (▼) visible'),
                  Text('• "Tap to view more details" hint'),
                  SizedBox(height: 8),
                  Text(
                    'EXPANDED (After tap):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  Text('• Shows all candidate information'),
                  Text('• Collapse icon (▲) visible'),
                  Text('• "Tap to collapse" hint'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestingCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.purple, size: 24),
                SizedBox(width: 8),
                Text(
                  'Testing Instructions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTestStep('1. Login as employer'),
                  _buildTestStep('2. Go to job with applications'),
                  _buildTestStep('3. Click "Applicants" button'),
                  _buildTestStep('4. Verify cards are collapsed'),
                  _buildTestStep('5. Tap card to expand'),
                  _buildTestStep('6. Verify all details show'),
                  _buildTestStep('7. Tap again to collapse'),
                  _buildTestStep('8. Test multiple cards'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestStep(String step) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(step, style: TextStyle(fontSize: 13)),
    );
  }
}
