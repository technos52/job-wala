import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: JobCardUIImprovementTest()));
}

class JobCardUIImprovementTest extends StatelessWidget {
  static const primaryBlue = Color(0xFF007BFF);

  // Sample job data for testing
  final List<Map<String, dynamic>> sampleJobs = [
    {
      'id': '1',
      'jobTitle': 'Software Engineer',
      'companyName': 'Tech Solutions Pvt Ltd',
      'location': 'Delhi',
      'salaryRange': '₹5-8 LPA',
      'jobType': 'Full Time',
      'department': 'IT',
      'designation': 'Senior Developer',
      'jobDescription':
          'We are looking for a skilled software engineer to join our dynamic team. The ideal candidate should have experience in Flutter, Firebase, and modern development practices.',
      'postedDate': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': '2',
      'jobTitle': 'Marketing Manager',
      'companyName': 'Creative Agency',
      'location': 'Mumbai',
      'salaryRange': '₹6-10 LPA',
      'jobType': 'Full Time',
      'department': 'Marketing',
      'designation': 'Team Lead',
      'jobDescription':
          'Lead our marketing initiatives and drive brand growth through innovative campaigns and strategic planning.',
      'postedDate': DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      'id': '3',
      'jobTitle': 'Data Analyst',
      'companyName': 'Analytics Corp',
      'location': 'Bangalore',
      'salaryRange': '',
      'jobType': 'Remote',
      'department': 'Data Science',
      'designation': 'Junior Analyst',
      'jobDescription': '',
      'postedDate': DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Card UI Improvement'),
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
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Job Card UI Improvements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enhanced job cards now show clear labels alongside icons:',
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Location: [icon] Location: City Name\n'
                    '• Salary: [icon] Salary: Amount\n'
                    '• Department: [icon] Department: Name\n'
                    '• Role: [icon] Role: Designation\n'
                    '• Job Description: [icon] Job Description',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sample Job Cards:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...sampleJobs.map((job) => _buildJobCard(job)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['jobTitle'] ?? 'Job Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['companyName'] ?? 'Company',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job['jobType'] ?? 'Full Time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // IMPROVED: Location with label
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Location: ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Text(
                  job['location'] ?? 'Not specified',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
              if (job['salaryRange'] != null &&
                  job['salaryRange'].toString().isNotEmpty) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.currency_rupee,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Salary: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  job['salaryRange'],
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),

          // IMPROVED: Department and Role with labels
          if (job['department'] != null &&
              job['department'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.business_center,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Department: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  job['department'],
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                if (job['designation'] != null &&
                    job['designation'].toString().isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.work_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Role: ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      job['designation'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],

          // Job Description Section (already has label)
          const SizedBox(height: 12),
          _buildJobDescription(job),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posted ${_formatDate(job['postedDate'])}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDescription(Map<String, dynamic> job) {
    final description = job['jobDescription']?.toString() ?? '';

    String displayText;
    if (description.isEmpty || description == 'null') {
      displayText = 'Job description not provided by employer.';
    } else {
      const maxLength = 120;
      final needsTruncation = description.length > maxLength;
      displayText = needsTruncation
          ? '${description.substring(0, maxLength)}...'
          : description;
    }

    return Container(
      padding: const EdgeInsets.all(12),
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
              Icon(
                Icons.description_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'Job Description',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 13,
              color: description.isEmpty || description == 'null'
                  ? Colors.grey.shade500
                  : Colors.grey.shade600,
              height: 1.4,
              fontStyle: description.isEmpty || description == 'null'
                  ? FontStyle.italic
                  : FontStyle.normal,
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
}
