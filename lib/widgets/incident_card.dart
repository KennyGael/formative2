import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../utils/constants.dart';
import 'category_cover.dart';
import 'status_chip.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback? onTap;
  const IncidentCard({super.key, required this.incident, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cover = CategoryCover(
        category: incident.category, width: 64, height: 64, iconSize: 28, radius: 14);
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      color: scheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            SizedBox(
              width: 64,
              height: 64,
              child: incident.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(incident.imageUrl!,
                          fit: BoxFit.cover, errorBuilder: (_, _, _) => cover),
                    )
                  : cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(incident.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(incident.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.schedule, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(timeAgo(incident.createdAt),
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ]),
              ]),
            ),
            StatusChip(status: incident.status),
          ]),
        ),
      ),
    );
  }
}
