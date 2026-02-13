import 'package:flutter/material.dart';
import 'lib/screens/employer_dashboard_screen.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employer Dashboard App Name Fix',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TestEmployerDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestEmployerDashboard extends StatelessWidget {
  const TestEmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Dashboard Test'),
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_center, size: 80, color: Color(0xFF007BFF)),
            SizedBox(height: 20),
            Text(
              'Employer Dashboard App Name Fix',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Testing "All Jobs Open" app name addition',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            SizedBox(height: 30),
            TestButton(),
          ],
        ),
      ),
    );
  }
}

class TestButton extends StatelessWidget {
  const TestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EmployerDashboardScreen(),
          ),
        );
      },
      icon: const Icon(Icons.dashboard),
      label: const Text('Test Employer Dashboard'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// EMPLOYER DASHBOARD APP NAME FIX SUMMARY
/*
✅ CHANGES MADE:

1. JOBS PAGE HEADER:
   - Added "All Jobs Open" app name above "Welcome [Company Name]"
   - Used large, bold white text (24px, FontWeight.w700)
   - Maintained blue gradient background
   - Added proper spacing between app name and welcome text

2. PROFILE PAGE HEADER:
   - Added "All Jobs Open" app name above "Profile [Company Name]"
   - Used same styling as Jobs page for consistency
   - Added blue gradient header container
   - Restructured layout to include header with app name

✅ LAYOUT STRUCTURE:
Jobs Page:
- Header Container (Blue Gradient)
  - "All Jobs Open" (App Name)
  - "Welcome [Company Name]" (User Greeting)
- Tab Navigation (Post Job / Manage Jobs)
- Page Content

Profile Page:
- Header Container (Blue Gradient)
  - "All Jobs Open" (App Name)
  - "Profile [Company Name]" (User Greeting)
- Profile Content (Scrollable)

✅ STYLING CONSISTENCY:
- App name: 24px, FontWeight.w700, white color, -0.5 letter spacing
- User greeting: 13px, FontWeight.w500, white color
- Blue gradient background: primaryBlue to Color(0xFF0056CC)
- Proper SafeArea handling for status bar
- Consistent spacing and padding

✅ BENEFITS:
- Brand visibility on all employer screens
- Consistent app identity across candidate and employer sides
- Professional appearance with proper branding
- Maintains existing functionality while adding brand presence

The employer dashboard now displays "All Jobs Open" prominently in both 
the Jobs and Profile sections, matching the branding approach used in 
the candidate sections of the app.
*/
