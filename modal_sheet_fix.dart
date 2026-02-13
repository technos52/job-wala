// Replace the onTap handler with this:

onTap: () {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Select State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _indiaStatesDistricts.keys.length,
              itemBuilder: (context, index) {
                final state = _indiaStatesDistricts.keys.elementAt(index);
                return ListTile(
                  title: Text(state),
                  onTap: () {
                    setState(() {
                      _stateController.text = state;
                      _districtController.clear();
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
},