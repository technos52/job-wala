import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/services/dropdown_service.dart';

void main() {
  group('Company Type Implementation Tests', () {
    test(
      'DropdownService should return industry-specific company types',
      () async {
        final companyTypes = await DropdownService.getDropdownOptions(
          'company_types',
        );

        print('📋 Company Types Available: $companyTypes');

        // Check if key industry types are available
        expect(companyTypes.contains('Information Technology (IT)'), true);
        expect(companyTypes.contains('Automobile'), true);
        expect(companyTypes.contains('Automotive'), true);
        expect(companyTypes.contains('Pharmaceutical'), true);
        expect(companyTypes.contains('Healthcare'), true);
        expect(companyTypes.contains('Banking & Finance'), true);
        expect(companyTypes.contains('Manufacturing'), true);
        expect(companyTypes.contains('Retail'), true);
        expect(companyTypes.contains('E-commerce'), true);
        expect(companyTypes.contains('Education'), true);

        print('✅ All expected company types are available');
      },
    );

    test('Company types should include various industries', () async {
      final companyTypes = await DropdownService.getDropdownOptions(
        'companyType',
      );

      // Should have at least 20 different industry types
      expect(companyTypes.length, greaterThan(20));

      // Should include both traditional and modern industries
      expect(companyTypes.any((type) => type.contains('Technology')), true);
      expect(companyTypes.any((type) => type.contains('Automobile')), true);
      expect(companyTypes.any((type) => type.contains('Pharma')), true);

      print(
        '✅ Company types list is comprehensive with ${companyTypes.length} options',
      );
    });

    test('getAllDropdownOptions should include company_types', () async {
      final allOptions = await DropdownService.getAllDropdownOptions();

      expect(allOptions.containsKey('company_types'), true);

      final companyTypes = allOptions['company_types'];
      expect(companyTypes, isNotNull);
      expect(companyTypes!.isNotEmpty, true);

      print('✅ Company types are included in getAllDropdownOptions');
      print('📋 Available categories: ${allOptions.keys.toList()}');
    });
  });
}

// Test widget to verify UI implementation
class TestCompanyTypeWidget extends StatefulWidget {
  @override
  _TestCompanyTypeWidgetState createState() => _TestCompanyTypeWidgetState();
}

class _TestCompanyTypeWidgetState extends State<TestCompanyTypeWidget> {
  String? _selectedCompanyType;
  List<String> _companyTypes = [];

  @override
  void initState() {
    super.initState();
    _loadCompanyTypes();
  }

  Future<void> _loadCompanyTypes() async {
    final types = await DropdownService.getDropdownOptions('company_types');
    setState(() {
      _companyTypes = types;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Company Type Test')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Available Company Types: ${_companyTypes.length}'),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCompanyType,
              decoration: InputDecoration(
                labelText: 'Company Type',
                border: OutlineInputBorder(),
              ),
              items: _companyTypes.map((String type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCompanyType = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            if (_selectedCompanyType != null)
              Text('Selected: $_selectedCompanyType'),
          ],
        ),
      ),
    );
  }
}
