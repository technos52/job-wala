import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../services/dropdown_service.dart';
import '../data/locations_data.dart';
import '../widgets/searchable_dropdown.dart';
import '../widgets/responsive_scaffold.dart';
import '../utils/responsive_utils.dart';

class ResponsiveCompanyProfileScreen extends StatefulWidget {
  const ResponsiveCompanyProfileScreen({super.key});

  @override
  State<ResponsiveCompanyProfileScreen> createState() =>
      _ResponsiveCompanyProfileScreenState();
}

class _ResponsiveCompanyProfileScreenState
    extends State<ResponsiveCompanyProfileScreen> {
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
        _showSnackBar('Error loading profile: $e', Colors.red);
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
    _showSnackBar(message, Colors.red);
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 12),
          ),
        ),
        margin: EdgeInsets.all(
          ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
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
          _showSnackBar('Profile updated successfully!', Colors.green);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error updating profile: $e', Colors.red);
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
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(context),
      resizeToAvoidBottomInset: true,
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: primaryBlue,
          size: ResponsiveUtils.getResponsiveIconSize(context, 24),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: ResponsiveText(
        'Company Profile',
        baseFontSize: 18,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
        strokeWidth: ResponsiveUtils.isMobile(context) ? 2 : 3,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getContentHorizontalPadding(context),
              vertical: ResponsiveUtils.getVerticalSpacing(context),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveUtils.getVerticalSpacing(
                      context,
                      large: 24,
                    ),
                  ),
                  _buildHeader(),
                  SizedBox(
                    height: ResponsiveUtils.getVerticalSpacing(
                      context,
                      large: 32,
                    ),
                  ),
                  _buildFormFields(),
                  SizedBox(
                    height:
                        ResponsiveUtils.getResponsiveBottomNavHeight(context) +
                        40,
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildBottomSaveButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ResponsiveText(
          'Update Company Profile',
          baseFontSize: 28,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context, small: 8)),
        ResponsiveText(
          'Update your company information',
          baseFontSize: 14,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    final verticalSpacing = ResponsiveUtils.getVerticalSpacing(
      context,
      large: 20,
    );

    return Column(
      children: [
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
        SizedBox(height: verticalSpacing),
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
        SizedBox(height: verticalSpacing),
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
        SizedBox(height: verticalSpacing),
        _buildDropdownField(
          value: _selectedIndustry,
          items: _industryTypes,
          labelText: 'Industry Type',
          hintText: 'Search and select industry type',
          prefixIcon: Icons.business_rounded,
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
        SizedBox(height: verticalSpacing),

        // Location Section Header
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: 20, color: primaryBlue),
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
        SizedBox(height: verticalSpacing * 0.7),

        _buildDropdownField(
          value: _selectedState,
          items: indianStates,
          labelText: 'State',
          hintText: 'Search and select state',
          prefixIcon: Icons.location_on_rounded,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
              _selectedDistrict = null; // Reset district when state changes
            });
          },
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please select a state';
            }
            return null;
          },
        ),
        SizedBox(height: verticalSpacing),
        _buildDropdownField(
          value: _selectedDistrict,
          items: _selectedState != null
              ? (districtsByState[_selectedState] ?? <String>[])
              : <String>[],
          labelText: 'District',
          hintText: _selectedState != null
              ? 'Search and select district'
              : 'Select state first',
          prefixIcon: Icons.place_rounded,
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
      ],
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
        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context, small: 8)),
        Container(
          height: ResponsiveUtils.getFormFieldHeight(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getResponsiveBorderRadius(context, 12),
            ),
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
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w500,
              color: readOnly || !enabled
                  ? Colors.grey.shade600
                  : const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: primaryBlue.withOpacity(0.6),
                size: ResponsiveUtils.getResponsiveIconSize(context, 20),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalSpacing(
                  context,
                  small: 12,
                  medium: 16,
                  large: 20,
                ),
                vertical: ResponsiveUtils.getVerticalSpacing(
                  context,
                  small: 12,
                  medium: 16,
                  large: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(labelText),
        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context, small: 8)),
        SearchableDropdown(
          value: value,
          items: items,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          primaryColor: primaryBlue,
          enabled: enabled,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return ResponsiveText(
      text,
      baseFontSize: 15,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        ResponsiveUtils.getResponsiveSpacing(context, 24),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ResponsiveButton(
          onPressed: _isSaving ? null : _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.getVerticalSpacing(
                context,
                small: 16,
                medium: 18,
                large: 20,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.getResponsiveBorderRadius(context, 12),
              ),
            ),
            elevation: 0,
          ),
          child: _isSaving
              ? SizedBox(
                  height: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  width: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : ResponsiveText(
                  'Save',
                  baseFontSize: 16,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
