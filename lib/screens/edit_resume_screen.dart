import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditResumeScreen extends StatefulWidget {
  const EditResumeScreen({super.key});

  @override
  State<EditResumeScreen> createState() => _EditResumeScreenState();
}

class _EditResumeScreenState extends State<EditResumeScreen> {
  static const primaryBlue = Color(0xFF007BFF);

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers for text fields
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _designationController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _districtController = TextEditingController();

  // Data variables
  String? _title;
  String? _gender;
  int? _age;
  String? _maritalStatus;
  String? _state;
  int? _experienceYears;
  int? _experienceMonths;
  bool? _currentlyWorking;
  int? _noticePeriod;
  String? _documentId;

  // Dropdown options
  final List<String> _titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.'];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final candidateDoc = await FirebaseFirestore.instance
            .collection('candidates')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (candidateDoc.docs.isNotEmpty && mounted) {
          final data = candidateDoc.docs.first.data();
          _documentId = candidateDoc.docs.first.id;

          setState(() {
            // Safe string conversions
            _fullNameController.text = (data['fullName']?.toString() ?? '');
            _mobileController.text = (data['mobileNumber']?.toString() ?? '');
            _emailController.text = (data['email']?.toString() ?? '');
            _designationController.text =
                (data['designation']?.toString() ?? '');
            _qualificationController.text =
                (data['qualification']?.toString() ?? '');
            _companyNameController.text =
                (data['companyName']?.toString() ?? '');
            _departmentController.text = (data['department']?.toString() ?? '');
            _districtController.text = (data['district']?.toString() ?? '');

            // Safe string field assignments
            _title = data['title']?.toString();
            _gender = data['gender']?.toString();
            _maritalStatus = data['maritalStatus']?.toString();

            // Safe integer conversion for age
            final ageValue = data['age'];
            if (ageValue is int) {
              _age = ageValue;
            } else if (ageValue is String) {
              _age = int.tryParse(ageValue);
            } else {
              _age = null;
            }

            // Handle state value with case-insensitive matching
            final stateFromDB = data['state']?.toString();
            if (stateFromDB != null) {
              // Find matching state in dropdown list (case-insensitive)
              final matchingState = _states.firstWhere(
                (state) => state.toLowerCase() == stateFromDB.toLowerCase(),
                orElse: () => stateFromDB, // Keep original if no match found
              );
              _state = _states.contains(matchingState) ? matchingState : null;
            } else {
              _state = null;
            }

            // Safe integer conversion for experience years
            final experienceYearsValue = data['experienceYears'];
            if (experienceYearsValue is int) {
              _experienceYears = experienceYearsValue;
            } else if (experienceYearsValue is String) {
              _experienceYears = int.tryParse(experienceYearsValue);
            } else {
              _experienceYears = null;
            }

            // Safe integer conversion for experience months
            final experienceMonthsValue = data['experienceMonths'];
            if (experienceMonthsValue is int) {
              _experienceMonths = experienceMonthsValue;
            } else if (experienceMonthsValue is String) {
              _experienceMonths = int.tryParse(experienceMonthsValue);
            } else {
              _experienceMonths = null;
            }

            // Handle currentlyWorking with proper type conversion
            final currentlyWorkingValue = data['currentlyWorking'];
            if (currentlyWorkingValue is bool) {
              _currentlyWorking = currentlyWorkingValue;
            } else if (currentlyWorkingValue is String) {
              _currentlyWorking = currentlyWorkingValue.toLowerCase() == 'true';
            } else {
              _currentlyWorking = null;
            }

            // Safe integer conversion for notice period
            final noticePeriodValue = data['noticePeriod'];
            if (noticePeriodValue is int) {
              _noticePeriod = noticePeriodValue;
            } else if (noticePeriodValue is String) {
              _noticePeriod = int.tryParse(noticePeriodValue);
            } else {
              _noticePeriod = null;
            }

            _isLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading resume data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveResumeData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_documentId != null) {
        await FirebaseFirestore.instance
            .collection('candidates')
            .doc(_documentId)
            .update({
              'fullName': _fullNameController.text.trim(),
              'mobileNumber': _mobileController.text.trim(),
              'email': _emailController.text.trim(),
              'designation': _designationController.text.trim(),
              'qualification': _qualificationController.text.trim(),
              'companyName': _companyNameController.text.trim(),
              'department': _departmentController.text.trim(),
              'district': _districtController.text.trim(),
              'title': _title,
              'gender': _gender,
              'age': _age,
              'maritalStatus': _maritalStatus,
              'state': _state,
              'experienceYears': _experienceYears,
              'experienceMonths': _experienceMonths,
              'currentlyWorking': _currentlyWorking,
              'noticePeriod': _noticePeriod,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resume updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating resume: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _qualificationController.dispose();
    _companyNameController.dispose();
    _departmentController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Resume',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryBlue,
                            primaryBlue.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_document,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Edit Your Resume Information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Personal Information Section
                    _buildSectionHeader('Personal Information'),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdown(
                      label: 'Title',
                      value: _title,
                      items: _titles,
                      onChanged: (value) => setState(() => _title = value),
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 16),

                    _buildDropdown(
                      label: 'Gender',
                      value: _gender,
                      items: _genders,
                      onChanged: (value) => setState(() => _gender = value),
                      icon: Icons.wc,
                    ),
                    const SizedBox(height: 16),

                    _buildNumberField(
                      label: 'Age',
                      value: _age,
                      onChanged: (value) => setState(() => _age = value),
                      icon: Icons.cake_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildDropdown(
                      label: 'Marital Status',
                      value: _maritalStatus,
                      items: _maritalStatuses,
                      onChanged: (value) =>
                          setState(() => _maritalStatus = value),
                      icon: Icons.favorite_outline,
                    ),

                    const SizedBox(height: 24),

                    // Contact Information Section
                    _buildSectionHeader('Contact Information'),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false, // Email usually shouldn't be editable
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _mobileController,
                      label: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (value.length != 10) {
                          return 'Mobile number should be 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdown(
                      label: 'State',
                      value: _state,
                      items: _states,
                      onChanged: (value) => setState(() => _state = value),
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _districtController,
                      label: 'District',
                      icon: Icons.location_city_outlined,
                    ),

                    const SizedBox(height: 24),

                    // Professional Information Section
                    _buildSectionHeader('Professional Information'),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _designationController,
                      label: 'Current Designation',
                      icon: Icons.work_outline,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _qualificationController,
                      label: 'Qualification',
                      icon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _companyNameController,
                      label: 'Company Name',
                      icon: Icons.business_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _departmentController,
                      label: 'Department',
                      icon: Icons.category_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Experience Section
                    _buildSectionHeader('Experience'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            label: 'Years',
                            value: _experienceYears,
                            onChanged: (value) =>
                                setState(() => _experienceYears = value),
                            icon: Icons.timeline_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            label: 'Months',
                            value: _experienceMonths,
                            onChanged: (value) =>
                                setState(() => _experienceMonths = value),
                            icon: Icons.calendar_month_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Currently Working Switch
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.work_history_outlined,
                            color: primaryBlue,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Currently Working',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Switch(
                            value: _currentlyWorking ?? false,
                            onChanged: (value) {
                              setState(() {
                                _currentlyWorking = value;
                                if (!value) _noticePeriod = null;
                              });
                            },
                            activeThumbColor: primaryBlue,
                          ),
                        ],
                      ),
                    ),

                    if (_currentlyWorking == true) ...[
                      const SizedBox(height: 16),
                      _buildNumberField(
                        label: 'Notice Period (Days)',
                        value: _noticePeriod,
                        onChanged: (value) =>
                            setState(() => _noticePeriod = value),
                        icon: Icons.event_outlined,
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primaryBlue, Color(0xFF0056CC)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveResumeData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
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
                                  'Save Resume Changes',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        enabled: enabled,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: enabled ? const Color(0xFF1F2937) : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          prefixIcon: Icon(icon, color: primaryBlue, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: items.contains(value) ? value : null,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required int? value,
    required Function(int?) onChanged,
    required IconData icon,
  }) {
    final controller = TextEditingController(text: value?.toString() ?? '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          prefixIcon: Icon(icon, color: primaryBlue, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (text) {
          final number = int.tryParse(text);
          onChanged(number);
        },
      ),
    );
  }
}
