// Add this method to _EditProfileScreenState class

OverlayEntry? _overlayEntry;

void _showStateDropdownOverlay() {
  _removeOverlay();
  
  _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 400, // Adjust based on field position
      left: 20,
      right: 20,
      child: Material(
        elevation: 16,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredStates.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredStates[index]),
                onTap: () {
                  setState(() {
                    _stateController.text = _filteredStates[index];
                    _showStateDropdown = false;
                  });
                  _removeOverlay();
                },
              );
            },
          ),
        ),
      ),
    ),
  );
  
  Overlay.of(context).insert(_overlayEntry!);
}

void _removeOverlay() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}

// In onTap handler, replace setState with:
onTap: () {
  if (_stateController.text.trim().isEmpty) {
    setState(() {
      _filteredStates = _indiaStatesDistricts.keys.toList();
    });
    _showStateDropdownOverlay();
  }
},