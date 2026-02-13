import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/dropdown_service.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen>
    with SingleTickerProviderStateMixin {
  static const primaryBlue = Color(0xFF007BFF);
  String _companyName = 'Company';
  int _currentBottomNavIndex = 0;
  late PageController _pageController;
  int _currentJobPageIndex = 0;

  // Form controllers
  late final TextEditingController _jobTitleController;
  late final TextEditingController _jobDescriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _salaryRangeController;
  final _formKey = GlobalKey<FormState>();

  // Dropdown values - using ValueNotifier to prevent unnecessary rebuilds
  final ValueNotifier<String?> _selectedDepartment = ValueNotifier(null);
  final ValueNotifier<String?> _selectedIndustryType = ValueNotifier(null);
  final ValueNotifier<String?> _selectedJobCategory = ValueNotifier(null);
  final ValueNotifier<String?> _selectedJobType = ValueNotifier(null);
  final ValueNotifier<String?> _selectedExperienceLevel = ValueNotifier(null);

  // Dropdown options from Firebase
  List<String> _departments = [];
  List<String> _industryTypes = [];
  List<String> _jobCategories = [];
  List<String> _jobTypes = [];
  List<String> _experienceLevels = [];

  bool _isLoadingDropdowns = false;
  bool _isPostingJob = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _jobTitleController = TextEditingController();
    _jobDescriptionController = TextEditingController();
    _locationController = TextEditingController();
    _salaryRangeController = TextEditingController();
    _loadEmployerData();
    _loadDropdownOptions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _locationController.dispose();
    _salaryRangeController.dispose();

    // Dispose ValueNotifiers
    _selectedDepartment.dispose();
    _selectedIndustryType.dispose();
    _selectedJobCategory.dispose();
    _selectedJobType.dispose();
    _selectedExperienceLevel.dispose();

    super.dispose();
  }

  Future<void> _loadEmployerData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final employerDoc = await FirebaseFirestore.instance
            .collection('employers')
            .doc(user.uid)
            .get();

        if (employerDoc.exists) {
          final employerData = employerDoc.data()!;
          if (mounted) {
            setState(() {
              _companyName = employerData['companyName'] ?? 'Company';
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading employer data: $e');
    }
  }

  Future<void> _loadDropdownOptions() async {
    setState(() {
      _isLoadingDropdowns = true;
    });

    try {
      final results = await Future.wait([
        DropdownService.getDropdownOptions('departments'),
        DropdownService.getDropdownOptions('industry_types'),
        DropdownService.getDropdownOptions('job_categories'),
        DropdownService.getDropdownOptions('job_types'),
        DropdownService.getDropdownOptions('experience_levels'),
      ]);

      if (mounted) {
        setState(() {
          _departments = results[0];
          _industryTypes = results[1];
          _jobCategories = results[2];
          _jobTypes = results[3];
          _experienceLevels = results[4];
        });
      }
    } catch (e) {
      debugPrint('Error loading dropdown options: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dropdown options: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDropdowns = false;
        });
      }
    }
  }

  Future<void> _handlePostJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required dropdown selections
    if (_selectedJobCategory.value == null) {
      _showSnackBar('Please select a job category', Colors.red);
      return;
    }
    if (_selectedJobType.value == null) {
      _showSnackBar('Please select a job type', Colors.red);
      return;
    }
    if (_selectedDepartment.value == null) {
      _showSnackBar('Please select a department', Colors.red);
      return;
    }
    if (_selectedExperienceLevel.value == null) {
      _showSnackBar('Please select experience level required', Colors.red);
      return;
    }

    setState(() {
      _isPostingJob = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final jobData = {
        // Company information at top
        'companyName': _companyName,
        'employerId': user.uid,

        // Job basic information
        'jobTitle': _jobTitleController.text.trim(),
        'jobDescription': _jobDescriptionController.text.trim(),
        'department': _selectedDepartment.value,
        'location': _locationController.text.trim(),
        'experienceRequired': _selectedExperienceLevel.value,

        // Job categorization
        'jobCategory': _selectedJobCategory.value,
        'industryType': _selectedIndustryType.value,
        'jobType': _selectedJobType.value,
        'salaryRange': _salaryRangeController.text.trim(),

        // System fields
        'postedDate': FieldValue.serverTimestamp(),
        'approvalStatus': 'pending',
        'applications': 0,
      };

      await FirebaseFirestore.instance.collection('jobs').add(jobData);

      if (mounted) {
        _clearForm();
        _showSnackBar(
          'Job posted successfully! Awaiting admin approval.',
          Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error posting job: $e', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPostingJob = false;
        });
      }
    }
  }

  void _clearForm() {
    _jobTitleController.clear();
    _jobDescriptionController.clear();
    _locationController.clear();
    _salaryRangeController.clear();

    _selectedDepartment.value = null;
    _selectedIndustryType.value = null;
    _selectedJobCategory.value = null;
    _selectedJobType.value = null;
    _selectedExperienceLevel.value = null;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error logging out: $e', Colors.red);
      }
    }
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentBottomNavIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryBlue.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: true, // Enable keyboard avoidance
      body: Stack(
        children: [
          // Main content
          _currentBottomNavIndex == 0 ? _buildJobsPage() : _buildProfilePage(),

          // Bottom navigation
          Positioned(
            left: 40,
            right: 40,
            bottom: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.1),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomNavItem(
                    icon: Icons.work_rounded,
                    label: 'Jobs',
                    index: 0,
                  ),
                  _buildBottomNavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsPage() {
    return Column(
      children: [
        // Header with company name
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryBlue, Color(0xFF0056CC)],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Text(
              'Welcome, $_companyName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Tab navigation for job screens
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: _buildJobTabButton(
                  'Post Job',
                  Icons.add_circle_outline,
                  0,
                ),
              ),
              Expanded(
                child: _buildJobTabButton('Manage Jobs', Icons.list_alt, 1),
              ),
            ],
          ),
        ),

        // PageView for job screens
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentJobPageIndex = index;
              });
            },
            children: [_buildPostJobScreen(), _buildManageJobsScreen()],
          ),
        ),
      ],
    );
  }

  Widget _buildJobTabButton(String title, IconData icon, int index) {
    final isSelected = _currentJobPageIndex == index;

    return InkWell(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? primaryBlue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryBlue : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryBlue : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostJobScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post job form
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_circle, color: primaryBlue, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Post New Job',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (_isLoadingDropdowns)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else ...[
                    // Basic job information
                    _buildFormField(
                      'Job Title',
                      'Enter job title',
                      controller: _jobTitleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter job title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildFormField(
                      'Job Description',
                      'Enter job description',
                      maxLines: 4,
                      controller: _jobDescriptionController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter job description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dropdown fields using ValueNotifier to prevent keyboard flickering
                    _buildOptimizedDropdownField(
                      'Job Category',
                      _selectedJobCategory,
                      _jobCategories,
                      'Select job category',
                    ),
                    const SizedBox(height: 16),

                    _buildOptimizedDropdownField(
                      'Job Type',
                      _selectedJobType,
                      _jobTypes,
                      'Select job type',
                    ),
                    const SizedBox(height: 16),

                    _buildOptimizedDropdownField(
                      'Department',
                      _selectedDepartment,
                      _departments,
                      'Select department',
                    ),
                    const SizedBox(height: 16),

                    _buildOptimizedDropdownField(
                      'Experience Required',
                      _selectedExperienceLevel,
                      _experienceLevels,
                      'Select experience level required',
                    ),
                    const SizedBox(height: 16),

                    _buildOptimizedDropdownField(
                      'Industry Type',
                      _selectedIndustryType,
                      _industryTypes,
                      'Select industry type',
                    ),
                    const SizedBox(height: 16),

                    _buildFormField(
                      'Location',
                      'Enter job location',
                      controller: _locationController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter job location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildFormField(
                      'Salary Range',
                      'e.g., ₹5-8 LPA',
                      controller: _salaryRangeController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter salary range';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Post job button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isPostingJob ? null : _handlePostJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isPostingJob
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Post Job',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Optimized dropdown field that prevents keyboard flickering
  Widget _buildOptimizedDropdownField(
    String label,
    ValueNotifier<String?> selectedValue,
    List<String> options,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<String?>(
          valueListenable: selectedValue,
          builder: (context, value, child) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: value != null ? primaryBlue : const Color(0xFFD1D5DB),
                  width: value != null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      hint,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                  dropdownColor: Colors.white,
                  items: options.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(option),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedValue.value = newValue;
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    String hint, {
    TextEditingController? controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
        ),
      ],
    );
  }

  Widget _buildManageJobsScreen() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where(
            'employerId',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error loading jobs: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final jobs = snapshot.data?.docs ?? [];

        // Sort jobs by posted date on client side
        jobs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aDate = aData['postedDate'] as Timestamp?;
          final bDate = bData['postedDate'] as Timestamp?;

          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;

          return bDate.compareTo(aDate); // Descending order (newest first)
        });

        if (jobs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No jobs posted yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Post your first job to see it here',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.list_alt, color: primaryBlue, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Manage Posted Jobs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Job listings from Firestore
              ...jobs.map((doc) {
                final jobData = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildJobCardFromData(doc.id, jobData),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobCardFromData(String jobId, Map<String, dynamic> jobData) {
    final approvalStatus = jobData['approvalStatus'] ?? 'pending';
    final applications = jobData['applications'] ?? 0;

    // Format posted date
    String postedDate = 'Just now';
    if (jobData['postedDate'] != null) {
      final timestamp = jobData['postedDate'] as Timestamp;
      final date = timestamp.toDate();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        postedDate =
            '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        postedDate =
            '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        postedDate =
            '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      }
    }

    // Determine status color and text
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (approvalStatus) {
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved';
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending Approval';
        statusIcon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  jobData['jobTitle'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 16, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Company name
          Text(
            jobData['companyName'] ?? 'Unknown Company',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Job details row 1
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: Text(
                  jobData['location'] ?? 'Location not specified',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.currency_rupee, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                flex: 1,
                child: Text(
                  jobData['salaryRange'] ?? 'Not specified',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Job details row 2
          Row(
            children: [
              Icon(Icons.work_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                flex: 2,
                child: Text(
                  jobData['jobType'] ?? 'Not specified',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.business_center,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 1,
                child: Text(
                  jobData['department'] ?? 'Not specified',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Experience required row
          if (jobData['experienceRequired'] != null) ...[
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Experience: ${jobData['experienceRequired']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Applications and posted date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$applications application${applications != 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
              Text(
                postedDate,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),

          // Action buttons
          if (approvalStatus == 'approved') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showSnackBar(
                        'View applications feature coming soon!',
                        Colors.blue,
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Applications'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryBlue,
                      side: BorderSide(color: primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showSnackBar(
                        'Edit job feature coming soon!',
                        Colors.blue,
                      );
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit Job'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // User info card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryBlue, Color(0xFF0056CC)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _companyName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'No email',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildProfileMenuItem(
                      'Company Profile',
                      Icons.business,
                      () {
                        _showSnackBar('Company Profile clicked', Colors.blue);
                      },
                    ),
                    _buildProfileMenuItem('Posted Jobs', Icons.work, () {
                      setState(() {
                        _currentBottomNavIndex = 0;
                        _currentJobPageIndex = 1;
                      });
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }),
                    _buildProfileMenuItem('Job Analytics', Icons.analytics, () {
                      _showSnackBar('Job Analytics clicked', Colors.blue);
                    }),
                    _buildProfileMenuItem('Settings', Icons.settings, () {
                      _showSnackBar('Settings clicked', Colors.blue);
                    }),
                    _buildProfileMenuItem('Help & Support', Icons.help, () {
                      _showSnackBar('Help & Support clicked', Colors.blue);
                    }),
                    _buildProfileMenuItem('About Us', Icons.info, () {
                      _showSnackBar('About Us clicked', Colors.blue);
                    }),
                    _buildProfileMenuItem('Logout', Icons.logout, () {
                      _handleLogout();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
