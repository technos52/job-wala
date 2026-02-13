import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationsScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicationsScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  static const primaryBlue = Color(0xFF007BFF);
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Track expanded state for each application card
  final Set<String> _expandedCards = <String>{};

  @override
  void initState() {
    super.initState();
    _loadJobApplications();
  }

  Future<void> _loadJobApplications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      debugPrint('🔍 Loading applications for job: ${widget.jobId}');

      // Load applications from candidate subcollections
      // First, get all candidates
      final candidatesQuery = await FirebaseFirestore.instance
          .collection('candidates')
          .get();

      debugPrint('👥 Found ${candidatesQuery.docs.length} candidates to check');

      final applications = <Map<String, dynamic>>[];

      // Check each candidate's applications subcollection
      for (final candidateDoc in candidatesQuery.docs) {
        final candidateData = candidateDoc.data();
        final candidateId = candidateDoc.id;

        try {
          debugPrint('🔍 Checking applications for candidate: $candidateId');

          // Get applications for this candidate
          final applicationsQuery = await FirebaseFirestore.instance
              .collection('candidates')
              .doc(candidateId)
              .collection('applications')
              .where('jobId', isEqualTo: widget.jobId)
              .get();

          debugPrint(
            '📄 Found ${applicationsQuery.docs.length} applications for candidate $candidateId',
          );

          // Process each application
          for (final appDoc in applicationsQuery.docs) {
            final appData = appDoc.data();

            // Combine application data with candidate data
            applications.add({
              ...appData,
              'documentId': appDoc.id,
              'candidateId': candidateId,
              // Get candidate details from the candidate document with safe type casting
              'candidateName': _safeStringValue(
                candidateData['name'] ?? candidateData['fullName'],
                'Unknown',
              ),
              'candidateEmail': _safeStringValue(
                candidateData['email'] ?? appData['candidateEmail'],
                'Not provided',
              ),
              'candidatePhone': _safeStringValue(
                candidateData['phone'] ??
                    candidateData['phoneNumber'] ??
                    candidateData['mobile'] ??
                    candidateData['mobileNumber'],
                'Not provided',
              ),
              'candidateAge': _safeStringValue(
                candidateData['age'],
                'Not provided',
              ),
              'candidateGender': _safeStringValue(
                candidateData['gender'],
                'Not provided',
              ),
              'candidateLocation': _safeStringValue(
                candidateData['location'] ??
                    candidateData['city'] ??
                    candidateData['address'],
                'Not provided',
              ),
              'candidateState': _safeStringValue(
                candidateData['state'] ?? candidateData['stateProvince'],
                'Not provided',
              ),
              'candidateCity': _safeStringValue(
                candidateData['city'] ?? candidateData['cityName'],
                'Not provided',
              ),
              'candidateQualification': _safeStringValue(
                candidateData['qualification'],
                'Not provided',
              ),
              'candidateExperience': _safeStringValue(
                candidateData['experience'] ?? candidateData['workExperience'],
                'Not provided',
              ),
              'candidateMaritalStatus': _safeStringValue(
                candidateData['maritalStatus'],
                'Not provided',
              ),
              'candidateCompanyType': _safeStringValue(
                candidateData['companyType'] ??
                    candidateData['currentCompany'] ??
                    candidateData['previousCompany'] ??
                    candidateData['company'],
                'Not provided',
              ),
              'candidateJobCategory': _safeStringValue(
                candidateData['jobCategory'],
                'Not provided',
              ),
              'candidateDesignation': _safeStringValue(
                candidateData['designation'] ??
                    candidateData['currentDesignation'] ??
                    candidateData['jobTitle'],
                'Not provided',
              ),
              'candidateCurrentlyWorking': _safeStringValue(
                candidateData['currentlyWorking'] ?? candidateData['isWorking'],
                'Not provided',
              ),
              'candidateNoticePeriod': _safeStringValue(
                candidateData['noticePeriodText'] ??
                    candidateData['noticePeriod'] ??
                    candidateData['noticeperiod'],
                'Not provided',
              ),
            });
          }
        } catch (e) {
          debugPrint('⚠️ Error checking candidate $candidateId: $e');
          // Continue with other candidates
        }
      }

      // Sort applications by applied date (most recent first)
      applications.sort((a, b) {
        final aDate = a['appliedAt'] as Timestamp?;
        final bDate = b['appliedAt'] as Timestamp?;

        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;

        return bDate.compareTo(aDate);
      });

      debugPrint(
        '✅ Loaded ${applications.length} applications for job ${widget.jobId}',
      );

      if (mounted) {
        setState(() {
          _applications = applications;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading applications: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading applications: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  // Helper method to safely convert any value to string
  String _safeStringValue(dynamic value, String fallback) {
    if (value == null) return fallback;
    if (value is String) return value.isEmpty ? fallback : value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is bool) return value ? 'Yes' : 'No';
    return value.toString().isEmpty ? fallback : value.toString();
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      DateTime date;
      if (timestamp is Timestamp) {
        date = timestamp.toDate();
      } else if (timestamp is String) {
        date = DateTime.parse(timestamp);
      } else {
        return 'Unknown';
      }

      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Responsive font sizes
    final titleFontSize = isTablet ? 20.0 : 18.0;
    final subtitleFontSize = isTablet ? 16.0 : 14.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applications',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.jobTitle,
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading applications...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 64.0 : 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: isTablet ? 80.0 : 64.0,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Applications',
                      style: TextStyle(
                        fontSize: isTablet ? 20.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 16.0 : 14.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadJobApplications,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32.0 : 24.0,
                          vertical: isTablet ? 16.0 : 12.0,
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(fontSize: isTablet ? 16.0 : 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _applications.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 64.0 : 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: isTablet ? 80.0 : 64.0,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Applications Yet',
                      style: TextStyle(
                        fontSize: isTablet ? 20.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Applications for this job will appear here',
                      style: TextStyle(
                        fontSize: isTablet ? 16.0 : 14.0,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Header with count
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: primaryBlue,
                        size: isTablet ? 24.0 : 20.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_applications.length} Application${_applications.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: isTablet ? 18.0 : 16.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),

                // Applications list
                Expanded(
                  child: isLargeScreen
                      ? _buildGridLayout()
                      : _buildListLayout(isTablet),
                ),
              ],
            ),
    );
  }

  Widget _buildListLayout(bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      itemCount: _applications.length,
      itemBuilder: (context, index) {
        final application = _applications[index];
        return _buildApplicationCard(application, isTablet: isTablet);
      },
    );
  }

  Widget _buildGridLayout() {
    return GridView.builder(
      padding: const EdgeInsets.all(20.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: _applications.length,
      itemBuilder: (context, index) {
        final application = _applications[index];
        return _buildApplicationCard(application, isTablet: true, isGrid: true);
      },
    );
  }

  Widget _buildApplicationCard(
    Map<String, dynamic> application, {
    bool isTablet = false,
    bool isGrid = false,
  }) {
    final applicationId = application['documentId'] ?? '';
    final isExpanded = _expandedCards.contains(applicationId);

    // Responsive sizing
    final cardPadding = isTablet ? 20.0 : 16.0;
    final nameFontSize = isTablet ? 20.0 : 18.0;
    final dateFontSize = isTablet ? 14.0 : 12.0;
    final sectionFontSize = isTablet ? 16.0 : 14.0;
    final detailFontSize = isTablet ? 15.0 : 13.0;
    final iconSize = isTablet ? 20.0 : 16.0;

    return Card(
      margin: EdgeInsets.only(bottom: isTablet ? 20.0 : 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isExpanded) {
              _expandedCards.remove(applicationId);
            } else {
              _expandedCards.add(applicationId);
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application['candidateName'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isTablet ? 6.0 : 4.0),
                        Text(
                          'Applied on ${_formatDate(application['appliedAt'])}',
                          style: TextStyle(
                            fontSize: dateFontSize,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey.shade600,
                        size: isTablet ? 28.0 : 24.0,
                      ),
                    ],
                  ),
                ],
              ),

              // Collapsed view - show only basic info
              if (!isExpanded) ...[
                SizedBox(height: isTablet ? 16.0 : 12.0),
                Container(
                  padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        Icons.email,
                        'Email',
                        application['candidateEmail'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.phone,
                        'Mobile',
                        application['candidatePhone'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.cake,
                        'Age',
                        application['candidateAge'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.work,
                        'Experience',
                        application['candidateExperience'],
                        hideIfEmpty: true,
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.work_outline,
                        'Currently Working',
                        application['candidateCurrentlyWorking'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.schedule,
                        'Notice Period',
                        application['candidateNoticePeriod'],
                        hideIfEmpty: true,
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 12.0 : 8.0),
                Center(
                  child: Text(
                    'Tap to view all details',
                    style: TextStyle(
                      fontSize: isTablet ? 14.0 : 12.0,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],

              // Expanded view - show all details
              if (isExpanded) ...[
                SizedBox(height: isTablet ? 20.0 : 16.0),
                Container(
                  padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: sectionFontSize,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12.0 : 8.0),
                      _buildDetailRow(
                        Icons.email,
                        'Email',
                        application['candidateEmail'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.phone,
                        'Mobile Number',
                        application['candidatePhone'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),

                      SizedBox(height: isTablet ? 20.0 : 16.0),
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: sectionFontSize,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12.0 : 8.0),
                      _buildDetailRow(
                        Icons.cake,
                        'Age',
                        application['candidateAge'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.person,
                        'Gender',
                        application['candidateGender'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.favorite,
                        'Marital Status',
                        application['candidateMaritalStatus'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),

                      SizedBox(height: isTablet ? 20.0 : 16.0),
                      Text(
                        'Professional Information',
                        style: TextStyle(
                          fontSize: sectionFontSize,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12.0 : 8.0),
                      _buildDetailRow(
                        Icons.school,
                        'Qualification',
                        application['candidateQualification'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.work,
                        'Experience',
                        application['candidateExperience'],
                        hideIfEmpty: true,
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.badge,
                        'Designation',
                        application['candidateDesignation'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),

                      SizedBox(height: isTablet ? 20.0 : 16.0),
                      Text(
                        'Employment Status',
                        style: TextStyle(
                          fontSize: sectionFontSize,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12.0 : 8.0),
                      _buildDetailRow(
                        Icons.work_outline,
                        'Currently Working',
                        application['candidateCurrentlyWorking'],
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                      _buildDetailRow(
                        Icons.schedule,
                        'Notice Period',
                        application['candidateNoticePeriod'],
                        hideIfEmpty: true,
                        fontSize: detailFontSize,
                        iconSize: iconSize,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 12.0 : 8.0),
                Center(
                  child: Text(
                    'Tap to collapse',
                    style: TextStyle(
                      fontSize: isTablet ? 14.0 : 12.0,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String? value, {
    bool hideIfEmpty = false,
    double fontSize = 13.0,
    double iconSize = 16.0,
  }) {
    final displayValue = value ?? 'Not provided';
    final isNotProvided =
        displayValue == 'Not provided' ||
        displayValue == 'Not available' ||
        displayValue.isEmpty;

    // Hide the field completely if hideIfEmpty is true and data is not available
    if (hideIfEmpty && isNotProvided) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: fontSize > 14 ? 6.0 : 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: isNotProvided ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isNotProvided
                    ? Colors.grey.shade500
                    : Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: fontSize,
                color: isNotProvided
                    ? Colors.grey.shade400
                    : const Color(0xFF1F2937),
                fontStyle: isNotProvided ? FontStyle.italic : FontStyle.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
