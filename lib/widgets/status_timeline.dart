import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatusTimeline extends StatelessWidget {
  final String status;
  const StatusTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final current = statuses.indexOf(status);
    final scheme = Theme.of(context).colorScheme;

    final children = <Widget>[];
    for (var i = 0; i < statuses.length; i++) {
      final reached = i <= current;
      final color = reached ? statusColor(statuses[i]) : scheme.outlineVariant;

      children.add(Column(children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Icon(
            reached ? Icons.check : Icons.circle,
            size: reached ? 14 : 6,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(statusLabel(statuses[i]),
            style: TextStyle(
                fontSize: 12,
                fontWeight: i == current ? FontWeight.bold : FontWeight.normal,
                color: reached ? scheme.onSurface : scheme.onSurfaceVariant)),
      ]));

      if (i < statuses.length - 1) {
        children.add(Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 11),
            child: Container(
              height: 2,
              color: i < current ? statusColor(statuses[i + 1]) : scheme.outlineVariant,
            ),
          ),
        ));
      }
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
