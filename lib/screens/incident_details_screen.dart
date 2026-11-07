import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/constants.dart';
import '../widgets/activity_log.dart';
import '../widgets/category_cover.dart';
import '../widgets/staff_status_controls.dart';
import '../widgets/status_chip.dart';
import '../widgets/status_timeline.dart';

class IncidentDetailsScreen extends StatelessWidget {
  final String incidentId;
  const IncidentDetailsScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context) {
    // Watching the provider keeps this screen live when the status changes
    final all = context.watch<IncidentProvider>().all;
    final matches = all.where((i) => i.id == incidentId);

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Incident details')),
        body: const Center(child: Text('This report is no longer available.')),
      );
    }
    final incident = matches.first;
    final isStaff = context.watch<AuthProvider>().isStaff;
    final scheme = Theme.of(context).colorScheme;
    final cat = categoryFor(incident.category);

    return Scaffold(
      appBar: AppBar(title: const Text('Incident details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CategoryCover(
            category: incident.category,
            height: 150,
            iconSize: 64,
            radius: 20,
            label: cat.label,
          ),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
              child: Icon(cat.icon, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(incident.title, style: Theme.of(context).textTheme.titleLarge),
                Text('${cat.label} • ${incident.location}',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ]),
            ),
            StatusChip(status: incident.status),
          ]),
          const SizedBox(height: 8),
          Text('Reported by ${incident.reporterName} • ${timeAgo(incident.createdAt)}',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          Text('Status timeline', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          StatusTimeline(status: incident.status),
          const SizedBox(height: 24),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(incident.description),
          if (incident.imageUrl != null) ...[
            const SizedBox(height: 24),
            Text('Attached photo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _Photo(url: incident.imageUrl!),
          ],
          if (isStaff) ...[
            const SizedBox(height: 24),
            StaffStatusControls(incident: incident),
          ],
          const SizedBox(height: 24),
          Text('Activity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          ActivityLog(incident: incident),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  final String url;
  const _Photo({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
        errorBuilder: (_, _, _) => const SizedBox(
            height: 120, child: Center(child: Text('Photo could not be loaded'))),
      ),
    );
  }
}
