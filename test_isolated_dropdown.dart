import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestIsolatedDropdown());
  }
}

class TestIsolatedDropdown extends StatefulWidget {
  @override
  _TestIsolatedDropdownState createState() => _TestIsolatedDropdownState();
}

class _TestIsolatedDropdownState extends State<TestIsolatedDropdown> {
  final _stateController = TextEditingController();
  bool _showStateDropdown = false;
  List<String> _filteredStates = [];

  static const Map<String, List<String>> _indiaStatesDistricts = {
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Kota'],
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode'],
  };

  @override
  void initState() {
    super.initState();
    _stateController.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final query = _stateController.text.toLowerCase().trim();
    print('🔍 State changed: "$query"');
    print('🎯 Current _showStateDropdown: $_showStateDropdown');

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

      setState(() {
        _filteredStates = filtered;
        _showStateDropdown = filtered.isNotEmpty;
      });
      print(
        '🎯 Updated dropdown state: show=$_showStateDropdown, items=${_filteredStates.length}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Isolated Dropdown')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              color: Colors.yellow.withOpacity(0.2),
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    'Debug Info:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Show Dropdown: $_showStateDropdown'),
                  Text('Filtered States: ${_filteredStates.length}'),
                  Text('Controller Text: "${_stateController.text}"'),
                  if (_filteredStates.isNotEmpty)
                    Text('States: ${_filteredStates.join(", ")}'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Simple dropdown without any interference
            Stack(
              children: [
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hintText: 'Type to search states',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    print('🖱️ Field tapped');
                    if (_stateController.text.trim().isEmpty) {
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
                      elevation: 8,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Builder(
                          builder: (context) {
                            print(
                              '🎨 Building dropdown with ${_filteredStates.length} items',
                            );
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredStates.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_filteredStates[index]),
                                  onTap: () {
                                    print(
                                      '🎯 Selected state: ${_filteredStates[index]}',
                                    );
                                    setState(() {
                                      _stateController.text =
                                          _filteredStates[index];
                                      _showStateDropdown = false;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showStateDropdown = !_showStateDropdown;
                  if (_showStateDropdown) {
                    _filteredStates = _indiaStatesDistricts.keys.toList();
                  }
                });
              },
              child: Text(
                'Toggle Dropdown (${_showStateDropdown ? "Hide" : "Show"})',
              ),
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
