import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestDropdownUIFix());
  }
}

class TestDropdownUIFix extends StatefulWidget {
  @override
  _TestDropdownUIFixState createState() => _TestDropdownUIFixState();
}

class _TestDropdownUIFixState extends State<TestDropdownUIFix> {
  final _stateController = TextEditingController();
  bool _showStateDropdown = false;
  List<String> _filteredStates = [];

  static const Map<String, List<String>> _indiaStatesDistricts = {
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Kota'],
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
      appBar: AppBar(title: Text('Test Dropdown UI Fix')),
      body: GestureDetector(
        onTap: () {
          if (_showStateDropdown) {
            print('🚫 GestureDetector: Closing dropdown');
            setState(() {
              _showStateDropdown = false;
            });
          }
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Debug Info:'),
              Text('Show Dropdown: $_showStateDropdown'),
              Text('Filtered States: ${_filteredStates.length}'),
              Text('Controller Text: "${_stateController.text}"'),
              SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.blue,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'State',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Prevent parent GestureDetector from closing dropdown
                            },
                            child: Stack(
                              children: [
                                TextFormField(
                                  controller: _stateController,
                                  decoration: InputDecoration(
                                    hintText: 'Search or select state',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                  onTap: () {
                                    print('🖱️ State field tapped');
                                    if (_stateController.text.trim().isEmpty) {
                                      print('📋 Showing all states');
                                      setState(() {
                                        _filteredStates = _indiaStatesDistricts
                                            .keys
                                            .toList();
                                        _showStateDropdown = true;
                                      });
                                    } else {
                                      print(
                                        '🔍 Field has text, triggering search',
                                      );
                                      _onStateChanged();
                                    }
                                  },
                                ),
                                if (_showStateDropdown)
                                  Positioned(
                                    top: 48,
                                    left: 0,
                                    right: 0,
                                    child: Material(
                                      elevation: 8,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxHeight: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
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
                                                return InkWell(
                                                  onTap: () {
                                                    print(
                                                      '🎯 Selected state: ${_filteredStates[index]}',
                                                    );
                                                    setState(() {
                                                      _stateController.text =
                                                          _filteredStates[index];
                                                      _showStateDropdown =
                                                          false;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: Colors
                                                              .grey
                                                              .shade200,
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      _filteredStates[index],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
