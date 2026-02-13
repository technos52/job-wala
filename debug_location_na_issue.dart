import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Debug script to investigate why location is showing "N/A, N/A"
///
/// This will help us understand:
/// 1. What data is actually stored in the job documents
/// 2. If location field exists and has data
/// 3. If there are any field name mismatches
/// 4. If there are multiple location-related fields

void main() async {
  print('🔍 DEBUGGING LOCATION N/A ISSUE');
  print('=' * 50);

  await debugLocationIssue();
}

Future<void> debugLocationIssue() async {
  print('\n📋 INVESTIGATION STEPS:');
  print('1. Check job data structure in Firestore');
  print('2. Verify location field exists and has data');
  print('3. Check for field name mismatches');
  print('4. Identify where "N/A, N/A" is coming from');

  print('\n🔧 DEBUGGING METHODS:');

  print('\n1. CHECK JOB DOCUMENT STRUCTURE:');
  print('''
// Add this to your app temporarily to debug
void debugJobData(String jobId) async {
  try {
    final jobDoc = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .get();
    
    if (jobDoc.exists) {
      final data = jobDoc.data() as Map<String, dynamic>;
      print('📄 Job Document Data:');
      data.forEach((key, value) {
        print('  \$key: \$value');
      });
      
      // Specifically check location
      print('\\n📍 Location Field Analysis:');
      print('  location: \${data['location']}');
      print('  district: \${data['district']}');
      print('  state: \${data['state']}');
      
    } else {
      print('❌ Job document not found');
    }
  } catch (e) {
    print('❌ Error fetching job data: \$e');
  }
}''');

  print('\n2. CHECK APPLICATION DATA:');
  print('''
// Add this to debug application data
void debugApplicationData(String applicationId) async {
  try {
    // Check if application has location data
    final appQuery = await FirebaseFirestore.instance
        .collectionGroup('applications')
        .where(FieldPath.documentId, isEqualTo: applicationId)
        .get();
    
    if (appQuery.docs.isNotEmpty) {
      final appData = appQuery.docs.first.data();
      print('📱 Application Data:');
      appData.forEach((key, value) {
        print('  \$key: \$value');
      });
    }
  } catch (e) {
    print('❌ Error fetching application data: \$e');
  }
}''');

  print('\n3. POSSIBLE CAUSES OF "N/A, N/A":');
  print('   a) Location field is null or empty in job document');
  print('   b) There\'s still code using district/state format somewhere');
  print('   c) Old job data doesn\'t have location field');
  print('   d) There\'s a different screen showing the location');
  print('   e) Caching issue showing old data');

  print('\n4. PLACES TO CHECK:');
  print('   ✅ lib/screens/my_applications_screen.dart (already fixed)');
  print('   ✅ lib/simple_candidate_dashboard.dart (looks correct)');
  print('   ❓ Check if there are other job detail screens');
  print('   ❓ Check if location is being saved properly');
  print('   ❓ Check for any cached/old data');

  print('\n5. VERIFICATION STEPS:');
  print('   1. Post a NEW job with location filled');
  print('   2. Apply to that NEW job');
  print('   3. Check if location shows correctly');
  print('   4. If still N/A, add debug prints to see actual data');

  print('\n🔍 QUICK FIXES TO TRY:');

  print('\n1. ADD DEBUG PRINTS TO my_applications_screen.dart:');
  print('''
// In _showJobDetailsModal method, add:
print('🔍 DEBUG: Job data keys: \${jobData.keys.toList()}');
print('🔍 DEBUG: Location value: "\${jobData['location']}"');
print('🔍 DEBUG: All job data: \$jobData');''');

  print('\n2. CHECK FOR HIDDEN CHARACTERS:');
  print('''
// Check if location has hidden characters
final location = jobData['location'];
if (location != null) {
  print('Location length: \${location.length}');
  print('Location bytes: \${location.codeUnits}');
  print('Location trimmed: "\${location.trim()}"');
}''');

  print('\n3. FALLBACK LOCATION DISPLAY:');
  print('''
// Try multiple location fields as fallback
String getLocationDisplay(Map<String, dynamic> jobData) {
  // Try different possible location fields
  final location = jobData['location'];
  final district = jobData['district'];
  final state = jobData['state'];
  final city = jobData['city'];
  final area = jobData['area'];
  
  if (location != null && location.toString().trim().isNotEmpty) {
    return location.toString().trim();
  }
  
  if (district != null && state != null) {
    return '\$district, \$state';
  }
  
  if (city != null) {
    return city.toString();
  }
  
  return 'Location not specified';
}''');

  print('\n4. CHECK JOB POSTING FORM:');
  print('   • Verify location is being saved correctly');
  print('   • Check if _locationController.text has data');
  print('   • Verify the field name in job data object');

  print('\n🎯 IMMEDIATE ACTION PLAN:');
  print('1. Add debug prints to see actual job data');
  print('2. Post a new job and test with fresh data');
  print('3. Check Firestore console to see actual data');
  print('4. Verify no caching issues');
  print('5. Check if there are other location display screens');
}

/// Widget to help debug the location issue
class LocationDebugWidget extends StatefulWidget {
  @override
  _LocationDebugWidgetState createState() => _LocationDebugWidgetState();
}

class _LocationDebugWidgetState extends State<LocationDebugWidget> {
  Map<String, dynamic>? jobData;
  String debugInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Debug Tool'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location N/A Debug Tool',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                // Simulate fetching job data
                await _debugJobData();
              },
              child: Text('Debug Job Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),

            SizedBox(height: 20),

            if (jobData != null) ...[
              Text(
                'Job Data Analysis:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Fields:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...jobData!.entries
                        .map((entry) => Text('${entry.key}: ${entry.value}'))
                        .toList(),

                    SizedBox(height: 10),
                    Text(
                      'Location Analysis:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('location: "${jobData!['location']}"'),
                    Text('district: "${jobData!['district']}"'),
                    Text('state: "${jobData!['state']}"'),

                    SizedBox(height: 10),
                    Text(
                      'Display Result:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_getLocationDisplay()),
                  ],
                ),
              ),
            ],

            if (debugInfo.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'Debug Info:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(debugInfo),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _debugJobData() async {
    // Simulate different job data scenarios
    setState(() {
      jobData = {
        'jobTitle': 'Test Job',
        'companyName': 'Test Company',
        'location': null, // This might be the issue
        'district': 'Test District',
        'state': 'Test State',
        'salaryRange': '5-8 LPA',
        'workMode': 'Hybrid',
      };

      debugInfo = 'Simulated job data loaded. Check if location is null.';
    });
  }

  String _getLocationDisplay() {
    if (jobData == null) return 'No data';

    final location = jobData!['location'];
    final district = jobData!['district'];
    final state = jobData!['state'];

    if (location != null && location.toString().trim().isNotEmpty) {
      return 'Using location: "$location"';
    }

    if (district != null && state != null) {
      return 'Using district/state: "$district, $state"';
    }

    return 'Would show: "N/A"';
  }
}
