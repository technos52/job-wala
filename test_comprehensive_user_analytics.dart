import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const UserAnalyticsTestApp());
}

class UserAnalyticsTestApp extends StatelessWidget {
  const UserAnalyticsTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Analytics System Test',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const UserAnalyticsTestScreen(),
    );
  }
}

class UserAnalyticsTestScreen extends StatefulWidget {
  const UserAnalyticsTestScreen({super.key});

  @override
  State<UserAnalyticsTestScreen> createState() =>
      _UserAnalyticsTestScreenState();
}

class _UserAnalyticsTestScreenState extends State<UserAnalyticsTestScreen> {
  Map<String, dynamic>? _userAnalytics;
  bool _isLoading = false;
  String _testUserId = 'test_user_123';

  @override
  void initState() {
    super.initState();
    _loadUserAnalytics();
  }

  Future<void> _loadUserAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(_testUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userAnalytics = userDoc.data();
          _isLoading = false;
        });
      } else {
        // Create sample user data for testing
        await _createSampleUserData();
      }
    } catch (e) {
      print('Error loading user analytics: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createSampleUserData() async {
    final sampleUserData = {
      'fullName': 'John Doe',
      'email': 'john.doe@example.com',
      'mobileNumber': '+1234567890',
      'gender': 'male',
      'age': 28,
      'qualification': 'Bachelor of Engineering',
      'experienceYears': 3,
      'experienceMonths': 6,
      'district': 'Bangalore',
      'state': 'Karnataka',

      // Application Analytics Fields
      'totalApplications': 15,
      'recentApplications': [
        {
          'applicationId': 'app_001',
          'jobTitle': 'Software Engineer',
          'companyName': 'Tech Corp',
          'jobCategory': 'IT/Software',
          'industryType': 'Technology',
          'location': 'Bangalore',
          'salaryRange': '8-12 LPA',
          'appliedAt': DateTime.now().subtract(const Duration(days: 1)),
          'status': 'pending',
          'experienceMatch': 'qualified',
          'locationMatch': 'exact_match',
        },
        {
          'applicationId': 'app_002',
          'jobTitle': 'Full Stack Developer',
          'companyName': 'StartupXYZ',
          'jobCategory': 'IT/Software',
          'industryType': 'Technology',
          'location': 'Hyderabad',
          'salaryRange': '10-15 LPA',
          'appliedAt': DateTime.now().subtract(const Duration(days: 3)),
          'status': 'accepted',
          'experienceMatch': 'qualified',
          'locationMatch': 'state_match',
        },
        {
          'applicationId': 'app_003',
          'jobTitle': 'Data Analyst',
          'companyName': 'Analytics Inc',
          'jobCategory': 'Analytics',
          'industryType': 'Finance',
          'location': 'Mumbai',
          'salaryRange': '6-10 LPA',
          'appliedAt': DateTime.now().subtract(const Duration(days: 5)),
          'status': 'rejected',
          'experienceMatch': 'nearly_qualified',
          'locationMatch': 'no_match',
        },
      ],

      'monthlyApplications': {'2026_01': 8, '2025_12': 4, '2025_11': 3},

      'jobCategoryPreferences': {
        'IT/Software': 10,
        'Analytics': 3,
        'Marketing': 2,
      },

      'industryPreferences': {'Technology': 12, 'Finance': 2, 'Healthcare': 1},

      'locationPreferences': {'Bangalore': 8, 'Hyderabad': 4, 'Mumbai': 3},

      'salaryPreferences': {'8-12 LPA': 6, '10-15 LPA': 5, '6-10 LPA': 4},

      'applicationActivity': {
        'lastApplicationDate': DateTime.now().subtract(const Duration(days: 1)),
        'applicationsThisWeek': 2,
        'applicationsThisMonth': 8,
        'averageApplicationsPerMonth': 5.0,
        'mostActiveDay': 2, // Tuesday
        'preferredApplicationTime': 14, // 2 PM
      },

      'applicationSuccessMetrics': {
        'totalApplications': 15,
        'pendingApplications': 8,
        'acceptedApplications': 4,
        'rejectedApplications': 3,
        'applicationSuccessRate': 57.14, // 4/(4+3) * 100
      },

      'analyticsLastUpdated': FieldValue.serverTimestamp(),
      'applicationAnalyticsVersion': '1.0',
    };

    await FirebaseFirestore.instance
        .collection('candidates')
        .doc(_testUserId)
        .set(sampleUserData);

    setState(() {
      _userAnalytics = sampleUserData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Analytics Dashboard'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userAnalytics == null
          ? const Center(child: Text('No analytics data found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoCard(),
                  const SizedBox(height: 16),
                  _buildApplicationStatsCard(),
                  const SizedBox(height: 16),
                  _buildRecentApplicationsCard(),
                  const SizedBox(height: 16),
                  _buildPreferencesCard(),
                  const SizedBox(height: 16),
                  _buildActivityMetricsCard(),
                  const SizedBox(height: 16),
                  _buildSuccessMetricsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Name', _userAnalytics!['fullName'] ?? 'N/A'),
            _buildInfoRow('Email', _userAnalytics!['email'] ?? 'N/A'),
            _buildInfoRow(
              'Experience',
              '${_userAnalytics!['experienceYears'] ?? 0} years, ${_userAnalytics!['experienceMonths'] ?? 0} months',
            ),
            _buildInfoRow(
              'Location',
              '${_userAnalytics!['district'] ?? ''}, ${_userAnalytics!['state'] ?? ''}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationStatsCard() {
    final totalApps = _userAnalytics!['totalApplications'] ?? 0;
    final monthlyApps =
        _userAnalytics!['monthlyApplications'] as Map<String, dynamic>? ?? {};
    final currentMonth =
        '${DateTime.now().year}_${DateTime.now().month.toString().padLeft(2, '0')}';
    final thisMonthApps = monthlyApps[currentMonth] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Statistics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Applications',
                    totalApps.toString(),
                    Icons.work,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    thisMonthApps.toString(),
                    Icons.calendar_month,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Monthly Breakdown:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...monthlyApps.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatMonthKey(entry.key)),
                    Text('${entry.value} applications'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentApplicationsCard() {
    final recentApps =
        _userAnalytics!['recentApplications'] as List<dynamic>? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Applications',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 12),
            if (recentApps.isEmpty)
              const Text('No recent applications')
            else
              ...recentApps.take(5).map((app) => _buildApplicationTile(app)),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationTile(Map<String, dynamic> app) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.hourglass_empty;

    switch (app['status']) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  app['jobTitle'] ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 4),
              Text(
                app['status']?.toString().toUpperCase() ?? 'N/A',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${app['companyName']} • ${app['location']}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Experience: ${app['experienceMatch']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              Text(
                'Location: ${app['locationMatch']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    final jobCategoryPrefs =
        _userAnalytics!['jobCategoryPreferences'] as Map<String, dynamic>? ??
        {};
    final industryPrefs =
        _userAnalytics!['industryPreferences'] as Map<String, dynamic>? ?? {};
    final locationPrefs =
        _userAnalytics!['locationPreferences'] as Map<String, dynamic>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Preferences',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 12),
            _buildPreferenceSection('Job Categories', jobCategoryPrefs),
            const SizedBox(height: 12),
            _buildPreferenceSection('Industries', industryPrefs),
            const SizedBox(height: 12),
            _buildPreferenceSection('Locations', locationPrefs),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSection(
    String title,
    Map<String, dynamic> preferences,
  ) {
    final sortedPrefs = preferences.entries.toList()
      ..sort((a, b) => (b.value as int).compareTo(a.value as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        ...sortedPrefs
            .take(3)
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text('${entry.value} applications'),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildActivityMetricsCard() {
    final activity =
        _userAnalytics!['applicationActivity'] as Map<String, dynamic>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Metrics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'This Week',
                    '${activity['applicationsThisWeek'] ?? 0}',
                    Icons.calendar_view_week,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Avg/Month',
                    '${activity['averageApplicationsPerMonth']?.toStringAsFixed(1) ?? '0.0'}',
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Most Active Day',
              _getDayName(activity['mostActiveDay'] ?? 1),
            ),
            _buildInfoRow(
              'Preferred Time',
              '${activity['preferredApplicationTime'] ?? 0}:00',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMetricsCard() {
    final success =
        _userAnalytics!['applicationSuccessMetrics'] as Map<String, dynamic>? ??
        {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Success Metrics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Success Rate',
                    '${success['applicationSuccessRate']?.toStringAsFixed(1) ?? '0.0'}%',
                    Icons.star,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Accepted',
                    '${success['acceptedApplications'] ?? 0}',
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    '${success['pendingApplications'] ?? 0}',
                    Icons.hourglass_empty,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Rejected',
                    '${success['rejectedApplications'] ?? 0}',
                    Icons.cancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[600], size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatMonthKey(String monthKey) {
    final parts = monthKey.split('_');
    if (parts.length == 2) {
      final year = parts[0];
      final month = int.tryParse(parts[1]) ?? 1;
      final monthNames = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${monthNames[month]} $year';
    }
    return monthKey;
  }

  String _getDayName(int day) {
    const dayNames = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return day >= 1 && day <= 7 ? dayNames[day] : 'Unknown';
  }
}
