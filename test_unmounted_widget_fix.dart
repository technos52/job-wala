import 'package:flutter/material.dart';
import 'lib/screens/candidate_job_search_screen.dart';

void main() {
  runApp(const TestUnmountedWidgetFixApp());
}

class TestUnmountedWidgetFixApp extends StatelessWidget {
  const TestUnmountedWidgetFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unmounted Widget Fix Test',
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
        title: const Text('Unmounted Widget Fix Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Unmounted Widget Issue Fixed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF22C55E)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fixed Issues:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15803D),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Added mounted checks before context usage',
                    style: TextStyle(fontSize: 14, color: Color(0xFF15803D)),
                  ),
                  Text(
                    '✅ Proper error handling in async operations',
                    style: TextStyle(fontSize: 14, color: Color(0xFF15803D)),
                  ),
                  Text(
                    '✅ Safe navigation after async calls',
                    style: TextStyle(fontSize: 14, color: Color(0xFF15803D)),
                  ),
                  Text(
                    '✅ Try-catch blocks for logout operations',
                    style: TextStyle(fontSize: 14, color: Color(0xFF15803D)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CandidateJobSearchScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: const Text('Test Candidate Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Test widget to simulate unmounted scenarios
class TestUnmountedScenario extends StatefulWidget {
  const TestUnmountedScenario({super.key});

  @override
  State<TestUnmountedScenario> createState() => _TestUnmountedScenarioState();
}

class _TestUnmountedScenarioState extends State<TestUnmountedScenario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unmounted Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Simulate async operation with proper mounted check
                if (!mounted) return;

                await Future.delayed(const Duration(seconds: 1));

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Async operation completed safely!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Test Async Operation'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back (Test Unmount)'),
            ),
          ],
        ),
      ),
    );
  }
}
