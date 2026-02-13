import 'package:flutter/material.dart';
import 'lib/services/dropdown_service.dart';
import 'lib/dropdown_options/dropdown_options.dart';
import 'lib/dropdown_options/qualification.dart';

void main() {
  runApp(const QualificationDebugApp());
}

class QualificationDebugApp extends StatelessWidget {
  const QualificationDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qualification Firebase Debug',
      home: const QualificationDebugScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QualificationDebugScreen extends StatefulWidget {
  const QualificationDebugScreen({super.key});

  @override
  State<QualificationDebugScreen> createState() =>
      _QualificationDebugScreenState();
}

class _QualificationDebugScreenState extends State<QualificationDebugScreen> {
  List<String> _localQualifications = [];
  List<String> _firebaseQualifications = [];
  List<String> _serviceQualifications = [];
  bool _isLoading = false;
  String _status = 'Ready to test';
  Map<String, dynamic> _debugInfo = {};

  @override
  void initState() {
    super.initState();
    _testQualifications();
  }

  Future<void> _testQualifications() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing qualification sources...';
    });

    try {
      // Test 1: Local qualifications
      print('=== Testing Local Qualifications ===');
      _localQualifications = QualificationOptions.values;
      print('✅ Local qualifications: ${_localQualifications.length} items');
      print('Local items: $_localQualifications');

      // Test 2: Firebase qualifications through service
      print('\n=== Testing Firebase Qualifications ===');
      _serviceQualifications = await DropdownService.getDropdownOptions(
        'qualifications',
      );
      print('✅ Service qualifications: ${_serviceQualifications.length} items');
      print('Service items: $_serviceQualifications');

      // Test 3: Direct Firebase check
      print('\n=== Testing Direct Firebase Access ===');
      try {
        final allOptions = await DropdownService.getAllDropdownOptions();
        if (allOptions.containsKey('qualifications')) {
          _firebaseQualifications = allOptions['qualifications'] ?? [];
          print(
            '✅ Direct Firebase qualifications: ${_firebaseQualifications.length} items',
          );
          print('Firebase items: $_firebaseQualifications');
        } else {
          print('⚠️ No qualifications key in Firebase options');
          print('Available keys: ${allOptions.keys.toList()}');
        }

        _debugInfo = {
          'allFirebaseKeys': allOptions.keys.toList(),
          'firebaseQualificationsExists': allOptions.containsKey(
            'qualifications',
          ),
          'firebaseQualificationsCount': _firebaseQualifications.length,
        };
      } catch (e) {
        print('❌ Error accessing Firebase directly: $e');
        _debugInfo['firebaseError'] = e.toString();
      }

      // Test 4: Compare sources
      print('\n=== Comparison ===');
      print('Local count: ${_localQualifications.length}');
      print('Service count: ${_serviceQualifications.length}');
      print('Firebase count: ${_firebaseQualifications.length}');

      final areServiceAndLocalSame =
          _serviceQualifications.length == _localQualifications.length &&
          _serviceQualifications.every(
            (item) => _localQualifications.contains(item),
          );

      final areServiceAndFirebaseSame =
          _firebaseQualifications.isNotEmpty &&
          _serviceQualifications.length == _firebaseQualifications.length &&
          _serviceQualifications.every(
            (item) => _firebaseQualifications.contains(item),
          );

      print('Service using local: $areServiceAndLocalSame');
      print('Service using Firebase: $areServiceAndFirebaseSame');

      setState(() {
        _isLoading = false;
        if (areServiceAndFirebaseSame) {
          _status = '✅ Service is using Firebase qualifications!';
        } else if (areServiceAndLocalSame) {
          _status =
              '⚠️ Service is using local qualifications (Firebase may be empty)';
        } else {
          _status = '❌ Service using unknown source';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
      print('❌ Error testing qualifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qualification Firebase Debug'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isLoading
                    ? Colors.orange[100]
                    : _status.contains('✅')
                    ? Colors.green[100]
                    : _status.contains('⚠️')
                    ? Colors.orange[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isLoading
                      ? Colors.orange
                      : _status.contains('✅')
                      ? Colors.green
                      : _status.contains('⚠️')
                      ? Colors.orange
                      : Colors.red,
                ),
              ),
              child: Text(
                _status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isLoading
                      ? Colors.orange[800]
                      : _status.contains('✅')
                      ? Colors.green[800]
                      : _status.contains('⚠️')
                      ? Colors.orange[800]
                      : Colors.red[800],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Results
            if (!_isLoading)
              Expanded(
                child: ListView(
                  children: [
                    _buildSourceCard(
                      'Local Qualifications',
                      _localQualifications,
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildSourceCard(
                      'Service Qualifications',
                      _serviceQualifications,
                      Colors.green,
                    ),
                    const SizedBox(height: 16),
                    _buildSourceCard(
                      'Firebase Qualifications',
                      _firebaseQualifications,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),

                    // Debug info
                    if (_debugInfo.isNotEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Debug Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._debugInfo.entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text('${entry.key}: ${entry.value}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Refresh button
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _testQualifications,
                child: const Text('Refresh Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceCard(String title, List<String> items, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, color: color),
                const SizedBox(width: 8),
                Text(
                  '$title (${items.length} items)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text(
                'No items found',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .take(5)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text('• $item'),
                      ),
                    )
                    .toList(),
              ),
            if (items.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '... and ${items.length - 5} more items',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
