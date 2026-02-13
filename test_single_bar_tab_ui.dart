import 'package:flutter/material.dart';

// Test script to verify the single bar horizontal tab UI implementation
void main() {
  runApp(MaterialApp(home: SingleBarTabUITest()));
}

class SingleBarTabUITest extends StatefulWidget {
  @override
  _SingleBarTabUITestState createState() => _SingleBarTabUITestState();
}

class _SingleBarTabUITestState extends State<SingleBarTabUITest> {
  final List<String> categories = [
    'All Jobs',
    'Company Jobs',
    'Bank/NBFC Jobs',
    'School Jobs',
    'Hospital Jobs',
    'Government Jobs',
    'Software Development',
    'Data Science',
  ];

  String selectedCategory = 'All Jobs';
  final Color primaryBlue = const Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Single Bar Tab UI Test'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          // Test Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '🎯 Single Uniform Bar Design',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Single Bar Tab Implementation
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Container(
                  width: 100,
                  height: 80,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryBlue : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon with consistent sizing
                            Icon(
                              _getCategoryIcon(category),
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            // Category name
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 30),

          // Selected Category Display
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1),
            ),
            child: Column(
              children: [
                Icon(
                  _getCategoryIcon(selectedCategory),
                  color: primaryBlue,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  'Selected: $selectedCategory',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Design Features
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ Single Bar Design Features:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildFeatureItem(
                    'Unified container with consistent background',
                  ),
                  _buildFeatureItem('Fixed 80px height for perfect alignment'),
                  _buildFeatureItem(
                    '100px width tabs with 4px internal margins',
                  ),
                  _buildFeatureItem('Clean border and rounded corners'),
                  _buildFeatureItem('Selected state fills entire tab area'),
                  _buildFeatureItem('Category-specific icons (22px size)'),
                  _buildFeatureItem('Optimized 9px font size for readability'),
                  _buildFeatureItem('No pixel alignment issues'),
                  _buildFeatureItem('Smooth tap interactions'),
                  _buildFeatureItem('Professional single-bar appearance'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all jobs':
        return Icons.dashboard_outlined;
      case 'company jobs':
        return Icons.corporate_fare;
      case 'bank/nbfc jobs':
        return Icons.account_balance;
      case 'school jobs':
        return Icons.school_outlined;
      case 'hospital jobs':
        return Icons.local_hospital_outlined;
      case 'hotel/bar jobs':
        return Icons.hotel_outlined;
      case 'government jobs':
        return Icons.account_balance_wallet_outlined;
      case 'mall/shopkeeper jobs':
        return Icons.storefront_outlined;
      case 'software development':
        return Icons.code;
      case 'data science':
        return Icons.analytics_outlined;
      case 'marketing':
        return Icons.campaign_outlined;
      case 'finance':
        return Icons.monetization_on_outlined;
      case 'human resources':
        return Icons.people_outline;
      case 'sales':
        return Icons.trending_up;
      case 'customer service':
        return Icons.support_agent;
      case 'engineering':
        return Icons.engineering_outlined;
      case 'design':
        return Icons.design_services_outlined;
      case 'consulting':
        return Icons.business_center_outlined;
      default:
        return Icons.work_outline;
    }
  }
}
