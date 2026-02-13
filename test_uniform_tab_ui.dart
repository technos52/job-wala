import 'package:flutter/material.dart';

// Test script to verify the uniform horizontal tab UI implementation
void main() {
  runApp(MaterialApp(home: UniformTabUITest()));
}

class UniformTabUITest extends StatefulWidget {
  @override
  _UniformTabUITestState createState() => _UniformTabUITestState();
}

class _UniformTabUITestState extends State<UniformTabUITest> {
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
        title: Text('Uniform Tab UI Test'),
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
              '🎨 Testing Uniform Horizontal Tab UI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Uniform Tab Implementation
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Container(
                  width: 90, // Fixed uniform width
                  margin: const EdgeInsets.only(
                    right: 16,
                  ), // Consistent spacing
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryBlue.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(
                                  color: primaryBlue.withOpacity(0.2),
                                  width: 1,
                                )
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon container with uniform design
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryBlue
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? primaryBlue
                                      : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? primaryBlue.withOpacity(0.25)
                                        : Colors.grey.withOpacity(0.1),
                                    blurRadius: isSelected ? 8 : 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getCategoryIcon(category),
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Category name with uniform typography
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? primaryBlue
                                    : Colors.grey.shade700,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Bottom indicator - uniform design
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: 3,
                              width: isSelected ? 24 : 0,
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(2),
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

          // UI Improvements Summary
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
                    '✨ UI Improvements Made:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildImprovementItem(
                    'Fixed uniform width (90px) for all tabs',
                  ),
                  _buildImprovementItem('Consistent 16px spacing between tabs'),
                  _buildImprovementItem(
                    'Enhanced icon container with borders and shadows',
                  ),
                  _buildImprovementItem(
                    'Improved typography with better line height',
                  ),
                  _buildImprovementItem(
                    'Smooth animations for selection states',
                  ),
                  _buildImprovementItem(
                    'Category-specific icons for better recognition',
                  ),
                  _buildImprovementItem(
                    'Subtle background highlight for selected tabs',
                  ),
                  _buildImprovementItem(
                    'Professional color scheme and visual hierarchy',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementItem(String text) {
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
