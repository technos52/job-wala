import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnhancedUserAnalyticsDashboard extends StatefulWidget {
  const EnhancedUserAnalyticsDashboard({super.key});

  @override
  State<EnhancedUserAnalyticsDashboard> createState() =>
      _EnhancedUserAnalyticsDashboardState();
}

class _EnhancedUserAnalyticsDashboardState
    extends State<EnhancedUserAnalyticsDashboard> {
  bool _isLoading = true;
  Map<String, dynamic>? _candidateData;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _loadCandidateData();
  }

  void _initializeUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.phoneNumber ?? user.uid;
    }
  }

  Future<void> _loadCandidateData() async {
    if (_userId == null) return;

    try {
      final candidateDoc = await FirebaseFirestore.instance
          .collection('candidates')
          .doc(_userId)
          .get();

      if (mounted) {
        setState(() {
          _candidateData = candidateDoc.exists ? candidateDoc.data() : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading candidate data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_candidateData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No analytics data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Apply for jobs to see your analytics',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCandidateData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickStatsRow(),
            const SizedBox(height: 16),
            _buildApplicationTrendCard(),
            const SizedBox(height: 16),
            _buildRecentApplicationsCard(),
            const SizedBox(height: 16),
            _buildTopPreferencesCard(),
            const SizedBox(height: 16),
            _buildSuccessMetricsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    // Read from the actual data structure used by _updateUserWithJobApplicationData
    final totalApps = _candidateData!['totalApplications'] ?? 0;
    final recentApplications =
        _candidateData!['recentApplications'] as List<dynamic>? ?? [];
    final applicationActivity =
        _candidateData!['applicationActivity'] as Map<String, dynamic>? ?? {};
    final applicationSuccessMetrics =
        _candidateData!['applicationSuccessMetrics'] as Map<String, dynamic>? ??
        {};

    final thisWeekApps =
        applicationActivity['applicationsThisWeek'] ??
        _getThisWeekApplications(recentApplications);
    final successRate =
        applicationSuccessMetrics['applicationSuccessRate'] ??
        _calculateSuccessRate({});

    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            'Total Applications',
            totalApps.toString(),
            Icons.work_outline,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            'Categories Applied',
            _getUniqueCategoriesCount().toString(),
            Icons.category_outlined,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            'Application Rate',
            '${_getApplicationRate()}/day',
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationTrendCard() {
    final monthlyApps =
        _candidateData!['monthlyApplications'] as Map<String, dynamic>? ?? {};

    if (monthlyApps.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get last 6 months of data
    final sortedEntries = monthlyApps.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final recentEntries = sortedEntries.length > 6
        ? sortedEntries.sublist(sortedEntries.length - 6)
        : sortedEntries;

    final maxValue = recentEntries
        .map((e) => e.value as int)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Application Trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentEntries.map((entry) {
              final height = (entry.value as int) * 100 / maxValue;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        _formatMonthKey(entry.key),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        width: height,
                        child: Center(
                          child: Text(
                            '${entry.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentApplicationsCard() {
    final recentApplications =
        _candidateData!['recentApplications'] as List<dynamic>? ?? [];
    final recentApps = recentApplications.take(3).toList();

    if (recentApps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Recent Applications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentApps.map((app) => _buildCompactApplicationTile(app)),
            if (recentApplications.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    '+ ${recentApplications.length - 3} more applications',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactApplicationTile(Map<String, dynamic> app) {
    final status = app['status']?.toString().toLowerCase() ?? 'pending';

    IconData statusIcon;
    Color statusColor;

    switch (status) {
      case 'accepted':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        break;
      default:
        statusIcon = Icons.hourglass_empty;
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['jobTitle'] ?? 'N/A',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${app['companyName'] ?? 'N/A'} • ${_getLocationDisplay(app)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(statusIcon, color: statusColor, size: 16),
              const SizedBox(height: 2),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopPreferencesCard() {
    final jobCategoryPrefs =
        _candidateData!['jobCategoryPreferences'] as Map<String, dynamic>? ??
        {};
    final locationPrefs =
        _candidateData!['locationPreferences'] as Map<String, dynamic>? ?? {};

    if (jobCategoryPrefs.isEmpty && locationPrefs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite_outline, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Your Preferences',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (jobCategoryPrefs.isNotEmpty) ...[
              Text(
                'Top Job Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              ..._getTopPreferences(jobCategoryPrefs, 3).map(
                (entry) => _buildPreferenceBar(
                  entry.key,
                  entry.value,
                  jobCategoryPrefs.values.reduce((a, b) => a > b ? a : b),
                ),
              ),
            ],
            if (jobCategoryPrefs.isNotEmpty && locationPrefs.isNotEmpty)
              const SizedBox(height: 16),
            if (locationPrefs.isNotEmpty) ...[
              Text(
                'Preferred Locations',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              ..._getTopPreferences(locationPrefs, 3).map(
                (entry) => _buildPreferenceBar(
                  entry.key,
                  entry.value,
                  locationPrefs.values.reduce((a, b) => a > b ? a : b),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceBar(String label, int value, int maxValue) {
    final percentage = (value * 100) / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$value',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMetricsCard() {
    final applicationSuccessMetrics =
        _candidateData!['applicationSuccessMetrics'] as Map<String, dynamic>? ??
        {};

    final accepted = applicationSuccessMetrics['acceptedApplications'] ?? 0;
    final rejected = applicationSuccessMetrics['rejectedApplications'] ?? 0;
    final pending = applicationSuccessMetrics['pendingApplications'] ?? 0;
    final total = accepted + rejected + pending;

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  'Success Metrics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Accepted',
                    '$accepted',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem('Pending', '$pending', Colors.orange),
                ),
                Expanded(
                  child: _buildMetricItem('Rejected', '$rejected', Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // Helper methods
  int _getThisWeekApplications(List<dynamic> applications) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return applications.where((app) {
      final appliedDate = (app['appliedAt'] as DateTime?);
      return appliedDate != null && appliedDate.isAfter(weekStart);
    }).length;
  }

  int _getUniqueCategoriesCount() {
    final jobCategoryPreferences =
        _candidateData!['jobCategoryPreferences'] as Map<String, dynamic>? ??
        {};
    return jobCategoryPreferences.keys.length;
  }

  double _getApplicationRate() {
    final recentApplications =
        _candidateData!['recentApplications'] as List<dynamic>? ?? [];
    if (recentApplications.isEmpty) return 0.0;

    // Calculate applications per day based on recent activity
    final now = DateTime.now();
    final oldestApplication = recentApplications.last['appliedAt'] as DateTime?;

    if (oldestApplication == null) return 0.0;

    final daysDifference = now.difference(oldestApplication).inDays;
    if (daysDifference == 0) return recentApplications.length.toDouble();

    return recentApplications.length / daysDifference;
  }

  double _calculateSuccessRate(Map<String, dynamic> stats) {
    final applicationSuccessMetrics =
        _candidateData!['applicationSuccessMetrics'] as Map<String, dynamic>? ??
        {};
    final accepted = applicationSuccessMetrics['acceptedApplications'] ?? 0;
    final total =
        applicationSuccessMetrics['totalApplications'] ??
        _candidateData!['totalApplications'] ??
        0;

    if (total == 0) return 0.0;
    return (accepted * 100.0) / total;
  }

  String _formatMonthKey(String monthKey) {
    final parts = monthKey.split('_');
    if (parts.length != 2) return monthKey;

    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 1;

    const monthNames = [
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

    return '${monthNames[month - 1]} $year';
  }

  List<MapEntry<String, int>> _getTopPreferences(
    Map<String, dynamic> preferences,
    int count,
  ) {
    final entries =
        preferences.entries.map((e) => MapEntry(e.key, e.value as int)).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return entries.take(count).toList();
  }

  /// Helper method to get location display handling both old and new data formats
  String _getLocationDisplay(Map<String, dynamic> app) {
    // Try location field first
    final location = app['location'];
    if (location != null &&
        location.toString().trim().isNotEmpty &&
        location.toString().trim() != 'N/A') {
      return location.toString().trim();
    }

    // Try old format (district and state fields)
    final district = app['district'];
    final state = app['state'];
    if (district != null && state != null) {
      final districtStr = district.toString().trim();
      final stateStr = state.toString().trim();
      if (districtStr.isNotEmpty &&
          stateStr.isNotEmpty &&
          districtStr != 'N/A' &&
          stateStr != 'N/A') {
        return '$districtStr, $stateStr';
      }
    }

    // Try individual fields as fallback
    if (district != null &&
        district.toString().trim().isNotEmpty &&
        district.toString().trim() != 'N/A') {
      return district.toString().trim();
    }
    if (state != null &&
        state.toString().trim().isNotEmpty &&
        state.toString().trim() != 'N/A') {
      return state.toString().trim();
    }

    return 'Location not specified';
  }
}
