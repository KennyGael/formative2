import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../models/status_change.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';

/// Shows when the report was submitted and every status change after that.
class ActivityLog extends StatelessWidget {
  final Incident incident;
  const ActivityLog({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<List<StatusChange>>(
      stream: context.read<IncidentProvider>().historyFor(incident.id),
      builder: (context, snap) {
        final changes = snap.data ?? const <StatusChange>[];
        final rows = <_Row>[
          _Row('Submitted', incident.reporterName, incident.createdAt),
          ...changes.map((c) => _Row(statusLabel(c.status), c.changedByName, c.timestamp)),
        ];
        return Column(
          children: rows
              .map((r) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.fiber_manual_record, size: 12, color: scheme.primary),
                    title: Text(r.label),
                    subtitle: Text('${r.by.isEmpty ? '' : '${r.by} • '}${formatDateTime(r.time)}'),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _Row {
  final String label;
  final String by;
  final DateTime? time;
  _Row(this.label, this.by, this.time);
}
