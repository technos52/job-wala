import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/firebase_options.dart';
import 'lib/services/enhanced_job_application_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('🔍 Testing Enhanced Analytics System...\n');

    // Test 1: Check candidate data structure
    await testCandidateDataStructure();

    // Test 2: Test application service
    await testApplicationService();

    // Test 3: Test analytics queries
    await testAnalyticsQueries();

    // Test 4: Test global statistics
    await testGlobalStatistics();

    print('\n✅ All tests completed successfully!');
  } catch (e) {
    print('❌ Test failed: $e');
  }
}

Future<void> testCandidateDataStructure() async {
  print('📊 Test 1: Checking candidate data structure...');

  try {
    final candidatesSnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .limit(5)
        .get();

    print('   Found ${candidatesSnapshot.docs.length} candidates');

    for (final doc in candidatesSnapshot.docs) {
      final data = doc.data();
      final candidateId = doc.id;

      print('   👤 Candidate: $candidateId');

      // Check if migration was completed
      if (data.containsKey('migrationCompleted')) {
        print('      ✅ Migration completed: ${data['migrationCompleted']}');
      } else {
        print('      ⚠️  Migration status unknown');
      }

      // Check applications array
      final applications = data['applications'] as List<dynamic>? ?? [];
      print('      📋 Applications in main document: ${applications.length}');

      if (applications.isNotEmpty) {
        final firstApp = applications.first as Map<String, dynamic>;
        print('      📝 Sample application fields:');
        print('         - applicationId: ${firstApp['applicationId']}');
        print('         - jobTitle: ${firstApp['jobTitle']}');
        print('         - status: ${firstApp['status']}');
        print('         - appliedDate: ${firstApp['appliedDate']}');
      }

      // Check application stats
      final stats = data['applicationStats'] as Map<String, dynamic>? ?? {};
      if (stats.isNotEmpty) {
        print('      📈 Application statistics:');
        print('         - totalApplications: ${stats['totalApplications']}');
        print(
          '         - monthlyApplications: ${(stats['monthlyApplications'] as Map?)?.keys.length ?? 0} months',
        );
        print(
          '         - jobCategoryPreferences: ${(stats['jobCategoryPreferences'] as Map?)?.keys.length ?? 0} categories',
        );
        print('         - statusCounts: ${stats['statusCounts']}');
      }

      print('');
    }

    print('   ✅ Candidate data structure test passed\n');
  } catch (e) {
    print('   ❌ Candidate data structure test failed: $e\n');
  }
}

Future<void> testApplicationService() async {
  print('🔧 Test 2: Testing application service methods...');

  try {
    // Test getting candidate analytics
    final candidatesSnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .limit(1)
        .get();

    if (candidatesSnapshot.docs.isNotEmpty) {
      final candidateId = candidatesSnapshot.docs.first.id;
      print('   Testing with candidate: $candidateId');

      // Test getCandidateAnalytics
      final analytics =
          await EnhancedJobApplicationService.getCandidateAnalytics(
            candidateId,
          );
      if (analytics != null) {
        print('   ✅ getCandidateAnalytics: Success');
        print('      - Total applications: ${analytics['totalApplications']}');
        print(
          '      - Has application stats: ${analytics['applicationStats'] != null}',
        );
      } else {
        print('   ❌ getCandidateAnalytics: Failed');
      }

      // Test getCandidateApplications with pagination
      final applications =
          await EnhancedJobApplicationService.getCandidateApplications(
            candidateId: candidateId,
            limit: 5,
            offset: 0,
          );
      print(
        '   ✅ getCandidateApplications: Retrieved ${applications.length} applications',
      );

      // Test searchApplications
      final searchResults =
          await EnhancedJobApplicationService.searchApplications(
            candidateId: candidateId,
            status: 'pending',
          );
      print(
        '   ✅ searchApplications: Found ${searchResults.length} pending applications',
      );
    } else {
      print('   ⚠️  No candidates with applications found for testing');
    }

    print('   ✅ Application service test passed\n');
  } catch (e) {
    print('   ❌ Application service test failed: $e\n');
  }
}

Future<void> testAnalyticsQueries() async {
  print('📈 Test 3: Testing analytics queries...');

  try {
    // Test query for candidates with high application counts
    final highActivityCandidates = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applicationStats.totalApplications', isGreaterThan: 5)
        .limit(3)
        .get();

    print(
      '   📊 High activity candidates (>5 applications): ${highActivityCandidates.docs.length}',
    );

    // Test query for recent applications
    final recentDate = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 30)),
    );
    final recentApplications = await FirebaseFirestore.instance
        .collection('candidates')
        .where(
          'applicationStats.lastApplicationDate',
          isGreaterThan: recentDate,
        )
        .limit(5)
        .get();

    print(
      '   📅 Candidates with recent applications (last 30 days): ${recentApplications.docs.length}',
    );

    // Test aggregation query for category preferences
    final candidatesWithPrefs = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applicationStats.jobCategoryPreferences', isNotEqualTo: null)
        .limit(10)
        .get();

    final categoryStats = <String, int>{};
    for (final doc in candidatesWithPrefs.docs) {
      final data = doc.data();
      final prefs =
          data['applicationStats']?['jobCategoryPreferences']
              as Map<String, dynamic>? ??
          {};
      prefs.forEach((category, count) {
        categoryStats[category] =
            (categoryStats[category] ?? 0) + (count as int);
      });
    }

    print('   🏷️  Top job categories from sample:');
    final sortedCategories = categoryStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (int i = 0; i < sortedCategories.length && i < 5; i++) {
      final entry = sortedCategories[i];
      print('      ${i + 1}. ${entry.key}: ${entry.value} applications');
    }

    print('   ✅ Analytics queries test passed\n');
  } catch (e) {
    print('   ❌ Analytics queries test failed: $e\n');
  }
}

