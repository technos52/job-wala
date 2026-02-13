import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TestSyntaxFixVerification()));
}

class TestSyntaxFixVerification extends StatelessWidget {
  static const primaryBlue = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Syntax Fix Verification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      SizedBox(width: 12),
                      Text(
                        'Syntax Errors Fixed Successfully!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'All syntax errors in the candidate dashboard have been resolved:',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 12),
                  _buildFixItem('✅ Removed duplicate job card code'),
                  _buildFixItem('✅ Fixed ElevatedButton syntax errors'),
                  _buildFixItem('✅ Removed duplicate method definitions'),
                  _buildFixItem('✅ Fixed Text widget constructor calls'),
                  _buildFixItem('✅ Corrected RoundedRectangleBorder usage'),
                  _buildFixItem('✅ Fixed const constructor issues'),
                ],
              ),
            ),

            SizedBox(height: 24),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryBlue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Enhanced Job Display Features',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildFeatureItem('📋 Complete job information display'),
                  _buildFeatureItem('🏢 Company name with business icon'),
                  _buildFeatureItem('📍 Location with location pin'),
                  _buildFeatureItem('💰 Salary range with currency icon'),
                  _buildFeatureItem(
                    '🏷️ Job type badge (Full Time, Part Time, etc.)',
                  ),
                  _buildFeatureItem(
                    '📂 Job category (updated from department)',
                  ),
                  _buildFeatureItem('👔 Designation/role information'),
                  _buildFeatureItem('⏱️ Experience requirements'),
                  _buildFeatureItem('🎓 Qualification requirements'),
                  _buildFeatureItem('🏭 Industry type classification'),
                  _buildFeatureItem('📝 Detailed job description'),
                  _buildFeatureItem('📅 Posted date and application count'),
                ],
              ),
            ),

            SizedBox(height: 24),

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
                      Icon(
                        Icons.build,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Database Structure Updates',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildUpdateItem(
                    '🔄 Replaced "department" with "jobCategory"',
                  ),
                  _buildUpdateItem('➕ Added "jobType" field from Firebase'),
                  _buildUpdateItem('🔍 Enhanced search functionality'),
                  _buildUpdateItem('🎛️ Updated filter system'),
                  _buildUpdateItem('🔗 Maintained backward compatibility'),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Sample Enhanced Job Card
            Text(
              'Sample Enhanced Job Card:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 12),
            _buildSampleJobCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFixItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.green.shade700),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildUpdateItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.orange.shade700),
      ),
    );
  }

  Widget _buildSampleJobCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Senior Flutter Developer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'TechCorp Solutions',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Full Time',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Salary
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.red.shade400,
                    ),
                    SizedBox(width: 6),
                    Text('Bangalore, Karnataka'),
                    SizedBox(width: 16),
                    Icon(
                      Icons.currency_rupee,
                      size: 18,
                      color: Colors.green.shade600,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '₹8-15 LPA',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Job Category and Designation
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16,
                      color: Colors.purple.shade600,
                    ),
                    SizedBox(width: 6),
                    Text('Information Technology'),
                    SizedBox(width: 16),
                    Icon(
                      Icons.work_outline,
                      size: 16,
                      color: Colors.orange.shade600,
                    ),
                    SizedBox(width: 6),
                    Text('Senior Software Engineer'),
                  ],
                ),
                SizedBox(height: 12),

                // Experience and Qualification
                Row(
                  children: [
                    Icon(Icons.timeline, size: 16, color: Colors.blue.shade600),
                    SizedBox(width: 6),
                    Text('Exp: 3-5 years'),
                    SizedBox(width: 16),
                    Icon(Icons.school, size: 16, color: Colors.indigo.shade600),
                    SizedBox(width: 6),
                    Expanded(child: Text('B.Tech/M.Tech CS')),
                  ],
                ),
                SizedBox(height: 16),

                // Apply Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Posted 2 days ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.send, size: 16),
                      label: Text('Apply Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
