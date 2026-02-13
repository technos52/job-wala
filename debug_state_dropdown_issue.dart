import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DebugStateDropdown());
  }
}

class DebugStateDropdown extends StatefulWidget {
  @override
  _DebugStateDropdownState createState() => _DebugStateDropdownState();
}

class _DebugStateDropdownState extends State<DebugStateDropdown> {
  final _stateController = TextEditingController();
  bool _showStateDropdown = false;
  List<String> _filteredStates = [];

  static const Map<String, List<String>> _indiaStatesDistricts = {
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Nellore',
      'Tirupati',
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Thane',
      'Nashik',
      'Aurangabad',
    ],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli', 'Mangalore', 'Belgaum'],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
    ],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar'],
  };

  @override
  void initState() {
    super.initState();
    _stateController.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    print('🔍 State changed: "${_stateController.text}"');
    final query = _stateController.text.toLowerCase();

    if (query.isEmpty) {
      print('📝 Query is empty, hiding dropdown');
      if (_showStateDropdown) {
        setState(() {
          _filteredStates = [];
          _showStateDropdown = false;
        });
      }
    } else {
      print('🔎 Filtering states with query: "$query"');
      final filtered = _indiaStatesDistricts.keys
          .where((state) => state.toLowerCase().contains(query))
          .toList();

      print('✅ Filtered results: $filtered');

      if (filtered.length != _filteredStates.length || !_showStateDropdown) {
        setState(() {
          _filteredStates = filtered;
          _showStateDropdown = filtered.isNotEmpty;
        });
        print(
          '🎯 Updated dropdown state: show=$_showStateDropdown, items=${_filteredStates.length}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug State Dropdown')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Debug Info:'),
            Text('Show Dropdown: $_showStateDropdown'),
            Text('Filtered States: ${_filteredStates.length}'),
            Text('Controller Text: "${_stateController.text}"'),
            SizedBox(height: 20),

            Stack(
              children: [
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    hintText: 'Search or select state',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    print('🖱️ Field tapped');
                    if (_stateController.text.isEmpty) {
                      print('📋 Showing all states');
                      setState(() {
                        _filteredStates = _indiaStatesDistricts.keys.toList();
                        _showStateDropdown = true;
                      });
                    }
                  },
                ),

                if (_showStateDropdown)
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Material(
                      elevation: 4,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredStates.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_filteredStates[index]),
                              onTap: () {
                                print('🎯 Selected: ${_filteredStates[index]}');
                                setState(() {
                                  _stateController.text =
                                      _filteredStates[index];
                                  _showStateDropdown = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }
}
