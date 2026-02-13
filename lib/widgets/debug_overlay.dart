import 'package:flutter/material.dart';

class DebugOverlay extends StatefulWidget {
  final Widget child;

  const DebugOverlay({super.key, required this.child});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  bool _showDebugButton = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showDebugButton)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007BFF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _showDebugMenu(context),
                  icon: const Icon(
                    Icons.bug_report,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showDebugMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF007BFF), Color(0xFF0056CC)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bug_report, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Debug Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDebugTile(
                    context,
                    icon: Icons.settings,
                    title: 'Test Dropdown Service',
                    subtitle: 'Debug dropdown data loading',
                    route: '/test_dropdown',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.list_alt,
                    title: 'Dropdown Debug',
                    subtitle: 'Debug dropdown loading issues',
                    route: '/debug_dropdown',
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.map,
                    title: 'Test Dropdown Mapping',
                    subtitle: 'Test category to document mapping',
                    route: '/test_mapping',
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.build,
                    title: 'Fix Dropdown Data',
                    subtitle: 'Reinitialize dropdown data with correct names',
                    route: '/fix_dropdown',
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.dashboard,
                    title: 'Debug Dashboard',
                    subtitle: 'Test dashboard navigation',
                    route: '/debug_dashboard',
                    color: Colors.cyan,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Simple Dashboard',
                    subtitle: 'Working profile page test',
                    route: '/simple_dashboard',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.data_object,
                    title: 'Test Firebase Data',
                    subtitle: 'Check and initialize Firebase data',
                    route: '/test_firebase',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.play_arrow,
                    title: 'Simple Dropdown Test',
                    subtitle: 'Quick dropdown functionality test',
                    route: '/simple_test',
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.admin_panel_settings,
                    title: 'Admin Dropdown Init',
                    subtitle: 'Initialize dropdown data',
                    route: '/admin_dropdown_init',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.cloud,
                    title: 'Firebase Debug',
                    subtitle: 'Debug Firebase connection',
                    route: '/firebase_debug',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildDebugTile(
                    context,
                    icon: Icons.storage,
                    title: 'Database Test',
                    subtitle: 'Test database operations',
                    route: '/database_test',
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showDebugButton = !_showDebugButton;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _showDebugButton
                                      ? 'Debug button enabled'
                                      : 'Debug button hidden',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            _showDebugButton
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          label: Text(
                            _showDebugButton
                                ? 'Hide Debug Button'
                                : 'Show Debug Button',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
