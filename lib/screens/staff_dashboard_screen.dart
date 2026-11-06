import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';
import '../widgets/incident_card.dart';
import 'incident_details_screen.dart';

/// Staff-only tab: every report in the system, grouped by status.
class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});
  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  String? _status = 'submitted'; // local UI state only

  @override
  Widget build(BuildContext context) {
    final inc = context.watch<IncidentProvider>();
    int count(String s) => inc.all.where((i) => i.status == s).length;
    final items = inc.all.where((i) => _status == null || i.status == _status).toList();

    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Staff dashboard', style: Theme.of(context).textTheme.headlineSmall),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: statuses
                .map((s) => Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => setState(() => _status = s),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: statusColor(s).withValues(alpha: _status == s ? 0.25 : 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: _status == s ? statusColor(s) : Colors.transparent),
                          ),
                          child: Column(children: [
                            Text('${count(s)}',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Text(statusLabel(s), style: const TextStyle(fontSize: 12)),
                          ]),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () => setState(() => _status = null), child: const Text('Show all')),
        ),
        Expanded(
          child: inc.loadingList
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(inc.error ?? 'Nothing here. All caught up!',
                              textAlign: TextAlign.center)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length,
                      itemBuilder: (_, i) => IncidentCard(
                        incident: items[i],
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    IncidentDetailsScreen(incidentId: items[i].id))),
                      ),
                    ),
        ),
      ]),
    );
  }
}
