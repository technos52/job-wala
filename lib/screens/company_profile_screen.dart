import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../services/dropdown_service.dart';
import '../data/locations_data.dart';
import '../widgets/searchable_dropdown.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  static const primaryBlue = Color(0xFF007BFF);

  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _mobileController = TextEditingController();

  String? _selectedIndustry;
  String? _selectedState;
  String? _selectedDistrict;

  List<String> _industryTypes = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCompanyProfile();
    _loadIndustryTypes();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _loadIndustryTypes() async {
    try {
      final industryOptions = await DropdownService.getDropdownOptions(
        'industryType',
      );
      if (industryOptions.isNotEmpty) {
        setState(() {
          _industryTypes = industryOptions;
        });
      } else {
        setState(() {
          _industryTypes = [
            'Information Technology',
            'Healthcare',
            'Finance',
            'Education',
            'Manufacturing',
            'Retail',
            'Construction',
            'Transportation',
            'Hospitality',
            'Agriculture',
          ];
        });
      }
    } catch (e) {
      setState(() {
        _industryTypes = [
          'Information Technology',
          'Healthcare',
          'Finance',
          'Education',
          'Manufacturing',
          'Retail',
          'Construction',
          'Transportation',
          'Hospitality',
          'Agriculture',
        ];
      });
    }
  }

  Future<void> _loadCompanyProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('employers')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            _companyNameController.text = data['companyName'] ?? '';
            _contactPersonController.text = data['contactPerson'] ?? '';
            _mobileController.text = data['mobileNumber'] ?? '';

            // Set industry
            final industryType = data['industryType'] ?? '';
            if (industryType.isNotEmpty) {
              _selectedIndustry = industryType;
            }

            // Set state
            final state = data['state'] ?? '';
            if (state.isNotEmpty) {
              _selectedState = state;
            }

            // Set district
            final district = data['district'] ?? '';
            if (district.isNotEmpty) {
              _selectedDistrict = district;
            }

            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    }
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_companyNameController.text.trim().isEmpty) {
      _showValidationError('Please enter company name');
      return false;
    }

    if (_contactPersonController.text.trim().isEmpty) {
      _showValidationError('Please enter contact person name');
      return false;
    }

    if (_mobileController.text.trim().isEmpty) {
      _showValidationError('Please enter mobile number');
      return false;
    }

    if (_mobileController.text.trim().length != 10) {
      _showValidationError('Please enter a valid 10-digit mobile number');
      return false;
    }

    if (_selectedIndustry == null || _selectedIndustry!.isEmpty) {
      _showValidationError('Please select an industry type');
      return false;
    }

    if (_selectedState == null || _selectedState!.isEmpty) {
      _showValidationError('Please select a state');
      return false;
    }

    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      _showValidationError('Please select a district');
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('employers')
            .doc(user.uid)
            .update({
              'companyName': _companyNameController.text.trim(),
              'contactPerson': _contactPersonController.text.trim(),
              'mobileNumber': _mobileController.text.trim(),
              'industryType': _selectedIndustry!,
              'state': _selectedState!,
              'district': _selectedDistrict!,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully!'),
              backgroundColor: Colors.green.shade500,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Company Profile',
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
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          // Header
                          const Text(
                            'Update Company Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Update your company information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Company Name Field
                          _buildTextField(
                            controller: _companyNameController,
                            label: 'Company Name',
                            hint: 'Enter your company name',
                            icon: Icons.domain_rounded,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Company name is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Contact Person Name Field
                          _buildTextField(
                            controller: _contactPersonController,
                            label: 'Contact Person Name',
                            hint: 'Enter contact person full name',
                            icon: Icons.person_rounded,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Contact person name is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Mobile Number Field
                          _buildTextField(
                            controller: _mobileController,
                            label: 'Mobile Number',
                            hint: 'Enter 10-digit mobile number',
                            icon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Mobile number is required';
                              }
                              if (value!.length != 10) {
                                return 'Please enter a valid 10-digit mobile number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Industry Type Dropdown
                          SearchableDropdown(
                            value: _selectedIndustry,
                            items: _industryTypes,
                            labelText: 'Industry Type',
                            hintText: 'Search and select industry type',
                            prefixIcon: Icons.business_rounded,
                            primaryColor: primaryBlue,
                            onChanged: (value) {
                              setState(() {
                                _selectedIndustry = value;
                              });
                            },
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please select an industry type';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Location Section Header
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 20,
                                color: primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // State Dropdown
                          SearchableDropdown(
                            value: _selectedState,
                            items: indianStates,
                            labelText: 'State',
                            hintText: 'Search and select state',
                            prefixIcon: Icons.location_on_rounded,
                            primaryColor: primaryBlue,
                            onChanged: (value) {
                              setState(() {
                                _selectedState = value;
                                _selectedDistrict =
                                    null; // Reset district when state changes
                              });
                            },
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please select a state';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // District Dropdown
                          SearchableDropdown(
                            value: _selectedDistrict,
                            items: _selectedState != null
                                ? (districtsByState[_selectedState] ??
                                      <String>[])
                                : <String>[],
                            labelText: 'District',
                            hintText: _selectedState != null
                                ? 'Search and select district'
                                : 'Select state first',
                            prefixIcon: Icons.place_rounded,
                            primaryColor: primaryBlue,
                            enabled: _selectedState != null,
                            onChanged: (value) {
                              setState(() {
                                _selectedDistrict = value;
                              });
                            },
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please select a district';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 120,
                          ), // Space for bottom button
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Save Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
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
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            enabled: enabled,
            inputFormatters: inputFormatters,
            validator: validator,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: readOnly || !enabled
                  ? Colors.grey.shade600
                  : const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: primaryBlue.withValues(alpha: 0.6),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
        letterSpacing: 0.3,
      ),
    );
  }
}
