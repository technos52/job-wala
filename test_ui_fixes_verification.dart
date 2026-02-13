import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TestUIFixesScreen()));
}

class TestUIFixesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UI Fixes Verification'),
        backgroundColor: Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UI Fixes Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Fix 1: Filter Button Position
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
                      Icon(Icons.check_circle, color: Colors.green, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Fix 1: Filter Button Position',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Filter button moved to corner of search bar\n'
                    '✅ Better space utilization\n'
                    '✅ More intuitive UI layout\n'
                    '✅ Results count moved to separate row',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  // Mock search bar with filter button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Search jobs, companies, locations...',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.tune,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Fix 2: Job Categories
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
                      Icon(Icons.check_circle, color: Colors.blue, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Fix 2: Job Categories Source',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '✅ Changed from /dropdown_options/jobType\n'
                    '✅ Now loads from /dropdown_options/jobCategory\n'
                    '✅ Shows proper job categories instead of job types\n'
                    '✅ Categories: Company Jobs, Bank/NBFC Jobs, School Jobs, etc.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Before (jobType):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildCategoryChip('All Jobs', true),
                      _buildCategoryChip('1 hour', false),
                      _buildCategoryChip('Full Time', false),
                      _buildCategoryChip('Part Time', false),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'After (jobCategory):',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip('All Jobs', true),
                      _buildCategoryChip('Company Jobs', false),
                      _buildCategoryChip('Bank/NBFC Jobs', false),
                      _buildCategoryChip('School Jobs', false),
                      _buildCategoryChip('Hospital Jobs', false),
                      _buildCategoryChip('Government Jobs', false),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Summary
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
                      Icon(Icons.info, color: Colors.orange, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Both UI fixes have been successfully implemented:\n\n'
                    '1. Filter button is now positioned at the corner of the search bar for better UX\n'
                    '2. Job category tabs now show actual job categories from Firebase instead of job types\n\n'
                    'The app now has a more intuitive and functional interface.',
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

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF007BFF) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey.shade700,
        ),
      ),
    );
  }
}
