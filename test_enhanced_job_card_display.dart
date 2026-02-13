import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TestEnhancedJobCardDisplay()));
}

class TestEnhancedJobCardDisplay extends StatelessWidget {
  static const primaryBlue = Color(0xFF007BFF);

  // Sample comprehensive job data from Firebase
  final List<Map<String, dynamic>> sampleJobs = [
    {
      'id': 'job_001',
      'jobTitle': 'Senior Flutter Developer',
      'companyName': 'TechCorp Solutions Pvt Ltd',
      'location': 'Bangalore, Karnataka',
      'salaryRange': '₹8-15 LPA',
      'jobType': 'Full Time',
      'jobCategory': 'Information Technology', // Updated from department
      'designation': 'Senior Software Engineer',
      'experienceRequired': '3-5 years',
      'qualification': 'B.Tech/M.Tech in Computer Science',
      'industryType': 'Software Development',
      'jobDescription':
          'We are looking for an experienced Flutter developer to join our mobile development team. You will be responsible for developing cross-platform mobile applications using Flutter framework. The ideal candidate should have strong knowledge of Dart programming language, state management, and mobile app architecture.',
      'postedDate': DateTime.now().subtract(Duration(days: 2)),
      'applications': 45,
    },
    {
      'id': 'job_002',
      'jobTitle': 'Digital Marketing Manager',
      'companyName': 'Creative Marketing Hub',
      'location': 'Mumbai, Maharashtra',
      'salaryRange': '₹6-10 LPA',
      'jobType': 'Full Time',
      'jobCategory': 'Marketing & Sales',
      'designation': 'Marketing Manager',
      'experienceRequired': '2-4 years',
      'qualification': 'MBA in Marketing or equivalent',
      'industryType': 'Digital Marketing',
      'jobDescription':
          'Join our dynamic marketing team as a Digital Marketing Manager. You will lead digital campaigns, manage social media presence, and drive online growth strategies. Experience with Google Ads, Facebook Marketing, and SEO is essential.',
      'postedDate': DateTime.now().subtract(Duration(hours: 6)),
      'applications': 23,
    },
    {
      'id': 'job_003',
      'jobTitle': 'Financial Analyst',
      'companyName': 'Global Finance Corp',
      'location': 'Delhi NCR',
      'salaryRange': '₹5-8 LPA',
      'jobType': 'Full Time',
      'jobCategory': 'Finance & Accounting',
      'designation': 'Senior Analyst',
      'experienceRequired': '1-3 years',
      'qualification': 'CA/CFA/MBA Finance',
      'industryType': 'Financial Services',
      'jobDescription':
          'We are seeking a detail-oriented Financial Analyst to join our finance team. Responsibilities include financial modeling, budget analysis, and preparing financial reports. Strong analytical skills and proficiency in Excel are required.',
      'postedDate': DateTime.now().subtract(Duration(days: 1)),
      'applications': 67,
    },
    {
      'id': 'job_004',
      'jobTitle': 'Remote Content Writer',
      'companyName': 'ContentCraft Agency',
      'location': 'Remote (India)',
      'salaryRange': '₹3-6 LPA',
      'jobType': 'Remote',
      'jobCategory': 'Content & Creative',
      'designation': 'Content Specialist',
      'experienceRequired': '1-2 years',
      'qualification': 'Bachelor\'s in English/Journalism/Mass Communication',
      'industryType': 'Content Marketing',
      'jobDescription':
          'Looking for a creative content writer to produce engaging content for various digital platforms. You will create blog posts, social media content, and marketing materials. Excellent writing skills and SEO knowledge preferred.',
      'postedDate': DateTime.now().subtract(Duration(hours: 12)),
      'applications': 89,
    },
    {
      'id': 'job_005',
      'jobTitle': 'Part-Time Data Entry Operator',
      'companyName': 'DataPro Services',
      'location': 'Chennai, Tamil Nadu',
      'salaryRange': '₹15,000-25,000/month',
      'jobType': 'Part Time',
      'jobCategory': 'Administration',
      'designation': 'Data Entry Specialist',
      'experienceRequired': 'Fresher',
      'qualification': '12th Pass or Graduate',
      'industryType': 'Data Processing',
      'jobDescription':
          'Part-time opportunity for data entry work. Flexible hours, work from office. Basic computer skills and attention to detail required. Perfect for students or those looking for part-time income.',
      'postedDate': DateTime.now().subtract(Duration(days: 3)),
      'applications': 156,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Enhanced Job Cards - All Firebase Data',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Information
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 Complete Job Information Display',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Each job card now displays all essential information from Firebase:',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip('Job Title', Icons.work),
                      _buildInfoChip('Company Name', Icons.business),
                      _buildInfoChip('Location', Icons.location_on),
                      _buildInfoChip('Salary Range', Icons.currency_rupee),
                      _buildInfoChip('Job Type', Icons.schedule),
                      _buildInfoChip('Job Category', Icons.category),
                      _buildInfoChip('Designation', Icons.work_outline),
                      _buildInfoChip('Experience Required', Icons.timeline),
                      _buildInfoChip('Qualification', Icons.school),
                      _buildInfoChip('Industry Type', Icons.domain),
                      _buildInfoChip('Job Description', Icons.description),
                      _buildInfoChip('Posted Date', Icons.calendar_today),
                      _buildInfoChip('Applications Count', Icons.people),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Sample Job Listings (${sampleJobs.length})',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16),

            // Job Cards
            ...sampleJobs.map((job) => _buildEnhancedJobCard(job)).toList(),

            SizedBox(height: 24),

            // Implementation Notes
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
                      Icon(Icons.info, color: primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Implementation Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '✅ Updated from "department" to "jobCategory" field\n'
                    '✅ Added comprehensive job information display\n'
                    '✅ Enhanced visual hierarchy with color-coded icons\n'
                    '✅ Improved card layout with header section\n'
                    '✅ Added industry type and qualification display\n'
                    '✅ Enhanced search functionality for all fields\n'
                    '✅ Better responsive design for different screen sizes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: primaryBlue),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Job Title, Company, and Job Type
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job Title
                          Text(
                            job['jobTitle'] ?? 'Job Title Not Specified',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Company Name
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  job['companyName'] ?? 'Company Not Specified',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Job Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        job['jobType'] ?? 'Full Time',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Salary Row
                Row(
                  children: [
                    // Location
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              job['location'] ?? 'Location Not Specified',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Salary (if available)
                    if (job['salaryRange'] != null &&
                        job['salaryRange'].toString().isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: 18,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            job['salaryRange'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 12),

                // Job Category and Designation Row
                Row(
                  children: [
                    // Job Category
                    if (job['jobCategory'] != null &&
                        job['jobCategory'].toString().isNotEmpty) ...[
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.category,
                              size: 16,
                              color: Colors.purple.shade600,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                job['jobCategory'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Designation/Role
                    if (job['designation'] != null &&
                        job['designation'].toString().isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 16,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                job['designation'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                // Experience and Qualification Row
                if ((job['experienceRequired'] != null &&
                        job['experienceRequired'].toString().isNotEmpty) ||
                    (job['qualification'] != null &&
                        job['qualification'].toString().isNotEmpty)) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Experience Required
                      if (job['experienceRequired'] != null &&
                          job['experienceRequired'].toString().isNotEmpty) ...[
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 16,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Exp: ${job['experienceRequired']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Qualification
                      if (job['qualification'] != null &&
                          job['qualification'].toString().isNotEmpty) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 16,
                                color: Colors.indigo.shade600,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  job['qualification'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Industry Type (if available)
                if (job['industryType'] != null &&
                    job['industryType'].toString().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.domain, size: 16, color: Colors.teal.shade600),
                      const SizedBox(width: 6),
                      Text(
                        'Industry: ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          job['industryType'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Job Description Section
                const SizedBox(height: 16),
                _buildJobDescription(job),

                const SizedBox(height: 16),

                // Footer Section with Posted Date and Apply Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posted ${_formatDate(job['postedDate'])}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (job['applications'] != null &&
                            job['applications'] > 0)
                          Text(
                            '${job['applications']} applications',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                            ),
                          ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showApplyDialog(job),
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('Apply Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: primaryBlue.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
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

  Widget _buildJobDescription(Map<String, dynamic> job) {
    final description = job['jobDescription']?.toString() ?? '';

    if (description.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.grey.shade500),
            SizedBox(width: 8),
            Text(
              'Job description not provided',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, size: 16, color: primaryBlue),
              SizedBox(width: 6),
              Text(
                'Job Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Recently';

    try {
      DateTime date;
      if (timestamp is DateTime) {
        date = timestamp;
      } else {
        return 'Recently';
      }

      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else {
        return 'Recently';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  void _showApplyDialog(Map<String, dynamic> job) {
    // This would typically navigate to application screen or show application dialog
    print('Apply for job: ${job['jobTitle']} at ${job['companyName']}');
  }
}
