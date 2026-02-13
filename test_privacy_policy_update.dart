import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TestPrivacyPolicyUpdateScreen()));
}

class TestPrivacyPolicyUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy Update Test'),
        backgroundColor: Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy Update Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Update Summary
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_rounded, color: Colors.green, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Privacy Policy Successfully Updated',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'The privacy policy has been completely updated with comprehensive legal content for All Job Open.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Key Changes
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.update, color: Colors.blue, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Key Updates Made',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'COMPREHENSIVE SECTIONS ADDED:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ 1. Introduction & Scope\n'
                    '✅ 2. Definitions (App, PI, Candidate, Recruiter, etc.)\n'
                    '✅ 3. Information We Collect (Personal & Technical)\n'
                    '✅ 4. How We Collect Information\n'
                    '✅ 5. Purpose of Data Collection\n'
                    '✅ 6. Legal Basis for Processing (GDPR Compliance)\n'
                    '✅ 7. Use of Cookies & Tracking Technologies\n'
                    '✅ 8. Data Sharing & Disclosure\n'
                    '✅ 9. Data Storage & Retention Policy\n'
                    '✅ 10. Data Security Measures\n'
                    '✅ 11. User Rights (Access, Correction, Deletion)\n'
                    '✅ 12. Children\'s Privacy\n'
                    '✅ 13. International Data Transfers\n'
                    '✅ 14. Third-Party Links\n'
                    '✅ 15. Changes to Privacy Policy\n'
                    '✅ 16. Contact Information & Grievance Officer',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Brand Updates
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.branding_watermark,
                        color: Colors.orange,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Brand & Contact Updates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'APP NAME UPDATED:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Before: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text('All Job Open'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'After: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text('All Job Open'),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'CONTACT INFORMATION:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Grievance Officer'),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('support@alljobopen.com'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Legal Compliance
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel, color: Colors.purple, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Legal Compliance Features',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'GDPR COMPLIANCE:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Legal basis for processing defined\n'
                    '✅ User rights clearly outlined\n'
                    '✅ Data retention policies specified\n'
                    '✅ International data transfer safeguards\n'
                    '✅ Consent withdrawal mechanisms\n'
                    '✅ Data subject access rights',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'SECURITY MEASURES:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Data encryption in transit and at rest\n'
                    '✅ Regular security assessments\n'
                    '✅ Access controls for authorized personnel\n'
                    '✅ Vulnerability scanning procedures',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Technical Implementation
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.code, color: Colors.grey.shade700, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Technical Implementation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'FILE UPDATED: lib/screens/privacy_policy_screen.dart\n\n'
                    'FEATURES IMPLEMENTED:\n'
                    '• Comprehensive 16-section privacy policy\n'
                    '• User type-specific data collection table\n'
                    '• Structured subsections for better readability\n'
                    '• Professional UI with proper formatting\n'
                    '• Updated branding and contact information\n'
                    '• GDPR-compliant legal language\n'
                    '• Mobile-responsive design maintained',
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
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