Future<void> testGlobalStatistics() async {
  print('🌍 Test 4: Testing global statistics...');

  try {
    final globalStats =
        await EnhancedJobApplicationService.getGlobalApplicationStats();

    print('   📊 Global Statistics:');
    print('      - Total candidates: ${globalStats['totalCandidates']}');
    print('      - Total applications: ${globalStats['totalApplications']}');

    final categoryStats = globalStats['categoryStats'] as Map<String, int>;
    if (categoryStats.isNotEmpty) {
      print('      - Top job categories:');
      final sortedCategories = categoryStats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (int i = 0; i < sortedCategories.length && i < 3; i++) {
        final entry = sortedCategories[i];
        print('         ${i + 1}. ${entry.key}: ${entry.value}');
      }
    }

    final statusStats = globalStats['statusStats'] as Map<String, int>;
    if (statusStats.isNotEmpty) {
      print('      - Application status distribution:');
      statusStats.forEach((status, count) {
        print('         - $status: $count');
      });
    }

    final monthlyTrends = globalStats['monthlyTrends'] as Map<String, int>;
    if (monthlyTrends.isNotEmpty) {
      print('      - Monthly trends (last few months):');
      final sortedMonths = monthlyTrends.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      for (final entry in sortedMonths.take(6)) {
        print('         - ${entry.key}: ${entry.value} applications');
      }
    }

    print('   ✅ Global statistics test passed\n');
  } catch (e) {
    print('   ❌ Global statistics test failed: $e\n');
  }
}

// Test data integrity
Future<void> testDataIntegrity() async {
  print('🔍 Test 5: Testing data integrity...');

  try {
    final candidatesSnapshot = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .limit(10)
        .get();

    int totalIssues = 0;

    for (final doc in candidatesSnapshot.docs) {
      final data = doc.data();
      final candidateId = doc.id;
      final applications = data['applications'] as List<dynamic>? ?? [];
      final stats = data['applicationStats'] as Map<String, dynamic>? ?? {};

      // Check if stats match actual applications
      final actualTotal = applications.length;
      final statsTotal = stats['totalApplications'] ?? 0;

      if (actualTotal != statsTotal) {
        print(
          '   ⚠️  Data mismatch for $candidateId: actual=$actualTotal, stats=$statsTotal',
        );
        totalIssues++;
      }

      // Check status counts
      final statusCounts = <String, int>{};
      for (final app in applications) {
        final status = (app as Map<String, dynamic>)['status'] ?? 'pending';
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }

      final statsStatusCounts =
          stats['statusCounts'] as Map<String, dynamic>? ?? {};
      for (final status in ['pending', 'accepted', 'rejected']) {
        final actual = statusCounts[status] ?? 0;
        final statsCount = statsStatusCounts[status] ?? 0;

        if (actual != statsCount) {
          print(
            '   ⚠️  Status count mismatch for $candidateId ($status): actual=$actual, stats=$statsCount',
          );
          totalIssues++;
        }
      }
    }

    if (totalIssues == 0) {
      print('   ✅ Data integrity test passed - no issues found');
    } else {
      print('   ⚠️  Data integrity test found $totalIssues issues');
    }

    print('');
  } catch (e) {
    print('   ❌ Data integrity test failed: $e\n');
  }
}

// Performance test
Future<void> testPerformance() async {
  print('⚡ Test 6: Testing query performance...');

  try {
    final stopwatch = Stopwatch()..start();

    // Test 1: Get candidate with applications
    final candidateQuery = await FirebaseFirestore.instance
        .collection('candidates')
        .where('applications', isNotEqualTo: null)
        .limit(1)
        .get();

    final candidateTime = stopwatch.elapsedMilliseconds;
    print('   📊 Candidate query time: ${candidateTime}ms');

    if (candidateQuery.docs.isNotEmpty) {
      stopwatch.reset();

      // Test 2: Get analytics data
      final candidateId = candidateQuery.docs.first.id;
      final analytics =
          await EnhancedJobApplicationService.getCandidateAnalytics(
            candidateId,
          );

      final analyticsTime = stopwatch.elapsedMilliseconds;
      print('   📈 Analytics query time: ${analyticsTime}ms');

      stopwatch.reset();

      // Test 3: Get applications with pagination
      final applications =
          await EnhancedJobApplicationService.getCandidateApplications(
            candidateId: candidateId,
            limit: 20,
          );

      final applicationsTime = stopwatch.elapsedMilliseconds;
      print(
        '   📋 Applications query time: ${applicationsTime}ms (${applications.length} apps)',
      );
    }

    stopwatch.reset();

    // Test 4: Global statistics
    final globalStats =
        await EnhancedJobApplicationService.getGlobalApplicationStats();

    final globalTime = stopwatch.elapsedMilliseconds;
    print('   🌍 Global stats query time: ${globalTime}ms');

    print('   ✅ Performance test completed\n');
  } catch (e) {
    print('   ❌ Performance test failed: $e\n');
  }
}
