import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';

/// Only shown to staff. Hidden for students in the details screen.
class StaffStatusControls extends StatelessWidget {
  final Incident incident;
  const StaffStatusControls({super.key, required this.incident});

  Future<void> _change(BuildContext context, String status) async {
    if (status == incident.status) return;
    final staff = context.read<AuthProvider>().user!;
    final provider = context.read<IncidentProvider>();
    final ok = await provider.updateStatus(
        staff: staff, incidentId: incident.id, status: status);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? 'Status updated to ${statusLabel(status)}'
            : provider.error ?? 'Update failed')));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.admin_panel_settings_outlined, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text('Staff: update status', style: Theme.of(context).textTheme.titleSmall),
        ]),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: statuses
              .map((s) => ChoiceChip(
                    label: Text(statusLabel(s)),
                    selected: incident.status == s,
                    onSelected: (_) => _change(context, s),
                  ))
              .toList(),
        ),
      ]),
    );
  }
}
