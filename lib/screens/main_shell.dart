import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import 'home_screen.dart';
import 'reports_screen.dart';
import 'report_form_screen.dart';
import 'profile_screen.dart';
import 'staff_dashboard_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  late final IncidentProvider _incidents;

  @override
  void initState() {
    super.initState();
    _incidents = context.read<IncidentProvider>()..listen();
  }

  @override
  void dispose() {
    _incidents.stopListening();
    super.dispose();
  }

  void _openForm() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => const ReportFormScreen()));

  @override
  Widget build(BuildContext context) {
    final isStaff = context.watch<AuthProvider>().isStaff;

    // The staff tab only exists for staff accounts
    final pages = <Widget>[
      HomeScreen(
        onReport: _openForm,
        onSeeAll: () => setState(() => _index = 1),
        onCategory: (c) {
          _incidents.setCategoryFilter(c);
          setState(() => _index = 1);
        },
      ),
      const ReportsScreen(),
      if (isStaff) const StaffDashboardScreen(),
      const ProfileScreen(),
    ];
    final tabs = <(IconData, String)>[
      (Icons.home_outlined, 'Home'),
      (Icons.description_outlined, 'Reports'),
      if (isStaff) (Icons.admin_panel_settings_outlined, 'Staff'),
      (Icons.person_outline, 'Profile'),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (var i = 0; i < 2; i++) _navItem(tabs[i].$1, tabs[i].$2, i),
          const SizedBox(width: 48),
          for (var i = 2; i < tabs.length; i++) _navItem(tabs[i].$1, tabs[i].$2, i),
        ]),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int i) {
    final selected = _index == i;
    final color = selected ? Theme.of(context).colorScheme.primary : Colors.grey;
    return InkWell(
      onTap: () => setState(() => _index = i),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ]),
      ),
    );
  }
}
